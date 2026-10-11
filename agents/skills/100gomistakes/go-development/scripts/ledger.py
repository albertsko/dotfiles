"""Create and verify complete Go-rule decision ledgers. Python standard library only."""
import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

SCHEMA = 1


def unique_object(pairs):
    result = {}
    for key, value in pairs:
        if key in result:
            raise ValueError(f"duplicate JSON key: {key}")
        result[key] = value
    return result


def read_json(path):
    return json.loads(Path(path).read_text(encoding="utf-8"), object_pairs_hook=unique_object)


def catalog_rules(catalog):
    rules = catalog.get("rules") if isinstance(catalog, dict) else None
    if not isinstance(rules, list) or not rules:
        raise ValueError("catalog must contain a nonempty rules array")
    ids = []
    for rule in rules:
        if not isinstance(rule, dict) or not re.fullmatch(r"G[1-9][0-9]*", str(rule.get("id", ""))):
            raise ValueError("each catalog rule needs a stable G identifier")
        ids.append(rule["id"])
    if len(ids) != len(set(ids)):
        raise ValueError("catalog contains duplicate rule identifiers")
    return rules


def fingerprint(catalog):
    canonical = json.dumps(catalog, sort_keys=True, separators=(",", ":"), ensure_ascii=True)
    return hashlib.sha256(canonical.encode()).hexdigest()


def initialize(catalog):
    rules = catalog_rules(catalog)
    return {
        "schema_version": SCHEMA,
        "catalog_sha256": fingerprint(catalog),
        "scope": {"repository": "", "task": "", "supported_go_versions": "", "toolchains": "", "platforms": "", "inspected_paths": []},
        "decisions": [{"id": r["id"], "status": "pending", "reason": "", "evidence": []} for r in rules],
    }


def nonempty(value):
    return isinstance(value, str) and bool(value.strip())


def verify(catalog, ledger):
    rules = catalog_rules(catalog)
    errors = []
    if not isinstance(ledger, dict):
        return ["ledger must be a JSON object"], {}
    if type(ledger.get("schema_version")) is not int or ledger.get("schema_version") != SCHEMA:
        errors.append("unsupported or missing ledger schema_version")
    if ledger.get("catalog_sha256") != fingerprint(catalog):
        errors.append("catalog changed: reconcile all rule decisions and refresh catalog_sha256")
    scope = ledger.get("scope")
    if not isinstance(scope, dict):
        errors.append("scope must be an object")
    else:
        for field in ("repository", "task", "supported_go_versions", "toolchains", "platforms"):
            if not nonempty(scope.get(field)):
                errors.append(f"scope.{field} needs a nonempty description")
        paths = scope.get("inspected_paths")
        if not isinstance(paths, list) or not paths or any(not nonempty(p) for p in paths):
            errors.append("scope.inspected_paths needs at least one inspected path")
    decisions = ledger.get("decisions")
    if not isinstance(decisions, list):
        return errors + ["decisions must be an array"], {}
    expected = {r["id"] for r in rules}
    seen = set()
    counts = {}
    for index, row in enumerate(decisions):
        if not isinstance(row, dict):
            errors.append(f"decision {index} must be an object")
            continue
        rule_id = row.get("id")
        if not isinstance(rule_id, str) or rule_id not in expected:
            errors.append(f"unknown rule identifier at decision {index}: {rule_id!r}")
            continue
        if rule_id in seen:
            errors.append(f"duplicate decision: {rule_id}")
        seen.add(rule_id)
        status = row.get("status")
        if status not in ("pass", "not_applicable", "pending", "blocked", "fail"):
            errors.append(f"{rule_id}: invalid status")
            continue
        counts[status] = counts.get(status, 0) + 1
        if not nonempty(row.get("reason")):
            errors.append(f"{rule_id}: reason must describe applicability and decision")
        evidence = row.get("evidence")
        if not isinstance(evidence, list) or any(not nonempty(e) for e in evidence):
            errors.append(f"{rule_id}: evidence must be an array of nonempty strings")
        elif status in ("pass", "not_applicable") and not evidence:
            errors.append(f"{rule_id}: {status} requires inspection or execution evidence")
        if status in ("pending", "blocked", "fail"):
            errors.append(f"{rule_id}: unresolved {status}")
    for rule_id in sorted(expected - seen, key=lambda s: int(s[1:])):
        errors.append(f"missing decision: {rule_id}")
    return errors, counts


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, epilog="See ../references/verification.md. All commands are noninteractive. Exit 3 means incomplete or invalid ledger.")
    commands = parser.add_subparsers(dest="command", required=True)
    for name in ("init", "verify"):
        sub = commands.add_parser(name)
        sub.add_argument("--catalog", required=True, help="JSON rule catalog path")
        if name == "init":
            sub.add_argument("--output", required=True, help="new ledger path, created exclusively")
        else:
            sub.add_argument("--ledger", required=True, help="completed JSON ledger path")
    args = parser.parse_args(argv)
    try:
        catalog = read_json(args.catalog)
        if args.command == "init":
            ledger = initialize(catalog)
            with Path(args.output).open("x", encoding="utf-8") as stream:
                stream.write(json.dumps(ledger, indent=2) + "\n")
            result = {"schema_version": SCHEMA, "created": args.output, "rule_count": len(ledger["decisions"])}
            print(json.dumps(result))
            return 0
        errors, counts = verify(catalog, read_json(args.ledger))
        result = {"schema_version": SCHEMA, "complete": not errors, "counts": counts, "errors": errors}
        print(json.dumps(result, indent=2))
        return 3 if errors else 0
    except (OSError, ValueError) as error:
        print(json.dumps({"schema_version": SCHEMA, "code": "input_error", "message": str(error)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
