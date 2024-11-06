import 'package:crfpe_mobile/pages/login/login.dart';
//import 'package:crfpe_mobile/pages/login/widgets/resetpassword.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false; // État de chargement

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true; // Démarrer le chargement
    });

    final dio = Dio();

    try {
      // Récupérer le token CSRF
      final csrfResponse = await dio.get('https://preprod.solaris-crfpe.fr/api/csrf-token');
      if (csrfResponse.statusCode == 200 && csrfResponse.data['csrf_token'] != null) {
        final csrfToken = csrfResponse.data['csrf_token'];

        final response = await dio.post(
          'https://preprod.solaris-crfpe.fr/api/resetpassword',
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'csrf-token': csrfToken,
            },
          ),
          data: <String, String>{
            'email': _emailController.text,
          },
        );

        if (response.statusCode == 200) {
          final data = response.data;

          if (data is Map) {
            if (data.containsKey('success') && data['success'] == true) {
              // Show success dialog and navigate after closing the dialog
              _showSuccessDialog('Rendez-vous dans votre boîte mail, pour le lien de réinitialisation.').then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              });
            } else {
              _showErrorDialog(data['msg'] ?? "Ce mail n'existe pas dans nos serveurs.");
            }
          } else {
            _showErrorDialog('Format de réponse inattendu.');
          }
        } else {
          _showErrorDialog('Erreur. Veuillez réessayer.');
        }
      } else {
        _showErrorDialog('Erreur lors de la récupération du token CSRF.');
      }
    } catch (e) {
      if (e is DioException) {
        print('Caught DioError: ${e.response?.data}');
        if (e.response?.data is Map) {
          final errorData = e.response?.data as Map;
          final errorMessage = errorData['error'] ?? e.message;
          _showErrorDialog('Une erreur est survenue : $errorMessage');
        } else {
          _showErrorDialog('Une erreur est survenue : ${e.message}');
        }
      } else {
        print('Caught Exception: $e');
        _showErrorDialog('Une erreur est survenue : $e');
      }
    } finally {
      setState(() {
        _isLoading = false; // Arrêter le chargement
      });
    }
  }

  Future<void> _showSuccessDialog(String message) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 40),
              SizedBox(width: 10),
              Text('Succès'),
            ],
          ),
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red, size: 40),
              SizedBox(width: 5),
              Text('Erreur'),
            ],
          ),
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
      appBar: AppBar(
        backgroundColor: Color(0xFF1869a6),
        title: Text(
          'Réinitialiser le mot de passe',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Veuillez entrer votre adresse e-mail pour recevoir un lien de réinitialisation.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Color(0xFF4A4A4A)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre adresse e-mail';
                          } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Veuillez entrer une adresse e-mail valide';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _resetPassword();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1869a6),
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Envoyer le mail',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Animation de chargement verte
                ),
              ),
            ),
        ],
      ),
    );
  }
}
