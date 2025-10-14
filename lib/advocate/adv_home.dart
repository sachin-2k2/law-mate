import 'package:advocatebooking/advocate/case_status.dart';
import 'package:advocatebooking/advocate/clients.dart';
import 'package:advocatebooking/advocate/view_feedback.dart';
import 'package:advocatebooking/advocate/view_work_details.dart';
import 'package:advocatebooking/advocate/viewcase_request.dart';
import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class AdvocateHomePage extends StatefulWidget {
  const AdvocateHomePage({super.key});

  @override
  State<AdvocateHomePage> createState() => _AdvocateHomePageState();
}

Map<String, dynamic> view_profile = {};

class _AdvocateHomePageState extends State<AdvocateHomePage> {
  final Dio _dio = Dio();

  Future<void> get_profile() async {
    try {
      final response = await _dio.get('$baseurl/ViewProfileadv/$loginid/');
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is List && data.isNotEmpty && data[0] is Map<String, dynamic>) {
          setState(() => view_profile = data[0]);
        } else if (data is Map<String, dynamic>) {
          setState(() => view_profile = data);
        } else {
          showError('Unexpected response format');
        }
      } else {
        showError('Failed to load profile');
      }
    } catch (e) {
      print('Error: $e');
      showError('Error: $e');
    }
  }

  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    get_profile();
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Log Out'),
          content: const Text('Are you sure you want to logout?', style: TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => login()),
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget homeButton(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return SizedBox(
      width: 160,
      height: 160,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color.fromARGB(231, 50, 74, 163),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 8,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = view_profile['image'] != null && view_profile['image'].toString().isNotEmpty
        ? '$baseurl${view_profile['image']}'
        : '$baseurl/static/default.jpg';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(231, 50, 74, 163),
        title: const Text('Advocate Home', style: TextStyle(color: Colors.white)),
        actions: [
        
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: const Color.fromARGB(231, 50, 74, 163),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: const Color.fromARGB(231, 50, 74, 163)),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 35,
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            view_profile['Name'] ?? 'Loading...',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            view_profile['Email'] ?? 'Loading...',
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "📞 ${view_profile['Phone'] ?? 'Not available'}",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            "🎓 ${view_profile['Expertise'] ?? 'Not available'}",
                            style: const TextStyle(color: Colors.white70, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.star_half, color: Colors.yellow),
                title: const Text('View Feedback', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => viewfeedback()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.groups_rounded, color: Colors.white),
                title: const Text('View Clients', style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewClientsPage()));
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/free-photo/view-3d-justice-scales_23-2151228105.jpg?semt=ais_hybrid&w=740&q=80'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.4), Colors.black.withOpacity(0.1)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  homeButton(context, Icons.request_page, 'View Case Requests', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewCaseResult()));
                  }),
                  homeButton(context, Icons.work_outline, 'View Work Details', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const AdvocateCaseDetailsPage()));
                  }),
                  homeButton(context, Icons.groups, 'View Clients', () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ViewClientsPage()));
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
