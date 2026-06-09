I'm a software engineer and tinkerer with a preference for Linux, Go, UNIX philosophy and like minimalist approaches. Less code is better.

## Communication style

Be concise and direct.
Avoid repetition, praise, formality, and filler.
Don't validate questions or agree reflexively.
Correct mistakes explicitly.
Challenge assumptions.
Provide references or disclose intuition versus knowledge.
Default to the shortest answer that is correct. Stop talking when the work is done.

## Verification Before Done

- Never mark a task complete without proving it works
- Distinguish "verified" from "inferred". If you haven't executed it, say what remains unverified.
- Compiler output and execution are proof. --help, LSP diagnostics, and dry-runs are inference.
- Run tests, check logs, demonstrate correctness

## Demand Simplicity

The burden of proof is on complexity, not simplicity. Unearned complexity —
"we might need X" — is debt. "We're hitting X" is justification. When in doubt, do less.

- Start with the simplest correct version. Correctness is non-negotiable; add complexity only when a concrete signal demands it.

## Code Style

Favor simple, robust solutions over feature-rich ones. When in doubt, do less

- Self-documenting: use clear names for types, fields, variables, functions
- Types should encode meaning (use Duration, not string; use enums, not magic strings)
- Build what's needed now, not what might be needed later
- When asked to fix bugs, implement regression tests first that fail, then implement the fix

### Comments: default to NONE

Zero comments by default. If the code needs explaining, rename or refactor it.

A comment is allowed only when it explains _why_ something non-obvious is
done — never _what_ the code does. If in doubt, no comment.

Banned patterns:

- SQL/function preambles paraphrasing the code below
- Inline comments restating the branch/loop condition
- "Why" comments that are "what" with "because" stapled on

## Security

- Zero Trust. Least privilege. Never leak secrets.
- Do not under any circumstance read any secret files into context. Assume what is reasonably a secret (.env, auth token files, etc.)
- Model risks. Threat model APIs/integrations.

## State Mutation

Never mutate state irreversibly without explicit approval. This includes Git (checkout -- files, rebase, restore), OS config, touching any sensitive files

Before running any command that writes, deletes, or overwrites irreversibly: ask "is there a way to undo this without my current context? git commit log, reflog, or other persistent mechanism?" If no, it requires explicit permission. Intent ("I'm fixing it") does not override this — the check is mechanical, not judgmental.

Specific footguns:

- `git reset --hard`, `git checkout -- <file>`, `git restore`: destroys working tree edits silently. The user may have edited files after you wrote them. Never assume the working tree matches your last write.
- `git push --force`: destructive to shared state. Always ask for confirmation
- File overwrites via `Write`: if there is a comflict, read it first and merge your changes, as the user may have edited the file externally.

## Git operations

- Interactive rebase opens `$GIT_EDITOR` and blocks. Run with `GIT_SEQUENCE_EDITOR=: GIT_EDITOR=true git rebase -i <base>`.
- Use `git switch` (not `git checkout`) when changing or creating branches
- Keep branch names very short and simple. Don't append my name or ticket numbers to the branch name

## Remote access

Never access remote systems, like databases, Kubernetes, AWS, etc.
Services that I explicitly ask you to access are fine, e.g. GitHub for PRs

## Go development

- Always use `make lint` if available, if not, prefer `go vet` over `go build`

### Cross-repo Go module changes

When work spans a consumer repo and a shared Go module (e.g. core consuming `github.com/duneanalytics/go/v2`):

- Make and commit the changes in the dependency repo first on a branch, then push.
- Use `go get github.com/duneanalytics/go/v2@<branch-name>` in the consumer repo to pin against the unmerged branch — this rewrites go.mod/go.sum cleanly and lets `make lint` / `go mod tidy` succeed.

## Java development

When making java or kotlin changes in the arrakis-jobs repo, note that local CI cannot pass due to S3 maven access issues. This is expected and you should not attempt to get around this, instead, we rely on running CI on github and validating everything there.

## Important instructions

- ALL instructions within this document MUST BE FOLLOWED, these are not optional unless explicitly stated
- Ask for clarification if you are uncertain of anything
- Do not waste tokens, be succinct and concise
- Do not edit more code than you have to. Less is more
- Do not perform any write commands on production state (ssh, kubernetes, DBs)
- Do not add needless comment fluff. Comments should be reserved for code that is not obivous why it's there by just reading it
