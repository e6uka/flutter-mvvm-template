enum AppStage {
  dev,
  staging,
  prod;

  static AppStage parse(String? value) => switch (value?.toLowerCase()) {
    'prod' || 'production' => AppStage.prod,
    'staging' || 'stage' => AppStage.staging,
    _ => AppStage.dev,
  };
}
