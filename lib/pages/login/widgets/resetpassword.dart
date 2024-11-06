// import 'package:crfpe_mobile/pages/login/login.dart';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';

// class ResetPasswordPage extends StatefulWidget {
//   @override
//   _ResetPasswordPageState createState() => _ResetPasswordPageState();
// }

// class _ResetPasswordPageState extends State<ResetPasswordPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _newPasswordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final Dio _dio = Dio();
//   bool _isLoading = false; // État de chargement

//   Future<void> _submitResetPassword() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true; // Démarrer le chargement
//       });

//       // Préparer les données à envoyer
//       final email = _emailController.text;
//       final newPassword = _newPasswordController.text;

//       // Remplacez par votre URL d'API pour réinitialiser le mot de passe
//       final resetPasswordUrl = 'https://preprod.solaris-crfpe.fr/api/generatepass';

//       try {
//         // Effectuer la requête POST pour réinitialiser le mot de passe
//         final response = await _dio.post(
//           resetPasswordUrl,
//           data: {
//             'email': email,
//             'newpass': newPassword
//           },
//           options: Options(
//             headers: {
//               'X-XCSRF-TOKEN': 'votre_token_csrf', // Remplacez par le token CSRF obtenu précédemment
//             },
//           ),
//         );

//         // Traiter la réponse de l'API
//         final responseData = response.data;
//         if (responseData['success'] == true) {
//           // Réinitialisation réussie
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(Icons.check_circle, color: Colors.green),
//                   SizedBox(width: 10),
//                   Text('Succès'),
//                 ],
//               ),
//               content: Text('Votre mot de passe a été réinitialisé avec succès.'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).pushAndRemoveUntil(
//                       MaterialPageRoute(builder: (context) => LoginPage()),
//                       (Route<dynamic> route) => false,
//                     );
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             ),
//           );
//         } else {
//           // Échec de la réinitialisation
//           showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Row(
//                 children: [
//                   Icon(Icons.error, color: Colors.red),
//                   SizedBox(width: 10),
//                   Text('Erreur'),
//                 ],
//               ),
//               content: Text(responseData['message']),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             ),
//           );
//         }
//       } on DioException catch (e) {
//         // Gérer les erreurs Dio
//         showDialog(
//           context: context,
//           builder: (context) => AlertDialog(
//             title: Row(
//               children: [
//                 Icon(Icons.error, color: Colors.red),
//                 SizedBox(width: 10),
//                 Text('Erreur'),
//               ],
//             ),
//             content: Text('Une erreur s\'est produite: ${e.message}'),
//             actions: [
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                 },
//                 child: Text('OK'),
//               )],));
          
      
        
//     } finally {
//         setState(() {
//           _isLoading = false; // Arrêter le chargement
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFF1869a6),
//         title: Text('Réinitialiser le mot de passe', style: TextStyle(color: Colors.white)),
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       body: Stack(
//         children: [
//           Center(
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         'Veuillez entrer votre e-mail et votre nouveau mot de passe.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _emailController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           labelText: 'Email',
//                           labelStyle: TextStyle(color: Color(0xFF4A4A4A)),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Veuillez entrer votre adresse e-mail';
//                           } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                             return 'Veuillez entrer une adresse e-mail valide';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _newPasswordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           labelText: 'Nouveau mot de passe',
//                           labelStyle: TextStyle(color: Color(0xFF4A4A4A)),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Veuillez entrer un nouveau mot de passe';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       TextFormField(
//                         controller: _confirmPasswordController,
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           labelText: 'Confirmez le mot de passe',
//                           labelStyle: TextStyle(color: Color(0xFF4A4A4A)),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Veuillez confirmer votre mot de passe';
//                           } else if (value != _newPasswordController.text) {
//                             return 'Les mots de passe ne correspondent pas';
//                           }
//                           return null;
//                         },
//                       ),
//                       SizedBox(height: 20),
//                       ElevatedButton(
//                         onPressed: _submitResetPassword,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xFF1869a6),
//                           padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8.0),
//                           ),
//                         ),
//                         child: Text(
//                           'Réinitialiser',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           if (_isLoading)
//             Container(
//               color: Colors.black54,
//               child: Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
