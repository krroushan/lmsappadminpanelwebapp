// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:feather_icons/feather_icons.dart';
import 'package:go_router/go_router.dart';

// Packages added by me
import 'dart:convert';
import 'package:http/http.dart' as http;

// 🌎 Project imports:
import '../../../dev_utils/dev_utils.dart';
import '../../../generated/l10n.dart' as l;
import '../../widgets/widgets.dart';
import '../../core/api_config/api_config.dart';
import '../../providers/providers.dart';
import 'package:provider/provider.dart';


class SigninView extends StatefulWidget {
  const SigninView({super.key});

  @override
  State<SigninView> createState() => _SigninViewState();
}

class _SigninViewState extends State<SigninView> {
  bool rememberMe = false;
  bool showPassword = false;
  bool isLoading = false;
  String errorMessage = '';
  // Create controllers for username and password
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // Add new state variable for selected role
  String selectedRole = 'admin'; // Default to admin

  Future<void> _handleLogin() async {
    setState(() {
      isLoading = true; // Set loading to true
      errorMessage = ''; // Clear previous error message
    });

    final String username = usernameController.text; // Get username input
    final String password = passwordController.text; // Get password input

    // Modify API URL based on selected role
    final String loginEndpoint = selectedRole == 'admin' 
        ? '/admin/login'
        : '/teacher/login';

    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}$loginEndpoint'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    setState(() {
      isLoading = false; // Set loading to false after the request
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = data['admin'] ?? data['teacher'];
      final name = user['fullName'];
      final role = user['role'];
      final userId = user['_id'];
      print("name: $name");
      print("role: $role");
      print("userId: $userId");
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(token, name, role, userId);

      context.go('/dashboard');
      print(data['message']);
    } else {
      // Update the error message
      final errorResponse = jsonDecode(response.body);
      errorMessage = errorResponse['message'] ?? 'Login failed';
      print('Login failed: ${response.body}');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);

    final _screenWidth = MediaQuery.sizeOf(context).width;

    final _desktopView = _screenWidth >= 1200;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: isLoading // Show loading indicator if loading
            ? Center(child: CircularProgressIndicator())
            : Row(
                children: [
                  Flexible(
                    child: Container(
                      constraints: BoxConstraints(
                        minWidth: _desktopView ? (_screenWidth * 0.45) : _screenWidth,
                      ),
                      decoration: BoxDecoration(
                        color: _theme.colorScheme.primaryContainer,
                      ),
                      child: SafeArea(
                        child: Column(
                          children: [
                            // Header With Logo
                            const CompanyHeaderWidget(),

                            // Sign in form
                            Flexible(
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(maxWidth: 375),
                                child: Center(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${selectedRole == 'admin' ? 'Admin' : 'Teacher'} Login',
                                          style: _theme.textTheme.headlineSmall
                                              ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        //error message like login failed
                                        Text(
                                          errorMessage,
                                          style: _theme.textTheme.bodyLarge?.copyWith(
                                            color: Colors.red,
                                          ),
                                        ),

                                        // Add this widget before the email field
                                        Container(
                                          margin: const EdgeInsets.only(bottom: 20),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              ChoiceChip(
                                                label: const Text('Admin'),
                                                selected: selectedRole == 'admin',
                                                onSelected: (selected) {
                                                  if (selected) {
                                                    setState(() => selectedRole = 'admin');
                                                  }
                                                },
                                              ),
                                              const SizedBox(width: 16),
                                              ChoiceChip(
                                                label: const Text('Teacher'),
                                                selected: selectedRole == 'teacher',
                                                onSelected: (selected) {
                                                  if (selected) {
                                                    setState(() => selectedRole = 'teacher');
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Email Field
                                        TextFieldLabelWrapper(
                                          labelText: 'Email',
                                          inputField: TextFormField(
                                            controller: usernameController,
                                            decoration:  const InputDecoration(
                                              hintText: 'Enter your email address',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // Password Field
                                        TextFieldLabelWrapper(
                                          labelText: 'Password',
                                          inputField: TextFormField(
                                            controller: passwordController,
                                            obscureText: !showPassword,
                                            decoration: InputDecoration(
                                              //hintText: 'Enter your password',
                                              hintText:lang.enterYourPassword,
                                              suffixIcon: IconButton(
                                                onPressed: () => setState(
                                                  () => showPassword = !showPassword,
                                                ),
                                                icon: Icon(
                                                  showPassword
                                                      ? FeatherIcons.eye
                                                      : FeatherIcons.eyeOff,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),

                                        // Submit Button
                                        SizedBox(
                                          width: double.maxFinite,
                                          child: ElevatedButton(
                                            onPressed: isLoading // Disable button when loading
                                                ? null
                                                : () {
                                                    _handleLogin(); // Call login with parameters
                                                  },
                                            child: isLoading // Show loading indicator
                                                ? const CircularProgressIndicator(
                                                    color: Colors.white,
                                                  )
                                                : Text(lang.signIn),
                                          ),
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
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose controllers to free up resources
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

}

 void _handleForgotPassword(BuildContext context) async {
    final _result = await showDialog(
      context: context,
      builder: (context) {
        return const ForgotPasswordDialog();
      },
    );
    devLogger(_result.toString());
  }


class ForgotPasswordDialog extends StatelessWidget {
  const ForgotPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final _theme = Theme.of(context);
    final lang = l.S.of(context);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        insetPadding: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 34),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                 lang.forgotPassword,
                  //'Forgot Password?',
                  style: _theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  lang.enterYourEmailWeWillSendYouALinkToResetYourPassword,
                  //'Enter your email, we will send you a link to Reset your password',
                  style: _theme.textTheme.bodyLarge?.copyWith(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextFieldLabelWrapper(
                 // labelText: 'Email',
                  labelText: lang.email,
                  inputField: TextFormField(
                    decoration:  InputDecoration(
                      //hintText: 'Enter your email address',
                      hintText: lang.enterYourEmailAddress,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: () {},
                    //child: const Text('Send'),
                    child:  Text(lang.send),
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
