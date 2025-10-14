import 'package:advocatebooking/user/registration.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:advocatebooking/user/login.dart'; // Assuming loginid and baseurl are defined here

class ViewClientsPage extends StatefulWidget {
  const ViewClientsPage({Key? key}) : super(key: key);

  @override
  State<ViewClientsPage> createState() => _ViewClientsPageState();
}

class _ViewClientsPageState extends State<ViewClientsPage> {
  List<dynamic> clients = [];
  bool isLoading = true;
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    fetchClients();
  }

  Future<void> fetchClients() async {
    try {
      final response = await dio.get('$baseurl/ViewClients/$loginid');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          clients = response.data;
          isLoading = false;
        });
      } else {
        showError('Failed to load clients.');
      }
    } catch (e) {
      print('Error: $e');
      showError('Something went wrong.');
    }
  }

  void showError(String message) {
    setState(() => isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _openFile(String filePath) async {
    final fullUrl = '$baseurl$filePath';
    final uri = Uri.parse(fullUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open file')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Clients'),
        backgroundColor: Colors.deepPurple,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : clients.isEmpty
              ? Center(
                  child: Text(
                    'No clients found.',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: clients.length,
                  padding: EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.deepPurple,
                                child: Text(
                                  client['user_Name']?.substring(0, 1).toUpperCase() ?? '?',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              title: Text(client['user_Name'] ?? 'Unnamed Client'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Text("Email: ${client['user_Email'] ?? 'N/A'}"),
                                  Text("Phone: ${client['user_Phone'] ?? 'N/A'}"),
                                  Text("Case Type: ${client['case_Casetype'] ?? 'N/A'}"),
                                  SizedBox(height: 8),
                                  Text("Description:"),
                                  Text(
                                    client['case_description'] ?? '',
                                    style: TextStyle(color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 12),
                          
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
