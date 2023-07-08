import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:shopy/model/language/language_constants.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/view/common%20widget/custom_button.dart';

import '../common widget/snackbar.dart';
class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {

  //biometric status
  bool isBiometricEnabled = false;
  void getBiometricSetting() async {
    var box = await Hive.openBox('biometric');
    bool biometricSetting = box.get('key', defaultValue: false);
    setState(() {
      isBiometricEnabled = biometricSetting;
    });
    box.close();
  }
  void saveBiometricSetting(bool isBiometricEnabled) async {
    var box = await Hive.openBox('biometric');
    box.clear();
    await box.put('key', isBiometricEnabled);
    box.close();
  }

  //applock status
  bool isAppLock = false;
  void getAppLockSetting()async{
    var box = await Hive.openBox('appLock');
    bool appLockSetting = box.get('key', defaultValue: false);
    setState(() {
      isAppLock = appLockSetting;
    });
    box.close();
  }
  void saveAppLockSetting(bool isAppLock)async{
    var box = await Hive.openBox('appLock');
    box.clear();
    await box.put('key', isAppLock);
    box.close();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBiometricSetting();
    getAppLockSetting();
  }
  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2,),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(auth.user[0].id),
                        Text(auth.user[0].username, style: TextStyle(fontSize: 18.sp, color: Colors.black),),
                        Text(auth.user[0].email, style: TextStyle(fontSize: 12.sp, color: Colors.black)),
                        SizedBox(height: 12.h,),
                        //toggle buttons
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(translation(context).enableBiometricLogin, style: TextStyle(color: Colors.black),),
                              Switch(
                                value: isBiometricEnabled,
                                inactiveTrackColor: Colors.red.shade300,
                                inactiveThumbColor: Colors.red.shade500,
                                activeColor: Colors.lightGreen,
                                activeTrackColor: Colors.lightGreen.shade400,
                                onChanged: (value) {
                                  setState((){
                                    isBiometricEnabled = value;
                                    print(isBiometricEnabled);
                                    saveBiometricSetting(isBiometricEnabled);
                                    isBiometricEnabled ? SnackShow.showSuccess(context, 'Biometric login enabled') : SnackShow.showFailure(context, 'Biometric login disabled');
                                  });
                                  },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h,),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Enable App Lock', style: TextStyle(color: Colors.black),),
                              Switch(
                                value: isAppLock,
                                inactiveTrackColor: Colors.red.shade300,
                                inactiveThumbColor: Colors.red.shade500,
                                activeColor: Colors.lightGreen,
                                activeTrackColor: Colors.lightGreen.shade400,
                                onChanged: (value) {
                                  setState((){
                                    isAppLock = value;
                                    print(isAppLock);
                                    saveAppLockSetting(isAppLock);
                                    isAppLock ? SnackShow.showSuccess(context, 'App Lock enabled') : SnackShow.showFailure(context, 'App Lock disabled');
                                  });
                                  },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    CustomButton(
                        onPressed: (){
                          // ref.read(authProvider.notifier).userLogOut();
                          Hive.box('status').clear();
                        },
                        text: translation(context).logout)
                  ],
                ),
              ),
            ),
            const Column(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: NetworkImage('https://logowik.com/content/uploads/images/flutter5786.jpg'),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
