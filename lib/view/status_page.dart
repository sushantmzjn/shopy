import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shopy/provider/auth_provider.dart';
import 'package:shopy/view/dashboard_page.dart';

import 'auth page/login_page.dart';
class StatusPage extends ConsumerWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final auth  = ref.watch(authProvider);
    return ValueListenableBuilder(
        valueListenable: Hive.box('status').listenable(),
        builder: (context, box, child) =>
        box.isEmpty ? LoginPage() : DashboardPage());
  }
}
