import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crfpe_mobile/pages/home/home.dart';

class N_EtudiantSection extends StatefulWidget {
  const N_EtudiantSection({super.key});

  @override
  _N_EtudiantSectionState createState() => _N_EtudiantSectionState();
}

class _N_EtudiantSectionState extends State<N_EtudiantSection> {
  List<Map<String, String>> newsData = [];
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final authToken = prefs.getString('token') ?? '';
    final url = 'https://preprod.solaris-crfpe.fr/api/getNotifications';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> notifications = responseData['data'];
        print('newsData ${notifications}');

        setState(() {
          newsData = notifications.map((notification) {
            final data = notification['data'];
            return {
              'title': data['title']?.toString() ?? '',
              'content': data['content']?.toString() ?? '',
              'time': notification['time']?.toString() ?? '',
              'type': notification['type']?.toString() ?? '',
            };
          }).toList();
        });
      } else {
        print('Failed to load notifications');
      }
    } catch (error) {
      print('Error fetching notifications: $error');
    } finally {
      setState(() {
        isLoading = false; // Set loading to false after fetching
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Notifications',
            style: TextStyle(
              fontSize: 18, // Smaller font size
              fontWeight: FontWeight.bold,
              color: Color(0xFF1869a6),
            ),
            textAlign: TextAlign.start, // Align text to the left
          ),
        ),
        isLoading
            ? Center(
                child: CircularProgressIndicator()) // Show loading indicator
            : newsData.isEmpty
                ?
                //  Center(
                //     child: Text(
                //       'Aucune notification',
                //       style: TextStyle(fontSize: 18, color: Colors.black),
                //     ),
                //   )
                Center(
                    child: Text(
                      'Aucune notification', // Empty list message
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: newsData.length,
                    itemBuilder: (context, index) {
                      final news = newsData[index];
                      bool isNewsNotification =
                          news['type']?.contains('NewsNotification') ?? false;

                      final color = isNewsNotification
                          ? Colors.red
                          : index % 2 == 0
                              ? Color.fromARGB(255, 94, 88, 88)
                              : Color.fromARGB(255, 0, 70, 140);

                      return GestureDetector(
                        onTap: isNewsNotification
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(),
                                  ),
                                );
                              }
                            : null,
                        child: _buildNotifCard(
                            title: news['title'] ?? 'No Title',
                            content: news['content'] ?? 'No Content',
                            time: news['time'] ?? 'No Time',
                            color: color,
                            isNewsNotification: isNewsNotification),
                      );
                    },
                  ),
      ],
    );
  }

  Widget _buildNotifCard({
    required String title,
    required String content,
    required String time,
    required bool isNewsNotification,
    required Color color, // color parameter is added for customization
  }) {
    return Container(
      width: double.infinity, // Make the card width 100% of the parent
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(
                0.1), // Set the color and opacity for the bottom border
            width: 1.0, // Border width
          ),
        ),
      ),
      child: Card(
        elevation: 0, // Removed shadow by setting elevation to 0
        margin: const EdgeInsets.only(
            bottom: 0.0), // Slightly larger bottom margin for spacing
        color: Colors.grey[200], // Set to a gray background
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(0.0), // Added some rounding for the corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(
              12.0), // Added padding to give space around the content
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row for title and time
              Row(
                children: [
                  Expanded(
                    flex: 6, // Title takes up 60%
                    child: Text(
                      isNewsNotification ? "Nouvelle actualité" : title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                            .withOpacity(1), // Apply the passed color here
                      ),
                      overflow:
                          TextOverflow.ellipsis, // Truncate title if too long
                    ),
                  ),
                  SizedBox(width: 8.0), // Space between title and time
                  Expanded(
                    flex: 4, // Time takes up 40%
                    child: Text(
                      time,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black
                            .withOpacity(0.6), // Light opacity for time text
                      ),
                      textAlign: TextAlign.right, // Align time to the right
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0), // Extra space between title & content
              // Content text
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color:
                      Colors.black.withOpacity(0.7), // Text color for content
                ),
                overflow:
                    TextOverflow.ellipsis, // Truncate the content if too long
                maxLines: 2, // Allow up to 2 lines for content
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildNotifCard({
  //   required String title,
  //   required String content,
  //   required String time,
  //   required Color color,
  // }) {
  //   return Container(
  //     width: double.infinity, // Make the card width 100% of the parent
  //     child: Card(
  //       elevation: 2,
  //       margin: const EdgeInsets.only(bottom: 3.0),
  //       color: Colors.grey[300], // Set to a gray background
  //       shape: RoundedRectangleBorder(
  //         // Remove rounding
  //         borderRadius: BorderRadius.zero,
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             Row(
  //               children: [
  //                 Expanded(
  //                   flex: 6, // Title takes up 60%
  //                   child: Text(
  //                     title,
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors
  //                           .black, // Adjust the color to black or a readable color on gray
  //                     ),
  //                     overflow: TextOverflow
  //                         .ellipsis, // Truncate the title with ellipsis if too long
  //                   ),
  //                 ),
  //                 Expanded(
  //                   flex: 4, // Time takes up 40%
  //                   child: Text(
  //                     time,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors
  //                           .black, // Adjust the color to black or a readable color on gray
  //                     ),
  //                     textAlign: TextAlign.right, // Align time to the right
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 8),
  //             Text(
  //               content,
  //               style: TextStyle(
  //                 fontSize: 16,
  //                 color: Colors
  //                     .black, // Adjust the color to black or a readable color on gray
  //               ),
  //               overflow: TextOverflow
  //                   .ellipsis, // Truncate the content with ellipsis if too long
  //               maxLines: 1, // Ensure the content stays on a single line
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
