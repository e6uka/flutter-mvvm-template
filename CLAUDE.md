# Project rules

- Follow `MVVM.md` for every screen: one View ↔ one `Notifier` ViewModel,
  Views only render and forward events, ViewModels never import
  `package:flutter/material.dart`.
- No backend yet: repositories are interfaces bound to `Fake*`
  implementations in `lib/store/providers.dart`. Don't add Dio or API calls
  until the API is ready.
- Every data screen has loading, empty and error states (shared widgets in
  `lib/widgets/`), and forms reserve space for messages so nothing jumps.
- Use package imports (`package:flutter_mvvm_template/...`) everywhere.
- Run through FVM: `fvm flutter analyze` and `fvm flutter test` must pass
  before committing. `make help` lists the shortcuts.
