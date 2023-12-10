abstract class K {
  // static const String urlTest = 'https://public-energy-label-acceptance.ec.europa.eu/api';
  static const String urlProduction = 'https://eprel.ec.europa.eu/api';
  static const String eprelToken = String.fromEnvironment(
    'EPREL_TOKEN',
    defaultValue: '',
  );
}
