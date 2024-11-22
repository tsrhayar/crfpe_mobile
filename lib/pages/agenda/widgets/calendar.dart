import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;

class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key});

  @override
  _CalendarSectionState createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late final ValueNotifier<DateTime> _focusedDay;
  DateTime _selectedDay = DateTime.now();
  Map<String, List<Session>> _sessionsByRoom = {};
  bool _isLoading = true; // Indicateur de chargement
  List<Color> _roomColors = []; // Liste de couleurs pour les salles

  @override
  void initState() {
    super.initState();
    _focusedDay = ValueNotifier(DateTime.now());
    _fetchDataFromApi(_selectedDay); // Charger les données initiales
  }

  Future<void> _fetchDataFromApi(DateTime selectedDate) async {
    final String url =
        'https://preprod.solaris-crfpe.fr/api/mobile/agenda/${selectedDate.toLocal().toIso8601String().split('T')[0]}/1';
    final prefs = await SharedPreferences.getInstance();
    String? authToken = prefs.getString('token');
    print('authToken: ${authToken}');
    print('url: ${url}');
    try {
      setState(() {
        _isLoading = true; // Démarre le chargement
      });

      // Récupérer le token d'authentification depuis SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? authToken =
          prefs.getString('token'); // Utilise 'token' au lieu de 'auth_token'

      // Vérifier si le token est valide ou le rafraîchir si nécessaire
      if (authToken == null || await _isTokenExpired(authToken)) {
        authToken = await _refreshAuthToken(); // Rafraîchir le token
        if (authToken == null) {
          // Gérer l'échec de la récupération du token (déconnexion, etc.)
          print('Failed to refresh token. Please log in again.');
          return;
        }

        // Enregistrer le nouveau token dans SharedPreferences
        await prefs.setString(
            'token', authToken); // Utilise 'token' au lieu de 'auth_token'
      }

      // Faire la requête pour obtenir l'agenda
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Ajoute le token ici
        },
      );

      // Continue avec le traitement de la réponse comme avant
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(data);
        _parseSessions(data);
      } else {
        print('Request error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error . : $e');
    } finally {
      setState(() {
        _isLoading = false; // Fin du chargement
      });
    }
  }

  Future<bool> _isTokenExpired(String token) async {
    // Implémentez la logique pour vérifier si le token est expiré
    // Par exemple, en vérifiant une date d'expiration stockée
    // Ici, vous pouvez définir la logique selon vos besoins
    return false; // Remplacez par la vraie logique
  }

  Future<String?> _refreshAuthToken() async {
    // Implémentez la logique pour rafraîchir le token
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken =
        prefs.getString('token'); // Assurez-vous que c'est le bon nom

    if (refreshToken == null) return null;

    final response = await http.post(
      Uri.parse('https://preprod.solaris-crfpe.fr/api/refresh-token'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $refreshToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final newToken = data['auth_token'];
      await prefs.setString('auth_token', newToken); // Stocker le nouveau token
      return newToken;
    } else {
      print('Failed to refresh token: ${response.statusCode}');
      return null;
    }
  }

  void _parseSessions(List<dynamic> data) {
    Map<String, List<Session>> sessionsMap = {};
    Set<String> uniqueRooms = {};

    for (var item in data) {
      String room =
          item[0]; // Room name is the first element of each entry in 'data'

      // Iterate over sub-events (sessions) in the second element (which is a list of maps)
      for (var subEvent in item[1]) {
        String sessionName = subEvent['af']; // AF name as session name
        String seance = subEvent['seance']; // Start time
        String session = subEvent['session']; // Start time
        String startTime = subEvent['seance'].split(' - ')[0]; // Start time
        String endTime = subEvent['seance'].split(' - ')[1]; // End time
        String roomName = subEvent[
            'salle_name']; // Room name (used in the key and session details)

        // Add the room name to unique rooms set
        uniqueRooms.add(room);

        // Check if the room is already in the sessions map, if not, initialize it
        if (!sessionsMap.containsKey(roomName)) {
          sessionsMap[roomName] = [];
          // Add a unique color for each new room (can be handled elsewhere)
          _roomColors.add(Color((Random().nextDouble() * 0xFFFFFF).toInt())
              .withOpacity(1.0));
        }

        // Add the session to the map for the specific room
        sessionsMap[roomName]!.add(Session(
          name: sessionName,
          date: _selectedDay
              .toLocal()
              .toIso8601String()
              .split('T')[0], // Use the selected date
          startTime: startTime,
          seance: seance,
          session: session,
          endTime: endTime,
          nbStagiaires: subEvent[
              'nbStagiaires'], // nbStagiaires/Instructor info (from 'af')
          room: roomName, // Room
        ));
      }
    }

    // Sort the sessions by startTime for each room
    sessionsMap.forEach((room, sessions) {
      sessions.sort((a, b) {
        // Assuming startTime is in 'HH:mm' format
        DateTime timeA =
            DateTime.parse('2024-01-01 ${a.startTime}:00'); // Date is arbitrary
        DateTime timeB = DateTime.parse('2024-01-01 ${b.startTime}:00');
        return timeA.compareTo(timeB);
      });
    });

    // Update the state with the new sessions map
    setState(() {
      _sessionsByRoom = sessionsMap;
    });
  }

  @override
  void dispose() {
    _focusedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay.value,
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay.value = focusedDay;
                });
                _fetchDataFromApi(
                    selectedDay); // Charger les données pour la date sélectionnée
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Color(0xFF1869a6),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
            ),
            SizedBox(height: 16.0),
            // Afficher le spinner de chargement
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(), // Spinner de chargement
              )
            else if (_sessionsByRoom.isEmpty)
              Center(
                child: Text(
                  'Aucune séance n\'est disponible pour ce jour.', // Message lorsqu'aucune séance n'est disponible
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )
            else
              // Afficher les séances organisées ici, groupées par salle
              ..._sessionsByRoom.entries.map((entry) {
                String room = entry.key;
                List<Session> sessions = entry.value;
                Color roomColor = Color(0xFF004f91);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        room, // Afficher le nom de la salle
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: roomColor,
                        ),
                      ),
                    ),
                    ...sessions.asMap().entries.map((entry) {
                      int index = entry.key;
                      Session session = entry.value;
                      return _buildSessionCard(session, index, roomColor);
                    }).toList(),
                  ],
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard(Session session, int index, Color roomColor) {
    return Card(
      color: roomColor.withOpacity(0.7), // Utiliser la couleur de la salle
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'AF: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '${session.name}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.normal, // Regular weight for this part
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Session: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '${session.session}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.normal, // Regular weight for this part
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Séance: ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  WidgetSpan(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: Color(0xFFFCF8E3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        session.seance,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Stagiaires: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '${session.nbStagiaires}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.normal, // Regular weight for this part
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Salle: ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: '${session.room}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.normal, // Regular weight for this part
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Session {
  final String name;
  final String date; // Ajout de la date
  final String startTime;
  final String session;
  final String seance;
  final String endTime;
  final int nbStagiaires;
  final String room;

  Session({
    required this.name,
    required this.date,
    required this.session,
    required this.startTime,
    required this.seance,
    required this.endTime,
    required this.nbStagiaires,
    required this.room,
  });
}
