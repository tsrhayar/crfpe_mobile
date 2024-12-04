import 'package:crfpe_mobile/pages/login/widgets/forgotpassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:crfpe_mobile/pages/home/home.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _isLoading = false; // Track loading state
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      // Navigate to HomePage if token exists
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      // Load credentials if rememberMe is enabled
      _loadUserCredentials();
    }

    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false; // Stop loading after 2 seconds
      });
    });
  }

  Future<void> _loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      }
    });
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    final dio = Dio();

    try {
      final csrfResponse =
          // await dio.get('https://preprod.solaris-crfpe.fr/api/csrf-token');
          await dio.get('https://solaris-crfpe.fr/api/csrf-token');
      final csrfToken = csrfResponse.data['csrf_token'];
      print('csrfToken : $csrfToken');

      final response = await dio.post(
        // 'https://preprod.solaris-crfpe.fr/api/authenticateVerify',
        'https://solaris-crfpe.fr/api/authenticateVerify',
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'csrf-token': csrfToken,
          },
        ),
        data: <String, String>{
          'email': _emailController.text,
          'password': _passwordController.text,
          'remember': _rememberMe.toString(),
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final data = response.data;
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('token', data['token']);
        prefs.setString('role', data['role']);
        prefs.setString('user_id', data['user_id']);
        prefs.setString('user_fullname', data['user_fullname']);
        if (_rememberMe) {
          prefs.setString('email', _emailController.text);
          prefs.setString('password', _passwordController.text);
          prefs.setBool('rememberMe', true);
        } else {
          prefs.remove('email');
          prefs.remove('password');
          prefs.setBool('rememberMe', false);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        _showErrorDialog(
            response.data['msg'] ?? 'Erreur de connexion. Veuillez réessayer.');
      }
    } catch (e) {
      _showErrorDialog('Une erreur est survenue : $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Erreur'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFFFFFFFFF),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Color(0xFFE6EEF7),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 32.0),
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          height: 100,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Centre Régional de Formation des Professionnels de l\'Enfance',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1869a6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Text(
                  'Bienvenue au CRFPE',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Plateforme de formation SOLARIS',
                  style: TextStyle(color: Color(0xFF808080)),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Login',
                          labelStyle: TextStyle(color: Color(0xFF4A4A4A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre login';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(color: Color(0xFF4A4A4A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1869a6),
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text('Se connecter',
                            style: TextStyle(color: Color(0xFFFFFFFFF))),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '2024© Plateforme de formation SOLARIS',
                  style: TextStyle(color: Color(0xFF808080)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}