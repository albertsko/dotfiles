import copy
import json
import tempfile
import unittest
from pathlib import Path
import check
import render


def fixture(root):
    practices = []
    book_rows = []
    for number in range(1, 101):
        identity, raw = f"BP{number}", f"BA-{number:03}"
        practices.append({"id": identity, "when": "a condition applies", "then": "inspect behavior", "because": "behavior matters", "caveats": [], "mistake_numbers": [number], "raw_ids": [raw], "source_locators": [{"source_member": "chapter.htm", "anchor": "section"}]})
        book_rows.append({"raw_id": raw, "unified_ids": [identity]})
    releases, release_rows = [], []
    for number, minor in enumerate(range(18, 28), 1):
        identity, raw = f"RV{number}", f"RA-{minor}-001"
        releases.append({"id": identity, "version": f"1.{minor}", "summary": "A behavior changed.", "implication_applicability": "Inspect affected calls.", "raw_ids": [raw], "sources": [{"url": f"https://go.dev/doc/go1.{minor}", "anchor": "section"}]})
        release_rows.append({"raw_id": raw, "unified_ids": [identity]})
    source_ids = [row["id"] for row in practices + releases]
    catalog = {"topics": [{"id": "example", "title": "Example", "trigger": "Example scope applies."}], "rules": [{"id": "G1", "topic": "example", "when": "example scope applies", "then": "inspect it", "because": "evidence establishes the result", "sources": source_ids, "reference": "references/rules/example.md#g1"}]}
    documents = {
        "catalog.json": catalog,
        "data/book.json": {"practices": practices, "raw_to_unified_reconciliation": book_rows},
        "data/releases.json": {"items": releases, "raw_reconciliation": release_rows},
        "coverage.json": {"sources": [{"id": identity, "rule_ids": ["G1"], "disposition": "guidance", "reason": "The rule addresses this source."} for identity in source_ids]},
        "data/baseline.json": {"canonical_book_ids": [row["id"] for row in practices], "canonical_release_ids": [row["id"] for row in releases], "raw_book_ids": [row["raw_id"] for row in book_rows], "raw_release_ids": [row["raw_id"] for row in release_rows], "release_versions": [f"1.{minor}" for minor in range(18, 28)], "book_anchors": {"chapter.htm": ["section"]}, "release_anchors": {f"https://go.dev/doc/go1.{minor}": ["section"] for minor in range(18, 28)}},
    }
    for relative, content in documents.items():
        target = root / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(json.dumps(content))
    for relative, content in render.render(catalog).items():
        target = root / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(content)
    return documents


class BundleTests(unittest.TestCase):
    def test_complete_bundle(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            fixture(root)
            self.assertEqual(check.check_bundle(root)[0], [])

    def test_accounting_failures(self):
        cases = {
            "missing_source": ("data/book.json", lambda d: d["practices"].pop()),
            "missing_raw": ("data/book.json", lambda d: d["raw_to_unified_reconciliation"].pop()),
            "unknown_target": ("data/book.json", lambda d: d["raw_to_unified_reconciliation"][0].update(unified_ids=["BP999"])),
            "wrong_reverse": ("data/book.json", lambda d: d["practices"][0].update(raw_ids=["BA-002"])),
            "missing_caveats": ("data/book.json", lambda d: d["practices"][0].pop("caveats")),
            "invalid_anchor": ("data/book.json", lambda d: d["practices"][0]["source_locators"][0].update(anchor="missing")),
            "missing_disposition": ("coverage.json", lambda d: d["sources"].pop()),
            "duplicate_disposition": ("coverage.json", lambda d: d["sources"].append(copy.deepcopy(d["sources"][0]))),
            "unsupported_exclusion": ("coverage.json", lambda d: d["sources"][0].update(rule_ids=[])),
            "blank_reason": ("coverage.json", lambda d: d["sources"][0].update(reason=" ")),
        }
        for name, (relative, mutate) in cases.items():
            with self.subTest(name=name), tempfile.TemporaryDirectory() as temporary:
                root = Path(temporary)
                documents = fixture(root)
                mutate(documents[relative])
                (root / relative).write_text(json.dumps(documents[relative]))
                self.assertTrue(check.check_bundle(root)[0])

    def test_links_ignore_code_and_reject_missing_or_outside_targets(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            fixture(root)
            (root / "README.md").write_text("[Valid](references/rules/example.md#g1)\n`f[T](x)`\n```go\nf[T](x)\n```\n")
            self.assertEqual(check.check_links(root), [])
            (root / "README.md").write_text("[Missing](missing.md)\n[Outside](../outside.md)\n[Anchor](references/rules/example.md#missing)\n")
            self.assertEqual(len(check.check_links(root)), 3)


if __name__ == "__main__":
    unittest.main()
