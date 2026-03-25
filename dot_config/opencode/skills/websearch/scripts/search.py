#!/usr/bin/env python3
"""Web search using ddgs. Usage: uv run -w ddgs python search.py <query> [max_results]"""

import sys
from ddgs import DDGS


def main():
    if len(sys.argv) < 2:
        print("Usage: search.py <query> [max_results]", file=sys.stderr)
        sys.exit(1)

    query = sys.argv[1]
    max_results = int(sys.argv[2]) if len(sys.argv) > 2 else 5

    results = DDGS().text(query, max_results=max_results)
    for i, r in enumerate(results, 1):
        print(f"{i}. {r['title']}")
        print(f"   {r['href']}")
        print(f"   {r['body']}")
        print()


if __name__ == "__main__":
    main()
