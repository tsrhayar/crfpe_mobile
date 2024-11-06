import 'package:flutter/material.dart';

class Ga_FormateurSection extends StatefulWidget {
  const Ga_FormateurSection({super.key});

  @override
  State<Ga_FormateurSection> createState() => _Ga_FormateurState();
}

class _Ga_FormateurState extends State<Ga_FormateurSection> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  String _selectedOption = 'Absence justifiée';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Gestion des absences',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          _buildNameField(),
          SizedBox(height: 20),
          _buildOption('Absence injustifiée'),
          _buildOption('Absence justifiée'),
          SizedBox(height: 20),
          _buildCommentField(),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Action de confirmation
              print('Nom et prénom: ${_nameController.text}');
              print('Option: $_selectedOption');
              print('Commentaire: ${_commentController.text}');
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

  Widget _buildNameField() {
    return TextField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nom et prénom d’étudiant',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }

  Widget _buildOption(String option) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedOption = option;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.0),
        padding: EdgeInsets.symmetric(vertical: 15.0),
        decoration: BoxDecoration(
          color: _selectedOption == option ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              color: _selectedOption == option ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCommentField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 5,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: 'Commentaire',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
