# MVVM Convention

The app uses **strict MVVM** with a **type-based** `lib/` layout — files are
grouped by what they are (`views/`, `view_models/`, `models/`, …), not by
feature.

## The three roles

| Role | What it is | Lives in |
|---|---|---|
| **View** | A Flutter widget. Renders ViewModel state, forwards user events. | `lib/views/` (full pages); thin Views (forms/sheets) in `lib/widgets/` |
| **ViewModel** | A Riverpod `Notifier` holding view state + commands. No Flutter widget imports. | `lib/view_models/` |
| **Model** | Domain entities, DTOs, repositories and services. | `lib/models/`, `lib/repositories/`, `lib/services/` |

## The rules

1. **One View ↔ one ViewModel.** Every View with non-trivial state has a
   paired ViewModel. Static placeholder Views may have none.
2. **Views are dumb.** A View may only: read VM state, render it, forward user
   events to VM methods. A View must NOT contain: branching logic on domain
   data, multi-step orchestration, validation, or scroll/lifecycle logic beyond
   simple binding. A leaf form View may own a `TextEditingController` purely as
   a text-rendering buffer bound to its ViewModel — the ViewModel still owns
   the canonical value, validation and submit logic.
3. **ViewModels own all state + commands** — form field values, validation,
   pagination triggers, submit orchestration, error classification.
4. **One ViewModel base class: Riverpod `Notifier`** (`NotifierProvider`, or
   `.autoDispose` where the screen is transient). No `StateNotifier`. Plain
   `FutureProvider`/`Provider` are allowed *only* for stateless data queries
   and DI — never as a stand-in ViewModel.
5. **ViewModels never import `package:flutter/material.dart`** or any widget.
   They depend on repositories/domain only, so they stay unit-testable.
   `package:flutter/foundation.dart` (for `@immutable`, `debugPrint`) is fine.
   If a VM needs a Flutter type such as `ThemeMode`, model it as a plain enum
   (see `models/entities/appearance.dart`) and convert in the View or `app.dart`.
6. **Models, repositories and services** hold data + I/O — not view logic.

## ViewModel shape

```dart
@immutable
class FooState { /* fields, derived getters, copyWith */ }

class FooViewModel extends Notifier<FooState> {
  @override
  FooState build() {
    // read deps, register listeners, kick off initial load
    return const FooState();
  }

  // commands — the only API the View calls
  Future<void> doThing() async { state = state.copyWith(...); }
}

final fooViewModelProvider =
    NotifierProvider<FooViewModel, FooState>(FooViewModel.new);
```

- Dependencies are read via `ref` inside `build()` or commands — **not**
  constructor parameters (`Notifier` has no public constructor).
- `build()` returns the initial state; fire async init (`unawaited(_load())`)
  from inside it.
- The View binds with `ref.watch(fooViewModelProvider)` and calls commands via
  `ref.read(fooViewModelProvider.notifier)`.

## Loading, empty and error states

Every page that loads data shows a loading, an empty and an error state. The
ViewModel derives one status from its state and the View switches on it — the
View never works out which state it is in:

```dart
enum HomeStatus { loading, empty, error, ready }

HomeStatus get status { ... }      // on the State class

switch (state.status) {            // in the View
  HomeStatus.loading => const LoadingState(),
  HomeStatus.error => ErrorState(message: ..., onRetry: vm.refresh),
  HomeStatus.empty => const EmptyState(...),
  ...
}
```

Use the shared `LoadingState`, `EmptyState` and `ErrorState` widgets, and put
them in a fixed-height slot so switching states never shifts the layout.
Forms reserve space for inline errors (`helperText: ' '`) and for the submit
error line, so nothing moves when a message appears.

## Repositories without a backend

Until the API exists, every repository is an abstract interface with a
`Fake*` implementation (`repositories/fake_*_repository.dart`) that returns
sample data after a short delay. Providers in `store/providers.dart` bind the
interface to the fake. When the backend lands:

1. Add the Retrofit/Dio caller in `services/` and DTOs in `models/request` +
   `models/response`, with mappers in `mappers/`.
2. Add `*_repository_impl.dart` implementing the same interface.
3. Swap the binding in `store/providers.dart`. ViewModels and Views do not
   change.

Tests override the providers with fakes (zero latency) or small stubs — see
`test/helpers.dart`.

## Folder layout — type-based, flat under `lib/`

```
lib/
  views/          full-page Views — one file per screen, class `*View`
  view_models/    Notifier ViewModels
  widgets/        reusable sub-components, incl. thin Views:
                  forms/, sheets/, form_fields/, cards/, buttons/, …
  store/          Riverpod DI + app-wide & data-query providers
  models/
    entities/     domain models
    request/      request DTOs        (once the backend exists)
    response/     response DTOs       (once the backend exists)
  services/       API callers         (once the backend exists)
  repositories/   repository interfaces + fake / real implementations
  mappers/        DTO ↔ entity mappers (once the backend exists)
  routing/        router + route names
  theme/          colours, theme, branding
  constants/      hardcoded data
  core/           config, errors (and later Dio + interceptors, storage)
```

- Files are grouped by **type**, not by feature — there is no `lib/features/`.
- `views/` holds only full-page Views — one file per screen, class `*View`.
- A form/sheet is also a View (bound to a ViewModel) but is a sub-component,
  so it lives under `widgets/forms/` or `widgets/sheets/`, not `views/`. It
  composes fields from `widgets/form_fields/`.

## Checklist for a new View

- [ ] ViewModel is a `Notifier`, no Flutter widget imports.
- [ ] State class is `@immutable` with `copyWith`.
- [ ] The View widget contains no `if` on domain data, no logic-bearing
      controllers, no orchestration — only render + forward.
- [ ] All async/validation/navigation-decision logic lives in the ViewModel.
- [ ] Loading, empty and error states exist and share a fixed-size slot.
- [ ] ViewModel has unit tests using provider overrides.
