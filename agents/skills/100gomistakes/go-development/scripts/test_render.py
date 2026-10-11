import copy
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
import render


class RenderTests(unittest.TestCase):
    def setUp(self):
        self.catalog = {"topics": [{"id": "example", "title": "Example", "trigger": "An example applies."}], "rules": [{"id": "G1", "topic": "example", "when": "an example applies", "then": "inspect the result", "because": "the result determines the next step", "sources": ["BP1"], "reference": "references/rules/example.md#g1"}]}

    def test_rule_and_trigger_are_disclosed(self):
        result = render.render(self.catalog)
        self.assertIn("- **G1** When an example applies. Then inspect the result. Because the result determines the next step.", result["references/rules/example.md"])
        self.assertIn("[G1](rules/example.md#g1)", result["references/rule-index.md"])
        self.assertIn("[Example](rules/example.md)", result["references/topics.md"])

    def test_invalid_catalog_rejected(self):
        for field, value in (("topic", "missing"), ("topic", []), ("when", ""), ("sources", []), ("reference", "elsewhere.md"), ("example", {"label": "missing path"})):
            with self.subTest(field=field):
                catalog = copy.deepcopy(self.catalog)
                catalog["rules"][0][field] = value
                with self.assertRaises(ValueError):
                    render.render(catalog)

    def test_cli_detects_stale_and_orphaned_generated_files(self):
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            catalog = root / "catalog.json"
            catalog.write_text(json.dumps(self.catalog))
            command = [sys.executable, str(Path(render.__file__).resolve()), "--catalog", str(catalog)]
            result = subprocess.run(command, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            valid = subprocess.run(command + ["--check"], capture_output=True, text=True)
            self.assertEqual(valid.returncode, 0, valid.stderr)
            target = root / "references/rules/example.md"
            target.write_text(target.read_text() + "stale text\n")
            (target.parent / "orphan.md").write_text("orphan\n")
            invalid = subprocess.run(command + ["--check"], capture_output=True, text=True)
            self.assertEqual(invalid.returncode, 3)
            errors = json.loads(invalid.stdout)["errors"]
            self.assertEqual(len(errors), 2)
            self.assertIn("stale text", target.read_text())


if __name__ == "__main__":
    unittest.main()
