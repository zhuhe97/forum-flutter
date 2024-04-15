class Constants {
  static String get apiUrl => const String.fromEnvironment('API_URL',
      defaultValue: 'http://10.0.2.2:3000');

  static String get environment =>
      const String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');
}
