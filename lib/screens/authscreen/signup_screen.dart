import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:lcpl_academy/provider/auth_provider.dart';
import 'package:lcpl_academy/provider/visibility_provider.dart';
import 'package:lcpl_academy/screens/authscreen/login_screen.dart';
import 'package:lcpl_academy/reusablewidgets/reusable_button.dart';
import 'package:lcpl_academy/reusablewidgets/reusable_text_field.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';
import 'package:lcpl_academy/utils/utils.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController staffController = TextEditingController();
  final FocusNode staffFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    staffController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    staffFocusNode.dispose();
    super.dispose();
  }

  Future<bool> isMapPresent(Map<String, String> mapToCheck) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');

    Query query = collection;

    mapToCheck.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });

    QuerySnapshot querySnapshot = await query.get();

    return querySnapshot.docs.isNotEmpty;
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
                          focusNode: staffFocusNode,
                          onFieldSubmitted: (value) {
                            Utils.changeFocus(
                              currentFocus: staffFocusNode,
                              nextFocus: emailFocusNode,
                              context: context,
                            );
                          },
                          padding: 0,
                          prefix: const Icon(Icons.numbers_rounded),
                          hintText: 'Staff No',
                          controller: staffController,
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ReusableTextField(
                          focusNode: emailFocusNode,
                          onFieldSubmitted: (value) {
                            Utils.changeFocus(
                              currentFocus: emailFocusNode,
                              nextFocus: passwordFocusNode,
                              context: context,
                            );
                          },
                          padding: 0,
                          prefix: const Icon(Icons.alternate_email_rounded),
                          hintText: 'Email',
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              authProvider.validateEmail(value!),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer2<VisibilityProvider, AuthProvider>(
                          builder: (BuildContext context,
                              VisibilityProvider value1,
                              AuthProvider value2,
                              Widget? child) {
                            return ReusableTextField(
                              obscureText: value1.isVisible,
                              focusNode: passwordFocusNode,
                              padding: 0,
                              prefix: const Icon(Icons.lock),
                              suffix: IconButton(
                                  onPressed: () {
                                    value1.setVisibility();
                                  },
                                  icon: Icon(value1.isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              hintText: 'Password',
                              controller: passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              validator: (value) =>
                                  value2.validatePassword(value!),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Consumer<AuthProvider>(
                          builder: (BuildContext context, AuthProvider value,
                              Widget? child) {
                            return ReusableButton(
                              loading: value.loading,
                              title: 'Signup',
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  // Map to check if staff number exists
                                  value.setLoading(true);
                                  Map<String, String> mapToCheck = {
                                    'staff': staffController.text.trim(),
                                  };

                                  // Check if staff number exists
                                  bool exists = await isMapPresent(mapToCheck);

                                  if (exists) {
                                    value.signUpWithEmail(
                                      staffController.text.trim(),
                                      emailController.text.trim(),
                                      passwordController.text.trim(),
                                      context,
                                    );
                                  } else {
                                    Utils.toastMessage(
                                        message:
                                            'Please use a valid staff number');
                                    value.setLoading(false);
                                  }
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
                              'Already have an account? ',
                              style: GoogleFonts.ubuntu(),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                'Login',
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
