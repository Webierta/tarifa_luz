import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(obfuscate: true, varName: 'EPREL_TOKEN', defaultValue: '')
  static final String eprelToken = _Env.eprelToken;
}
