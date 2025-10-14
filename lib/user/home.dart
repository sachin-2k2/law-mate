import 'package:advocatebooking/user/case_status.dart';
import 'package:advocatebooking/user/chat.dart';
import 'package:advocatebooking/user/complaint.dart';
import 'package:advocatebooking/user/history.dart';
import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/view_adv.dart';
import 'package:flutter/material.dart';

class Home_page extends StatelessWidget {
  const Home_page({super.key});

  void logout(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(253, 252, 253, 253),
          title: const Text('LogOut'),
          content: const Text(
            'Are you sure want to Logout ',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromARGB(255, 12, 12, 12)),
              ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(231, 50, 74, 163),
        title: const Text('Law Mate', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage()),
              );
            },
            icon: const Icon(Icons.chat_bubble, color: Colors.white),
            tooltip: 'Chat with Gemini',
          ),
          IconButton(
            onPressed: () {
              logout(context);
            },
            icon: const Icon(Icons.logout, color: Colors.red),
          ),
        ],
      ),
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://img.freepik.com/free-photo/view-3d-justice-scales_23-2151228105.jpg?semt=ais_hybrid&w=740&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),
                  // Row 1: Advocates & Case History
                  Row(
                    children: [
                      buildCard(
                        context,
                        icon: Icons.groups_rounded,
                        label: 'Advocates',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => view_adv()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      buildCard(
                        context,
                        icon: Icons.history_edu,
                        label: 'Case History',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CaseHistoryPage()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Row 2: Case Status & Complaint
                  Row(
                    children: [
                      buildCard(
                        context,
                        icon: Icons.auto_mode_rounded,
                        label: 'Case Status',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => case_status()),
                        ),
                      ),
                      const SizedBox(width: 10),
                      buildCard(
                        context,
                        icon: Icons.comment_rounded,
                        label: 'Complaint',
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => usr_comp()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Reusable card widget
  Widget buildCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return Container(
      height: 200,
      width: 170,
      child: Card(
        color: const Color.fromARGB(231, 50, 74, 163),
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 80, color: Colors.white),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
