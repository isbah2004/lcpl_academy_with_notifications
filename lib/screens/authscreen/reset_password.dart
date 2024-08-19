import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lcpl_academy/provider/auth_provider.dart';
import 'package:lcpl_academy/reusablewidgets/reusable_button.dart';
import 'package:lcpl_academy/reusablewidgets/reusable_text_field.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
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
                        onFieldSubmitted: (value) {},
                        validator: (value) =>
                            authProvider.validateEmail(value!),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Consumer<AuthProvider>(
                        builder: (BuildContext context, AuthProvider value,
                            Widget? child) {
                          return ReusableButton(
                            loading: value.loading,
                            title: 'Reset Password',
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                value.resetPassword(
                                  emailController.text.trim(),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
