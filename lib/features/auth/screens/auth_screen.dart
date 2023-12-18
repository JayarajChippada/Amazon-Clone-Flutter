import 'package:amazon_clone/common/widgets/custom_button.dart';
import 'package:amazon_clone/common/widgets/custom_textfield.dart';
import 'package:amazon_clone/constants/global_variable.dart';
import 'package:amazon_clone/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  static const String routeName = '/auth-screen';
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth
      .signup; // it is the default group value means the radio button will be activated for signup
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService authService = AuthService();

  @override
  void dispose() {
    super.dispose();
    // TODO: implement dispose

    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        context: context,
        name: _nameController.text);
  }

  void signInUser() {
    authService.singInUser(
        context: context,
        email: _emailController.text,
        password: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.greyBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListTile(
                  tileColor: _auth == Auth.signup
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundColor,
                  title: const Text(
                    "Create Account",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  leading: Radio(
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signup,
                      groupValue: _auth,
                      onChanged: ((Auth? val) {
                        setState(() {
                          _auth = val!;
                        });
                      })),
                ),
                if (_auth == Auth.signup)
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _signUpFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              hintText: 'Name', controller: _nameController),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              hintText: 'Email', controller: _emailController),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              hintText: 'Password',
                              controller: _passwordController),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                              text: 'Sign Up',
                              onTap: () {
                                if (_signUpFormKey.currentState!.validate()) {
                                  signUpUser();
                                }
                              })
                        ],
                      ),
                    ),
                  ),
                ListTile(
                  tileColor: _auth == Auth.signin
                      ? GlobalVariables.backgroundColor
                      : GlobalVariables.greyBackgroundColor,
                  title: const Text(
                    "Sign In",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  leading: Radio(
                      activeColor: GlobalVariables.secondaryColor,
                      value: Auth.signin,
                      groupValue: _auth,
                      onChanged: ((Auth? val) {
                        setState(() {
                          _auth = val!;
                        });
                      })),
                ),
                if (_auth == Auth.signin)
                  Container(
                    color: GlobalVariables.backgroundColor,
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _signInFormKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              hintText: 'Email', controller: _emailController),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                              hintText: 'Password',
                              controller: _passwordController),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomButton(
                              text: 'Sign In',
                              onTap: () {
                                if (_signInFormKey.currentState!.validate()) {
                                  signInUser();
                                }
                              })
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
