import 'package:advocatebooking/user/feedback.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:advocatebooking/user/view_adv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class adv_fullview extends StatefulWidget {
  final int index;
  const adv_fullview({super.key, required this.index});

  @override
  State<adv_fullview> createState() => _adv_fullviewState();
}

Dio dio = Dio();

class _adv_fullviewState extends State<adv_fullview> {
  void openGoogleMeet() async {
    final Uri googleMeetUri = Uri.parse('https://meet.google.com/');
    try {
      await launchUrl(googleMeetUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      print('Failed to open Google Meet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final adv = advocates[widget.index];

    return Scaffold(
      appBar: AppBar(
        title: Text("Advocate Details"),
        backgroundColor: Color.fromARGB(231, 50, 74, 163),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '$baseurl${adv['image']}',
                    height: 240,
                    width: 240,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 100),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  adv['Name'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
              ),
              const SizedBox(height: 20),

             
              Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.blue,
                  child: IconButton(
                    onPressed: openGoogleMeet,
                    icon: Icon(Icons.video_call, color: Colors.white, size: 18),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Email
              Text(
                'Email:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                adv['Email'],
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 15),

              // Phone
              Text(
                'Phone:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                adv['Phone'].toString(),
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 15),

              // Address
              Text(
                'Address:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                adv['Address'],
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 15),

              // Expertise
              Text(
                'Expertise:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                adv['Expertise'],
                style: TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 30),

              // Request Button
              Center(
                child: ElevatedButton(
                  onPressed:(){Navigator.push(context,MaterialPageRoute(builder: (context) => FeedbackPage(),));} 
                 
                  ,
                  child: Text('Feedback', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(177, 29, 98, 17),
                    minimumSize: Size(280, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
