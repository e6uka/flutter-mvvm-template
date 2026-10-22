# Contributing

## Commit messages

We use **Conventional Commits**:

```
<type>(<scope>): <imperative description>
```

- **type** — `feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `ci`
- **scope** (optional) — the area: `auth`, `home`, `profile`, `routing`,
  `theme`, …
- **description** — imperative mood, ≤ 70 characters, no trailing period.

The body (wrapped at 72) explains **why**; the diff already shows what.

```
feat(home): pull to refresh reloads announcements
fix(auth): clear the sign-in error when the phone number changes
```

## Branches

- `main` — release-tracked; every commit is a store build candidate.
- `develop` — integration branch. PRs target `develop`.
- `fixes` — long-lived branch where bug fixes accumulate before merging to
  `develop`.
- `feature/<short-name>` — larger features, branched from `develop`.

## Versioning

Anything that ships to users bumps `version:` in `pubspec.yaml` (semver:
patch for fixes, minor for features, major for breaking changes; always bump
the `+build` number) in its own `Bump version to x.y.z` commit.

## Before pushing

```
make get
make analyze
make test
```
