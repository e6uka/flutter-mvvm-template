enum Appearance {
  light('Light'),
  dark('Dark'),
  system('System');

  const Appearance(this.label);
  final String label;

  static Appearance parse(String? raw) => switch (raw) {
    'dark' => Appearance.dark,
    'system' => Appearance.system,
    _ => Appearance.light,
  };
}
