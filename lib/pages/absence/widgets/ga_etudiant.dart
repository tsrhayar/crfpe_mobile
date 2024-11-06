import 'package:flutter/material.dart';

class Ga_EtudiantSection extends StatefulWidget {
  const Ga_EtudiantSection({super.key});

  @override
  State<Ga_EtudiantSection> createState() => _Ga_EtudiantState();
}

class _Ga_EtudiantState extends State<Ga_EtudiantSection> {
  bool _obscureText = true;
  String _selectedOption = 'Absence justifiée';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Justificatifs d\'Absence',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          SizedBox(height: 20),
          _buildOption('Present'),
          _buildOption('En retard'),
          _buildOption('Absence injustifiée'),
          _buildOption('Absence justifiée'),
          SizedBox(height: 20),
          _buildCommentField(context),
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

  Widget _buildCommentField(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
      ),
      child: TextField(
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
