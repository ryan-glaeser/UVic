import sys
import tempfile
from pathlib import Path

from evaluator import *

points = {
    1: { "initialize": 3, "to_s": 3, "insert": 3, "each": 3, "funcset": 3 },
    2: { "count": 6, "count_t": 4,
         "gc": 6, "gc_t": 4,
         "magic": 10, "magic_t": 5 },
}


def run(zip, id):
    print(f"## Evaluating Problem {id} in 🗂️ {zip}\n")

    ext = "rb" if id == 1 else "apl"
    if not (code := get_file(zip, id, ext)):
        print(f"- ⛔️ Cannot find prob{id}.{ext} in the provided ZIP file!\n")
        return

    with tempfile.TemporaryDirectory() as tmp:
        if id == 1:
            t = ruby_run(code, Path(tmp), id, f"a5/test_prob{id}.rb", points[id])
        else:
            t = apl_run(code, Path(tmp), f"a5/test_prob{id}.apl", points[id])
        summarize(*t)
        print()


if __name__ == "__main__":
    for prob in [1, 2]:
        run(sys.argv[1:], prob)
