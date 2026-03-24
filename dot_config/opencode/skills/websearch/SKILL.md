---
name: websearch
description: >
  Perform web searches using ddgs (web search service client). Use this skill
  whenever you are uncertain about a fact, need current information, need to
  look up a library/API/version, or the user explicitly asks to search the web
  for something. Trigger proactively when you'd otherwise guess or hallucinate
  an answer — search instead. Also triggers on: "look this up", "what is the
  latest", "search for", "I'm not sure about", or any question about package
  versions, documentation, or third-party tools.
---

## When to use

Search the web when:
- You're uncertain about a fact and could reasonably be wrong
- The user asks for current/recent information (versions, docs)
- The user explicitly asks for a web search
- You need to verify something before giving a definitive answer

Don't search for things you know with high confidence, or for purely
implementation tasks where no external lookup is needed.

## How to search

Run the bundled script from this skill's `scripts/` directory:

```bash
python <skill_dir>/scripts/search.py "<query>" [max_results]
```

`max_results` defaults to 5. Increase it (up to ~10) for broader topics.

The script prints results as: title, URL, and a snippet per result.

## Crafting good queries

- Be specific: `"python requests library timeout default"` beats `"python timeout"`
- For versioning: `"ddgs latest version pypi"` or `"package changelog site:github.com"`
- For docs: append `site:docs.example.com` or `filetype:html` when helpful
- For recent info: the library uses `timelimit` but the script defaults to no
  limit; if you need recent results, modify the query with a year or "2025"

## Presenting results

After searching:
1. Summarize what you found — don't dump raw results on the user
2. Cite the source URL for any specific claim
3. If results are thin or irrelevant, try a rephrased query before giving up
4. If nothing useful turns up after 2 attempts, say so honestly
