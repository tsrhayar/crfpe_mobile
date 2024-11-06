import 'package:flutter/material.dart';

class G_EtudiantSection extends StatefulWidget {
  const G_EtudiantSection({super.key});

  @override
  State<G_EtudiantSection> createState() => _G_EtudiantState();
}

class _G_EtudiantState extends State<G_EtudiantSection> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              'Gestion de Profil',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Changer la couleur du texte en bleu
              ),
            ), 
          CircleAvatar(
            radius: 50.0,
            backgroundImage: AssetImage('assets/images/avatar.png'), // Chemin de l'image de profil
          ),
          SizedBox(height: 10),
          Text(
            'Marc Doe',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Text(
            '12/08/1998',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 20),
          _buildInfoRow(context, 'E-mail', 'Lorem.ipsum@email.com'),
          _buildPasswordField(context),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Action de confirmation
            },
            child: Text('Confirmer'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, 
              backgroundColor: Colors.lightBlue,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              textStyle: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey)),
                Text(
                  value,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Action de modification
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mot de passe', style: TextStyle(color: Colors.grey)),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.6,
                  ),
                  child: TextFormField(
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                    initialValue: 'MotDePasse', // Valeur initiale pour la démo
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Action de modification
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }
}
