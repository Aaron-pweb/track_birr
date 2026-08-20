import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:track_birr/ui/main_screen.dart';
import 'package:track_birr/sms/sms_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();

  // Initialize SMS service
  SmsService(container: container).init();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const TrackBirrApp(),
    ),
  );
}

class TrackBirrApp extends StatelessWidget {
  const TrackBirrApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track Birr',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}