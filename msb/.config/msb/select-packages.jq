# Homebrew evaluates formula definitions on the target Linux architecture.
def unsupported_requirement:
  any(.requirements[]? | select((.specs // ["stable"]) | index("stable"));
    .name == "macos" or .name == "xcode" or
    (.name == "arch" and .version != $arch));

# Some third-party formulas have no bottle and download a precompiled binary.
def wrong_download_arch:
  (.urls.stable.url // "") as $url |
  if $arch == "arm64" then
    $url | test("(^|[/_.-])(amd64|x86_64|x64)([/_.-]|$)")
  else
    $url | test("(^|[/_.-])(arm64|aarch64)([/_.-]|$)")
  end;

def selection:
  if .disabled then ["skipped", "disabled formula"]
  elif unsupported_requirement then ["skipped", "unsupported platform requirement"]
  elif .bottle.stable.files[$arch + "_linux"] then ["selected", "Linux bottle"]
  elif .bottle.stable.files.all then ["selected", "universal bottle"]
  elif wrong_download_arch then ["skipped", "download targets another architecture"]
  elif .urls.stable.url and .tap == "homebrew/core" then ["selected", "source build"]
  elif .urls.stable.url then ["selected", "upstream archive or source"]
  else ["skipped", "no stable release"]
  end;

.formulae[] |
. + (.variations[$arch + "_linux"] // {}) |
[.full_name] + selection | @tsv
