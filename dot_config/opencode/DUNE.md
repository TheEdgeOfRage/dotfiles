# Dune specific instructions

- All the Dune project repos are located in `~/dev/dune/`
- The duneanalytics common go library is in `~/dev/dune/go`
- The protobuf and grpc definitions are in `~/dev/dune/internal-apis`
- When working on dune prodjects, always read the `~/dev/dune/GLOSSARY.md` file for extra context

## Cross-repo Go module changes

When work spans a consumer repo and a shared Go module (e.g. core consuming `github.com/duneanalytics/go/v2`):

- Make and commit the changes in the dependency repo first on a branch, then push.
- Use `go get github.com/duneanalytics/go/v2@<branch-name>` in the consumer repo to pin against the unmerged branch — this rewrites go.mod/go.sum cleanly and lets `make lint` / `go mod tidy` succeed.
