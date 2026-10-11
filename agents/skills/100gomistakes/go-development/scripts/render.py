"""Render rule references from the authoritative catalog, or check derived files."""
import argparse
import json
import re
import sys
from pathlib import Path
from ledger import catalog_rules, read_json


def sentence(text):
    return text.strip().rstrip(".")


def render(catalog):
    rules = catalog_rules(catalog)
    topics = catalog.get("topics")
    if not isinstance(topics, list) or not topics:
        raise ValueError("catalog needs a nonempty topics array")
    grouped = {}
    for topic in topics:
        if not isinstance(topic, dict) or not re.fullmatch(r"[a-z][a-z0-9-]*", str(topic.get("id", ""))):
            raise ValueError("topic identifiers must be lowercase slugs")
        if topic["id"] in grouped:
            raise ValueError("duplicate topic identifier")
        if not all(isinstance(topic.get(k), str) and topic[k].strip() for k in ("title", "trigger")):
            raise ValueError("topics need a title and applicability trigger")
        grouped[topic["id"]] = []
    for rule in rules:
        if not isinstance(rule.get("topic"), str) or rule["topic"] not in grouped:
            raise ValueError(f"{rule['id']}: unknown topic")
        for field in ("when", "then", "because"):
            if not isinstance(rule.get(field), str) or not rule[field].strip():
                raise ValueError(f"{rule['id']}: missing {field}")
        sources = rule.get("sources")
        if not isinstance(sources, list) or not sources or any(not isinstance(s, str) or not s.strip() for s in sources):
            raise ValueError(f"{rule['id']}: missing source identifiers")
        expected = f"references/rules/{rule['topic']}.md#{rule['id'].lower()}"
        if rule.get("reference") != expected:
            raise ValueError(f"{rule['id']}: reference must be {expected}")
        if rule.get("example"):
            example = rule["example"]
            if not isinstance(example, dict) or not all(isinstance(example.get(k), str) and example[k].strip() for k in ("label", "path")):
                raise ValueError(f"{rule['id']}: example needs label and path")
        grouped[rule["topic"]].append(rule)
    outputs = {}
    router = ["# Topic router", "", "Read each topic's trigger list before excluding its rules. The task ledger retains every rule until a decision is recorded.", ""]
    index = ["# Rule applicability index", "", "This generated index supports screening. Load the detailed topic reference for applicable or uncertain rules.", ""]
    for topic in topics:
        topic_id = topic["id"]
        relative = f"rules/{topic_id}.md"
        router.append(f"- [{topic['title']}]({relative}): {topic['trigger']}")
        index.extend([f"## {topic['title']}", ""])
        lines = [f"# {topic['title']}", "", f"Load when: {topic['trigger']}", ""]
        for rule in grouped[topic_id]:
            rule_id = rule["id"]
            anchor = rule_id.lower()
            index.append(f"- [{rule_id}]({relative}#{anchor}): {rule['when']}")
            lines.extend([f'<a id="{anchor}"></a>', "", f"- **{rule_id}** When {sentence(rule['when'])}. Then {sentence(rule['then'])}. Because {sentence(rule['because'])}.", "", "  Sources: " + ", ".join(f"`{s}`" for s in rule["sources"]) + ".", ""])
            if rule.get("example"):
                lines.extend([f"  Example: [{rule['example']['label']}]({rule['example']['path']}).", ""])
        outputs[f"references/rules/{topic_id}.md"] = "\n".join(lines).rstrip() + "\n"
        index.append("")
    outputs["references/topics.md"] = "\n".join(router).rstrip() + "\n"
    outputs["references/rule-index.md"] = "\n".join(index).rstrip() + "\n"
    return outputs


def compare(root, outputs):
    errors = []
    for relative, expected in outputs.items():
        path = root / relative
        if not path.is_file() or path.read_text(encoding="utf-8") != expected:
            errors.append(f"missing or stale generated file: {relative}")
    rules_directory = root / "references" / "rules"
    if rules_directory.is_dir():
        for path in rules_directory.glob("*.md"):
            relative = path.relative_to(root).as_posix()
            if relative not in outputs:
                errors.append(f"orphaned generated topic file: {relative}")
    return errors


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--catalog", required=True, help="catalog path; generated references live beside it")
    parser.add_argument("--check", action="store_true", help="read-only check of generated references")
    args = parser.parse_args(argv)
    try:
        path = Path(args.catalog)
        catalog = read_json(path)
        outputs = render(catalog)
        if args.check:
            errors = compare(path.parent, outputs)
            print(json.dumps({"schema_version": 1, "valid": not errors, "errors": errors}))
            return 3 if errors else 0
        for relative, content in outputs.items():
            output = path.parent / relative
            output.parent.mkdir(parents=True, exist_ok=True)
            output.write_text(content, encoding="utf-8")
        print(json.dumps({"schema_version": 1, "generated": sorted(outputs)}))
        return 0
    except (OSError, ValueError) as error:
        print(json.dumps({"schema_version": 1, "code": "input_error", "message": str(error)}), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
