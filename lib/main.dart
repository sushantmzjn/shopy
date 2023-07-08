import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/model/user%20model/user.dart';
import 'package:shopy/view/status_page.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'l10n/l10n.dart';

//user box
final box = Provider<List<User>>((ref) => []);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  //lock orientation
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.grey
  ));
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter());
  final userBox =await Hive.openBox<User>('user');

  //login logout status box
  await Hive.openBox('status');
  //biometric enable disable box
  await Hive.openBox('biometric');
  //app lock box
  await Hive.openBox('appLock');

  // print(userBox.isEmpty);

  runApp(ProviderScope(
    overrides: [
      box.overrideWithValue(userBox.values.toList())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  //local auth
  static void setLocale(BuildContext context, Locale newLocale){
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}
class _MyAppState extends State<MyApp> {
  Locale? _locale;
  setLocale(Locale locale){
    setState(() {
      _locale = locale;
    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getLocale().then((value) => setLocale(value));
  }


  late final LocalAuthentication auth;
  bool _supportState = false;


  //get app lock status
  bool isAppLock = false;
  void getAppLockSetting()async{
    var box = await Hive.openBox('appLock');
    bool appLockSetting = box.get('key', defaultValue: false);
    setState(() {
      isAppLock = appLockSetting;
      if(isAppLock){
        _authenticate();
      }
    });
    box.close();
  }

  //appLock authenticate
  Future<void> _authenticate()async{
    try{
      bool authenticated = await auth.authenticate(localizedReason: 'Login to SHOPY',
          options: const AuthenticationOptions(
              stickyAuth: true,
              biometricOnly: false
          )
      );
      if(authenticated){
       print('yes');
      }
    }on PlatformException catch(e){
      print(e);
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth = LocalAuthentication();
    auth.isDeviceSupported().then(
            (bool isSupported) => setState((){
          _supportState = isSupported;
        })
    );
    // getAppLockSetting();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        builder: (BuildContext context, Widget? child) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          fontFamily: 'Montserrat'
        ),
        supportedLocales: L10n.all,
        // localizationsDelegates: [
        //   AppLocalizations.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate
        // ],
          localizationsDelegates: AppLocalizations.localizationsDelegates,
        locale: _locale,
        home: StatusPage()
      );
    });
  }
}
