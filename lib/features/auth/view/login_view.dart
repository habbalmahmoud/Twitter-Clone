import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter__clone/common/common.dart';
import 'package:twitter__clone/constants/ui_constants.dart';
import 'package:twitter__clone/features/auth/controller/auth_contoller.dart';
import 'package:twitter__clone/features/auth/view/signup_view.dart';
import 'package:twitter__clone/features/auth/widgets/auth_field.dart';
import 'package:twitter__clone/theme/pallete.dart';

class LoginView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LoginView(),
      );
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appBar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passController.dispose();
  }

  void onLogin() {
    ref.read(authContollerProvider.notifier).login(
          email: emailController.text,
          password: passController.text,
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authContollerProvider);

    return Scaffold(
      appBar: appBar,
      body: isLoading
          ? const Loader()
          : Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // textfield 1
                      AuthField(controller: emailController, HintText: 'Email'),

                      const SizedBox(
                        height: 25,
                      ),
                      // textfield 2
                      AuthField(
                        controller: passController,
                        HintText: 'Password',
                      ),

                      const SizedBox(
                        height: 40,
                      ),
                      // button
                      Align(
                          alignment: Alignment.topRight,
                          child: RoundedSmallButton(
                            onTap: onLogin,
                            label: 'Done',
                          )),
                      // textspan
                      const SizedBox(
                        height: 40,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Don't have an account?",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                          children: [
                            TextSpan(
                              text: " Sign up",
                              style: const TextStyle(
                                color: Pallete.blueColor,
                                fontSize: 16,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    SignupView.route(),
                                  );
                                },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}