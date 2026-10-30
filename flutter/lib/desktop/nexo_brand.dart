import 'package:flutter/material.dart';

class NexoBrand {
  static const blue = Color(0xFF2156D9);
  static const ink = Color(0xFF152D50);
  static const background = Color(0xFFF3F7FD);
  static const line = Color(0xFFDCE6F4);

  static ThemeData lightTheme(ThemeData base) => base.copyWith(
        primaryColor: blue,
        scaffoldBackgroundColor: background,
        cardColor: Colors.white,
        colorScheme: base.colorScheme.copyWith(
          primary: blue,
          secondary: blue,
          background: Colors.white,
          surface: Colors.white,
        ),
        dividerColor: line,
        textTheme: base.textTheme.apply(bodyColor: ink, displayColor: ink),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: blue,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
}

class NexoIdentity extends StatelessWidget {
  const NexoIdentity({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 28, 16, 12),
        child: Row(
          children: [
            Image.asset('assets/icon.png', width: 40, height: 40),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Nexo\nRemote',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    height: 1.05,
                    letterSpacing: -0.6,
                    color: NexoBrand.blue,
                  )),
            ),
          ],
        ),
      );
}
