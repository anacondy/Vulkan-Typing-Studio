from pathlib import Path
from html.parser import HTMLParser
from collections import Counter
import gzip, hashlib, json, re, sys

path = Path(sys.argv[1] if len(sys.argv) > 1 else "typing_studio_frontend.html")
raw = path.read_bytes()
text = raw.decode("utf-8")

class AuditParser(HTMLParser):
    def __init__(self):
        super().__init__()
        self.ids = []
        self.tags = []
        self.external = []
    def handle_starttag(self, tag, attrs):
        self.tags.append(tag)
        for key, value in attrs:
            if key == "id":
                self.ids.append(value)
            if key in {"src", "href"} and value and re.match(r"https?://", value, re.I):
                self.external.append(value)

parser = AuditParser()
parser.feed(text)
id_counts = Counter(parser.ids)
patterns = {
    "eval_calls": r"\beval\s*\(",
    "new_function_calls": r"\bnew\s+Function\s*\(",
    "document_write_calls": r"document\.write\s*\(",
    "innerHTML_assignments": r"\.innerHTML\s*=",
    "network_api_mentions": r"\b(?:fetch|XMLHttpRequest|WebSocket)\b",
    "persistent_storage_mentions": r"\b(?:localStorage|sessionStorage|indexedDB)\b",
}
result = {
    "file": str(path),
    "bytes": len(raw),
    "gzip_bytes": len(gzip.compress(raw, 9)),
    "sha256": hashlib.sha256(raw).hexdigest(),
    "lines": text.count("\n") + 1,
    "script_blocks": text.count("<script>"),
    "closing_script_blocks": text.count("</script>"),
    "html_elements": len(parser.tags),
    "ids": len(parser.ids),
    "duplicate_ids": {k: v for k, v in id_counts.items() if v > 1},
    "external_http_references": parser.external,
    "counts": {name: len(re.findall(pattern, text)) for name, pattern in patterns.items()},
}
print(json.dumps(result, indent=2))
