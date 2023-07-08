
import 'package:local_auth/local_auth.dart';

class FingerPrintAuth{
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate()async{
    return await  _auth.authenticate(
        localizedReason: 'Scan Fingerprint to authenticate',
      
    );
  }
}