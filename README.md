# Flutter MVVM Template

A starter for Flutter apps (Android + iOS) using strict MVVM with Riverpod
and go_router. Click **Use this template** on GitHub to start a new project.

## Start a new project

```bash
gh repo create my-app --private --template e6uka/flutter-mvvm-template --clone
cd my-app
tool/rename.sh --package my_app --bundle-id com.company.myapp --name "My App"
```

Then:

1. Set the brand name, tagline and icon in `lib/constants/app_brand.dart`.
2. Set the brand colour in `lib/theme/brand_palette.dart`.
3. `make setup && make run`.

`tool/rename.sh` updates the Dart package name (every import), the Android
application ID and Kotlin package folder, the iOS bundle ID, and the app's
display name everywhere it appears.

## What's included

- **MVVM rules** in [MVVM.md](MVVM.md) — one View ↔ one `Notifier`
  ViewModel, dumb Views, no Flutter widget imports in ViewModels.
- **Bootstrap + config:** `dev` / `staging` / `prod` env files in
  `assets/env/`, picked with `--dart-define STAGE=…` (`make run STAGE=prod`).
- **Routing:** `go_router` with an auth redirect (splash → sign in → app)
  and a `StatefulShellRoute` for the bottom tabs.
- **Theme:** Material 3 from one brand colour, light / dark / system,
  saved with `shared_preferences`.
- **Fake backend:** repository interfaces bound to `Fake*` implementations,
  so screens work before the API exists. Swap them in
  `lib/store/providers.dart` later.
- **Shared states:** `LoadingState`, `EmptyState` and `ErrorState` widgets,
  and forms that reserve space for errors so layouts never jump.
- **Example screens:** splash, sign in, home (list with loading, empty and
  error states), activity placeholder, profile with appearance + sign out.
- **Tests:** ViewModel unit tests and a sign-in flow widget test.
- **Tooling:** FVM-pinned Flutter (`.fvmrc`), `Makefile`, GitHub Actions CI
  (format, analyze, test), Conventional Commits guide, `CLAUDE.md`.

## Commands

```bash
make setup     # install pinned Flutter + packages
make run       # dev stage
make test
make analyze
make help      # everything else
```

**Demo sign-in:** any 10–11 digit phone number and a 6+ character password.
Numbers starting with `000` are rejected, to show the error state.

## Layout

```
lib/
  main.dart, bootstrap.dart, app.dart
  core/            config, errors
  constants/       brand name, tagline, icon
  models/entities/ domain models
  repositories/    interfaces + Fake* implementations
  store/           DI providers, auth, session, appearance
  view_models/     Notifier ViewModels
  views/           one file per screen
  widgets/         forms/, form_fields/, cards/, shared states
  routing/         AppRoutes + appRouterProvider
  theme/           AppColors, AppTheme, BrandPalette
```
