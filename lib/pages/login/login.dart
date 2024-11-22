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
  bool _isLoading = false; // Variable pour suivre l'état de chargement
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _checkLoggedInUser();
  }

  Future<void> _checkLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      // If the token exists, navigate to HomePage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    }
    // Load credentials if rememberMe is enabled
    _loadUserCredentials();
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
          await dio.get('https://preprod.solaris-crfpe.fr/api/csrf-token');
      final csrfToken = csrfResponse.data['csrf_token'];
      print('csrfToken : $csrfToken');

      final response = await dio.post(
        'https://preprod.solaris-crfpe.fr/api/authenticateVerify',
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

      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.data;
        print(data);
        if (data['success']) {
          if (data.containsKey('token') && data['token'] != null) {
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
            print('Token d\'authentification manquant.');
            _showErrorDialog('Token d\'authentification manquant.');
          }
        } else {
          _showErrorDialog(
              data['msg'] ?? 'Erreur de connexion. Veuillez réessayer.');
        }
      } else {
        _showErrorDialog('Erreur de connexion. Veuillez réessayer.');
      }
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 500) {
          _showErrorDialog(
              'Erreur interne du serveur. Veuillez réessayer plus tard.');
        } else {
          print(
              'Une erreur est survenue : ${e.response?.data['error'] ?? e.message}');
          _showErrorDialog(
              'Une erreur est survenue : ${e.response?.data['error'] ?? e.message}');
        }
      } else {
        print('Une erreur est survenue : $e');
        _showErrorDialog('Une erreur est survenue : $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        final String? idToken = await user.getIdToken();
        if (idToken != null) {
          final prefs = await SharedPreferences.getInstance();
          prefs.setString('token', idToken);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          _showErrorDialog(
              'Impossible de récupérer le token d\'authentification.');
        }
      }
    } catch (e) {
      print(e);
      _showErrorDialog(
          'Une erreur est survenue lors de la connexion avec Google.');
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
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFFF),
      body: Stack(
        children: [
          Center(
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
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: _rememberMe,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                  Text('Se souvenir de moi'),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'MOT DE PASSE OUBLIÉ',
                                  style: TextStyle(
                                      color: Color(0xFF1869a6),
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
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
                          SizedBox(height: 10),
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
          if (_isLoading) // Si _isLoading est vrai, afficher l'indicateur de chargement
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
