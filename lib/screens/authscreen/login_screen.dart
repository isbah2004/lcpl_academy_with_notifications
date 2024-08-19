import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lcpl_academy/provider/auth_provider.dart';
import 'package:lcpl_academy/provider/visibility_provider.dart';
import 'package:lcpl_academy/screens/authscreen/reset_password.dart';
import 'package:lcpl_academy/screens/authscreen/signup_screen.dart';
import 'package:lcpl_academy/reusablewidgets/reusable_button.dart';
import 'package:lcpl_academy/reusablewidgets/reusable_text_field.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';
import 'package:lcpl_academy/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return PopScope(
      onPopInvoked: (value) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                height: MediaQuery.of(context).size.height / 1.5,
                decoration: const BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(15),
                          child: Image(image: AssetImage(Constants.lcplLogo)),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        ReusableTextField(
                          padding: 0,
                          prefix: const Icon(Icons.alternate_email_rounded),
                          hintText: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          focusNode: emailFocusNode,
                          onFieldSubmitted: (value) {
                            Utils.changeFocus(
                              currentFocus: emailFocusNode,
                              nextFocus: passwordFocusNode,
                              context: context,
                            );
                          },
                          validator: (value) =>
                              authProvider.validateEmail(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<VisibilityProvider>(
                          builder: (BuildContext context,
                              VisibilityProvider value, Widget? child) {
                            return ReusableTextField(
                              obscureText: value.isVisible,
                              focusNode: passwordFocusNode,
                              padding: 0,
                              prefix: const Icon(Icons.lock),
                              suffix: IconButton(
                                  onPressed: () {
                                    value.setVisibility();
                                  },
                                  icon: Icon(value.isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              hintText: 'Password',
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ResetPasswordScreen()));
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.ubuntu(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<AuthProvider>(
                          builder: (BuildContext context, AuthProvider value,
                              Widget? child) {
                            return ReusableButton(
                              loading: value.loading,
                              title: 'Login',
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  value.signInWithEmail(
                                    emailController.text.trim(),
                                    passwordController.text.trim(),
                                    context,
                                  );
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Did\'nt have an account? ',
                              style: GoogleFonts.ubuntu(),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Signup',
                                style: GoogleFonts.ubuntu(
                                  textStyle: const TextStyle(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
