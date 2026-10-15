import json
from pathlib import Path
import subprocess
import unittest


SELECTOR = Path(__file__).resolve().parents[1] / ".config/msb/select-packages.jq"


class PackageSelectionTests(unittest.TestCase):
    def select(self, formula, arch="arm64"):
        result = subprocess.run(
            ["jq", "-r", "--arg", "arch", arch, "-f", str(SELECTOR)],
            input=json.dumps({"formulae": [{"full_name": "test/formula/tool", **formula}]}),
            text=True,
            capture_output=True,
            check=True,
        )
        name, status, reason = result.stdout.strip().split("\t")
        self.assertEqual(name, "test/formula/tool")
        self.assertTrue(reason)
        return status

    def test_platform_bottles_and_requirements(self):
        cases = [
            ({"bottle": {"stable": {"files": {"arm64_linux": {}}}}}, "selected"),
            ({"bottle": {"stable": {"files": {"all": {}}}}}, "selected"),
            ({"disabled": True}, "skipped"),
            ({"requirements": [{"name": "macos"}]}, "skipped"),
            ({"requirements": [{"name": "arch", "version": "x86_64"}]}, "skipped"),
            ({"requirements": [{"name": "macos"}], "urls": {"stable": {"url": "https://example.org/tool.tar.gz"}}}, "skipped"),
            ({}, "skipped"),
        ]
        for formula, expected in cases:
            with self.subTest(formula=formula):
                self.assertEqual(self.select(formula), expected)

    def test_linux_variation_overrides_platform_requirement(self):
        formula = {
            "requirements": [{"name": "xcode"}],
            "bottle": {"stable": {"files": {"arm64_linux": {}}}},
            "variations": {"arm64_linux": {"requirements": []}},
        }
        self.assertEqual(self.select(formula), "selected")

    def test_head_requirements_do_not_exclude_stable_bottles(self):
        formula = {
            "requirements": [{"name": "macos", "specs": ["head"]}],
            "bottle": {"stable": {"files": {"arm64_linux": {}}}},
        }
        self.assertEqual(self.select(formula), "selected")

    def test_upstream_download_architecture(self):
        cases = [
            ("https://example.org/tool_linux_arm64.tar.gz", "arm64", "selected"),
            ("https://example.org/tool_linux_amd64.tar.gz", "arm64", "skipped"),
            ("https://example.org/tool-linux-x64.zip", "arm64", "skipped"),
            ("https://example.org/tool-linux-x86_64.tar.gz", "arm64", "skipped"),
            ("https://example.org/tool-linux-aarch64.tar.gz", "x86_64", "skipped"),
            ("https://example.org/tool_linux_amd64.tar.gz", "x86_64", "selected"),
            ("https://example.org/tool-1.0.tar.gz", "arm64", "selected"),
        ]
        for url, arch, expected in cases:
            with self.subTest(url=url, arch=arch):
                self.assertEqual(self.select({"urls": {"stable": {"url": url}}}, arch), expected)


if __name__ == "__main__":
    unittest.main()
