import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lcpl_academy/provider/auth_provider.dart';
import 'package:lcpl_academy/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:lcpl_academy/screens/authscreen/login_screen.dart';
import 'package:lcpl_academy/screens/homescreen/home_screen.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.whiteColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(Constants.lcplLogo),
              const SizedBox(
                height: 20,
              ),
              const MulticolorProgressIndicator(),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: Provider.of<AuthProvider>(context, listen: false)
                    .authStateChanges,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  } else if (snapshot.hasData && snapshot.data != null) {
                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    });
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    });
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
