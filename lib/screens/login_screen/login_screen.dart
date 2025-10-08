import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:transfor_admin_dashboard/blocs/auth/auth_bloc.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/assets.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';
import 'package:transfor_admin_dashboard/utilities/text_styles.dart';

import '../../global_widgets/language_toggle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variables to store error messages
  String? _emailError;
  String? _passwordError;

  // Function to validate email
  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Basic email regex
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  // Function to validate password
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  //showing Error
  void _showError(String message) {
    final String text;
    if (message == 'Admin is not found') {
      text = AppStrings.adminIsNotFound.translate(context);
    } else if (message == 'Password is wrong') {
      text = AppStrings.passwordIsWrong.translate(context);
    } else {
      text = message;
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: AppStrings.loginFailed.translate(context),
      desc: text,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckLoginStatus());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.padding,
            ),
            child: LanguageToggle(isAppbar: true,),
          ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            _showError(state.message);
          } else if (state is AuthSuccess) {
            context.go('/dashboard');
          }
        },
        builder: (context, state) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(Assets.appLogo, height: 80),
                      const SizedBox(height: AppDimensions.padding),
                      Text(
                        AppStrings.appTitle.translate(context),
                        style: AppTextStyles.heading,
                      ),
                      Text(
                        AppStrings.loginTitle.translate(context),
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: AppDimensions.biggerSpacing),
                      TextFormField(
                        controller: _emailController,
                        validator: _validateEmail,
                        forceErrorText: _emailError,
                        decoration: InputDecoration(
                          labelText: AppStrings.email.translate(context),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.normalSpacing),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        forceErrorText: _passwordError,
                        validator: _validatePassword,
                        decoration: InputDecoration(
                          labelText: AppStrings.password.translate(context),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.biggerSpacing),
                      ElevatedButton(
                        onPressed:
                            state is AuthLoading
                                ? null
                                : () {
                                  setState(() {
                                    _emailError = _validateEmail(
                                      _emailController.text,
                                    );
                                    _passwordError = _validatePassword(
                                      _passwordController.text,
                                    );
                                  });
                                  if (_emailError == null &&
                                      _passwordError == null) {
                                    context.read<AuthBloc>().add(
                                      LoginRequested(
                                        email: _emailController.text.trim(),
                                        password: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child:
                            state is AuthLoading
                                ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                                : Text(
                                  AppStrings.login.translate(context),
                                  style: AppTextStyles.buttonTextStyle,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
