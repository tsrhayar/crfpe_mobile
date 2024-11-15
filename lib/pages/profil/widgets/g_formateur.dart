import 'package:flutter/material.dart';
import 'package:crfpe_mobile/widgets/bottom_navigation_bar.dart'; // Import the new widget

class G_FormateurSection extends StatefulWidget {
  const G_FormateurSection({super.key});

  @override
  State<G_FormateurSection> createState() => _G_FormateurState();
}

class _G_FormateurState extends State<G_FormateurSection> {
  final TextEditingController _emailController = TextEditingController(text: 'marc.crfpe@email.com');
  final TextEditingController _proPhoneController = TextEditingController(text: '+33 1 23 45 67 89');
  final TextEditingController _proMobileController = TextEditingController(text: '+33 6 12 34 56 78');

  bool _isEditingEmail = false;
  bool _isEditingProPhone = false;
  bool _isEditingProMobile = false;

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
              color: Colors.blue,
              // Changer la couleur du texte en bleu
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
          Text(
            "Fonction : Professeur d'informatique ",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          _buildEditableRow(
            context,
            'E-mail',
            _emailController,
            _isEditingEmail,
            () {
              setState(() {
                _isEditingEmail = !_isEditingEmail;
                if (!_isEditingEmail) {
                  // Save changes when switching back from editing mode
                  // Example: saveEmail(_emailController.text);
                }
              });
            },
          ),
          _buildEditableRow(
            context,
            'Pro phone',
            _proPhoneController,
            _isEditingProPhone,
            () {
              setState(() {
                _isEditingProPhone = !_isEditingProPhone;
                if (!_isEditingProPhone) {
                  // Save changes when switching back from editing mode
                  // Example: saveProPhone(_proPhoneController.text);
                }
              });
            },
          ),
          _buildEditableRow(
            context,
            'Pro mobile',
            _proMobileController,
            _isEditingProMobile,
            () {
              setState(() {
                _isEditingProMobile = !_isEditingProMobile;
                if (!_isEditingProMobile) {
                  // Save changes when switching back from editing mode
                  // Example: saveProMobile(_proMobileController.text);
                }
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Action de confirmation
              print('E-mail: ${_emailController.text}');
              print('Pro phone: ${_proPhoneController.text}');
              print('Pro mobile: ${_proMobileController.text}');
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

  Widget _buildEditableRow(BuildContext context, String title, TextEditingController controller, bool isEditing, VoidCallback onEditToggle) {
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
                isEditing
                  ? TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                      keyboardType: TextInputType.emailAddress, // Adjust as needed
                    )
                  : Text(
                      controller.text,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
              ],
            ),
          ),
          TextButton(
            onPressed: onEditToggle,
            child: Text(isEditing ? 'Enregistrer' : 'Modifier'),
          ),
        ],
      ),
    );
  }
}
