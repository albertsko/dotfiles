import copy
import json
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path
import ledger


class LedgerTests(unittest.TestCase):
    def setUp(self):
        self.catalog = {"rules": [{"id": "G1"}, {"id": "G2"}]}
        self.valid = ledger.initialize(self.catalog)
        self.valid["scope"] = {"repository": "/example", "task": "review parser", "supported_go_versions": "1.22-1.27", "toolchains": "go1.27.2", "platforms": "linux/amd64", "inspected_paths": ["parser.go"]}
        self.valid["decisions"] = [
            {"id": "G1", "status": "pass", "reason": "Parser processes input bytes.", "evidence": ["parser.go:12 validates input before indexing."]},
            {"id": "G2", "status": "not_applicable", "reason": "No goroutines in the inspected scope.", "evidence": ["Inspected parser.go and its callees: all execution is synchronous."]},
        ]

    def test_complete(self):
        self.assertEqual(ledger.verify(self.catalog, self.valid)[0], [])

    def test_incomplete_or_invalid_decisions(self):
        cases = {
            "missing": lambda d: d["decisions"].pop(),
            "duplicate": lambda d: d["decisions"].append(copy.deepcopy(d["decisions"][0])),
            "unknown": lambda d: d["decisions"][0].update(id="G9"),
            "pending": lambda d: d["decisions"][0].update(status="pending"),
            "blocked": lambda d: d["decisions"][0].update(status="blocked"),
            "failed": lambda d: d["decisions"][0].update(status="fail"),
            "blank_reason": lambda d: d["decisions"][1].update(reason=" "),
            "no_evidence": lambda d: d["decisions"][0].update(evidence=[]),
            "no_applicability_evidence": lambda d: d["decisions"][1].update(evidence=[]),
            "bad_evidence": lambda d: d["decisions"][0].update(evidence=[3]),
            "bad_scope": lambda d: d.update(scope={}),
            "stale": lambda d: d.update(catalog_sha256="old"),
            "schema": lambda d: d.update(schema_version=2),
            "boolean_schema": lambda d: d.update(schema_version=True),
        }
        for name, mutate in cases.items():
            with self.subTest(name=name):
                candidate = copy.deepcopy(self.valid)
                mutate(candidate)
                self.assertTrue(ledger.verify(self.catalog, candidate)[0])

    def test_catalog_validation(self):
        for catalog in ({"rules": []}, {"rules": [{"id": "G1"}, {"id": "G1"}]}, {"rules": [{"id": "G01"}]}):
            with self.assertRaises(ValueError):
                ledger.initialize(catalog)

    def test_duplicate_json_keys(self):
        with self.assertRaises(ValueError):
            ledger.unique_object([("status", "fail"), ("status", "pass")])

    def test_cli_initialization_and_verification(self):
        script = str(Path(ledger.__file__).resolve())
        with tempfile.TemporaryDirectory() as temporary:
            directory = Path(temporary)
            catalog = directory / "catalog.json"
            output = directory / "ledger.json"
            catalog.write_text(json.dumps(self.catalog))
            init = [sys.executable, script, "init", "--catalog", str(catalog), "--output", str(output)]
            result = subprocess.run(init, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            self.assertEqual(json.loads(result.stdout)["rule_count"], 2)
            self.assertEqual(result.stderr, "")
            before = output.read_bytes()
            duplicate = subprocess.run(init, capture_output=True, text=True)
            self.assertEqual(duplicate.returncode, 1)
            self.assertEqual(output.read_bytes(), before)
            self.assertEqual(json.loads(duplicate.stderr)["code"], "input_error")
            verify = [sys.executable, script, "verify", "--catalog", str(catalog), "--ledger", str(output)]
            incomplete = subprocess.run(verify, capture_output=True, text=True)
            self.assertEqual(incomplete.returncode, 3)
            self.assertFalse(json.loads(incomplete.stdout)["complete"])
            output.write_text(json.dumps(self.valid))
            complete = subprocess.run(verify, capture_output=True, text=True)
            self.assertEqual(complete.returncode, 0, complete.stderr)
            self.assertTrue(json.loads(complete.stdout)["complete"])


if __name__ == "__main__":
    unittest.main()
