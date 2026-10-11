"""Check source accounting, rule links, local references, and generated files."""
import argparse
import json
import re
import sys
from pathlib import Path
from urllib.parse import unquote, urlsplit
from ledger import catalog_rules, read_json
from render import compare, render


def records(document, key):
    value = document.get(key) if isinstance(document, dict) else None
    if not isinstance(value, list) or any(not isinstance(row, dict) for row in value):
        raise ValueError(f"{key} must be an array of objects")
    return value


def string_ids(value, label):
    if not isinstance(value, list) or any(not isinstance(item, str) or not item for item in value):
        raise ValueError(f"{label} must be an array of nonempty identifiers")
    return value


def index(rows, key, label, errors):
    result = {}
    for row in rows:
        identity = row.get(key)
        if not isinstance(identity, str) or not identity:
            errors.append(f"{label}: missing {key}")
            continue
        if identity in result:
            errors.append(f"{label}: duplicate {identity}")
        result[identity] = row
    return result


def same_ids(actual, expected, label, errors):
    missing = sorted(set(expected) - set(actual))
    extra = sorted(set(actual) - set(expected))
    if missing:
        errors.append(f"{label}: missing {', '.join(map(str, missing))}")
    if extra:
        errors.append(f"{label}: unexpected {', '.join(map(str, extra))}")


def reconcile(canonical, rows, expected_raw, label, errors, allow_unmapped=False):
    mappings = index(rows, "raw_id", label, errors)
    same_ids(mappings, expected_raw, label, errors)
    for raw_id, row in mappings.items():
        targets = string_ids(row.get("unified_ids"), f"{raw_id}.unified_ids")
        if len(targets) != len(set(targets)):
            errors.append(f"{raw_id}: duplicate canonical targets")
        if not targets:
            if not allow_unmapped:
                errors.append(f"{raw_id}: actionable book practice has no canonical target")
            if not isinstance(row.get("reason"), str) or not row["reason"].strip():
                errors.append(f"{raw_id}: unmapped source needs an explicit reason")
        for target in targets:
            if target not in canonical:
                errors.append(f"{raw_id}: unknown canonical target {target}")
            elif raw_id not in canonical[target].get("raw_ids", []):
                errors.append(f"{raw_id}: missing reverse provenance in {target}")
    for source_id, row in canonical.items():
        raw_ids = string_ids(row.get("raw_ids"), f"{source_id}.raw_ids")
        if len(raw_ids) != len(set(raw_ids)):
            errors.append(f"{source_id}: duplicate reverse provenance")
        if not raw_ids:
            errors.append(f"{source_id}: no investigation provenance")
        for raw_id in raw_ids:
            if raw_id not in mappings or source_id not in mappings[raw_id].get("unified_ids", []):
                errors.append(f"{source_id}: invalid reverse provenance {raw_id}")


def prose(text):
    lines = []
    fence = None
    for line in text.splitlines():
        stripped = line.lstrip()
        marker = stripped[:3]
        if marker in ("```", "~~~"):
            if fence is None:
                fence = marker
            elif fence == marker:
                fence = None
            continue
        if fence is None:
            lines.append(line)
    return "\n".join(lines)


def anchors(text):
    found = set(re.findall(r'<a\s+id="([^"]+)"', text))
    counts = {}
    for heading in re.findall(r"^#{1,6}\s+(.+)$", prose(text), re.MULTILINE):
        slug = re.sub(r"[^\w\s-]", "", heading.lower()).strip().replace(" ", "-")
        occurrence = counts.get(slug, 0)
        counts[slug] = occurrence + 1
        found.add(slug if occurrence == 0 else f"{slug}-{occurrence}")
    return found


def check_links(root):
    errors = []
    root = root.resolve()
    for path in root.rglob("*.md"):
        text = prose(path.read_text(encoding="utf-8"))
        text = re.sub(r"`[^`\n]*`", "", text)
        for target in re.findall(r"\[[^\]\n]+\]\(([^\s)]+)\)", text):
            target = target.strip("<>")
            parsed = urlsplit(target)
            if parsed.scheme in ("http", "https", "mailto"):
                continue
            label = path.relative_to(root).as_posix()
            if parsed.scheme or parsed.netloc:
                errors.append(f"{label}: unsupported local link {target}")
                continue
            linked = (path.parent / unquote(parsed.path)).resolve() if parsed.path else path
            if not linked.is_relative_to(root):
                errors.append(f"{label}: link leaves portable package: {target}")
                continue
            if not linked.exists():
                errors.append(f"{label}: missing local target {target}")
                continue
            if parsed.fragment and linked.suffix == ".md":
                if unquote(parsed.fragment) not in anchors(linked.read_text(encoding="utf-8")):
                    errors.append(f"{label}: missing anchor {target}")
    return errors


