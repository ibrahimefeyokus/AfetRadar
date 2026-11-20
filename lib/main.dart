import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/home_shell.dart';
import 'screens/settings_screen.dart'; // <-- koyuTemaProvider burada

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await FirebaseAuth.instance.signInAnonymously();
  
  runApp(const ProviderScope(child: AfetRadarApp()));
}

class AfetRadarApp extends ConsumerWidget {
  const AfetRadarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final koyu = ref.watch(koyuTemaProvider); // settings'den geliyor

    return MaterialApp(
      title: 'AfetRadar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, 
        colorSchemeSeed: Colors.red,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
        brightness: Brightness.dark,
      ),
      themeMode: koyu ? ThemeMode.dark : ThemeMode.light, // <-- bağlandı
      home: const HomeShell(),
    );
  }
}