def check_bundle(root):
    catalog = read_json(root / "catalog.json")
    book = read_json(root / "data/book.json")
    releases = read_json(root / "data/releases.json")
    baseline = read_json(root / "data/baseline.json")
    coverage = read_json(root / "coverage.json")
    errors = []
    rules = index(catalog_rules(catalog), "id", "catalog", errors)
    book_items = index(records(book, "practices"), "id", "book", errors)
    release_items = index(records(releases, "items"), "id", "releases", errors)
    for field in ("canonical_book_ids", "canonical_release_ids", "raw_book_ids", "raw_release_ids", "release_versions"):
        values = string_ids(baseline.get(field), f"baseline.{field}")
        if len(values) != len(set(values)):
            errors.append(f"baseline.{field}: duplicate identifiers")
    same_ids(book_items, baseline["canonical_book_ids"], "book canonical sources", errors)
    same_ids(release_items, baseline["canonical_release_ids"], "release canonical sources", errors)
    reconcile(book_items, records(book, "raw_to_unified_reconciliation"), baseline["raw_book_ids"], "book reconciliation", errors)
    reconcile(release_items, records(releases, "raw_reconciliation"), baseline["raw_release_ids"], "release reconciliation", errors, allow_unmapped=True)
    mistakes = set()
    for row in book_items.values():
        values = row.get("mistake_numbers")
        if not isinstance(values, list) or any(type(value) is not int for value in values):
            raise ValueError(f"{row['id']}.mistake_numbers must be an integer array")
        mistakes.update(values)
    same_ids(mistakes, range(1, 101), "book mistake coverage", errors)
    versions = set(string_ids([row.get("version") for row in release_items.values()], "release versions"))
    same_ids(versions, baseline["release_versions"], "release version coverage", errors)
    book_anchors = baseline.get("book_anchors")
    release_anchors = baseline.get("release_anchors")
    if not isinstance(book_anchors, dict) or not isinstance(release_anchors, dict):
        raise ValueError("baseline needs book_anchors and release_anchors objects")
    for source_id, row in book_items.items():
        for field in ("when", "then", "because"):
            if not isinstance(row.get(field), str) or not row[field].strip():
                errors.append(f"{source_id}: missing canonical {field}")
        if not isinstance(row.get("caveats"), list) or any(not isinstance(value, str) for value in row["caveats"]):
            errors.append(f"{source_id}: canonical caveats must remain an array of text")
        locators = records(row, "source_locators")
        if not locators:
            errors.append(f"{source_id}: missing EPUB locator")
        for locator in locators:
            member, anchor = locator.get("source_member"), locator.get("anchor")
            if not isinstance(member, str) or anchor not in book_anchors.get(member, []):
                errors.append(f"{source_id}: EPUB locator absent from source snapshot")
    for source_id, row in release_items.items():
        for field in ("summary", "implication_applicability"):
            if not isinstance(row.get(field), str) or not row[field].strip():
                errors.append(f"{source_id}: missing canonical {field}")
        locators = records(row, "sources")
        primary = f"https://go.dev/doc/go{row['version']}"
        if not any(locator.get("url") == primary for locator in locators):
            errors.append(f"{source_id}: missing primary release locator")
        for locator in locators:
            url, anchor = locator.get("url"), locator.get("anchor")
            if not isinstance(url, str) or not url.startswith("https://"):
                errors.append(f"{source_id}: invalid official source URL")
            elif url in release_anchors and anchor not in release_anchors[url]:
                errors.append(f"{source_id}: release anchor absent from source snapshot")
    sources = {**book_items, **release_items}
    dispositions = index(records(coverage, "sources"), "id", "source dispositions", errors)
    same_ids(dispositions, sources, "source dispositions", errors)
    for source_id, row in dispositions.items():
        target_ids = string_ids(row.get("rule_ids"), f"{source_id}.rule_ids")
        if len(target_ids) != len(set(target_ids)):
            errors.append(f"{source_id}: duplicate rule targets")
        for field in ("disposition", "reason"):
            if not isinstance(row.get(field), str) or not row[field].strip():
                errors.append(f"{source_id}: {field} must be explicit")
        if source_id in book_items and not target_ids:
            errors.append(f"{source_id}: book guidance lacks a current or version-gated rule")
        for rule_id in target_ids:
            if rule_id not in rules or source_id not in rules[rule_id].get("sources", []):
                errors.append(f"{source_id}: invalid reverse rule target {rule_id}")
    for rule_id, row in rules.items():
        source_ids = string_ids(row.get("sources"), f"{rule_id}.sources")
        if len(source_ids) != len(set(source_ids)):
            errors.append(f"{rule_id}: duplicate source identifiers")
        for source_id in source_ids:
            if source_id not in sources:
                errors.append(f"{rule_id}: unknown source {source_id}")
            elif source_id not in dispositions or rule_id not in dispositions[source_id].get("rule_ids", []):
                errors.append(f"{rule_id}: missing reverse source disposition {source_id}")
    errors.extend(compare(root, render(catalog)))
    errors.extend(check_links(root))
    counts = {"rules": len(rules), "topics": len(catalog["topics"]), "book_practices": len(book_items), "release_groups": len(release_items), "book_raw_records": len(baseline["raw_book_ids"]), "release_raw_records_and_units": len(baseline["raw_release_ids"])}
    return errors, counts


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__, epilog="Exit 0: valid structure. Exit 3: detected gaps. This does not prove semantic correctness.")
    parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parent.parent, help="portable skill directory (defaults to this script's package)")
    args = parser.parse_args(argv)
    try:
        errors, counts = check_bundle(args.root)
        print(json.dumps({"schema_version": 1, "valid": not errors, "counts": counts, "errors": errors}, indent=2))
        return 3 if errors else 0
    except (OSError, ValueError) as error:
        print(json.dumps({"schema_version": 1, "code": "input_error", "message": str(error)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
