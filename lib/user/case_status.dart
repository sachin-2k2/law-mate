import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class case_status extends StatefulWidget {
  const case_status({super.key});

  @override
  State<case_status> createState() => _case_statusState();
}

Dio dio = Dio();
List<dynamic> casestatus = [];

class _case_statusState extends State<case_status> {
  Future<void> get_status(context) async {
    try {
      final response = await dio.get(
        '$baseurl/CaseStatus/$loginid',
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          casestatus = response.data;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Fetching failed')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    get_status(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Case Status"),
        backgroundColor: Colors.black87,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://img.freepik.com/free-photo/photorealistic-lawyer-environment_23-2151152218.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: casestatus.isEmpty
            ? Center(
                child: Text(
                  "No cases found.",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              )
            : ListView.builder(
                itemCount: casestatus.length,
                itemBuilder: (context, index) {
                  final cs = casestatus[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8.0),
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.gavel, color: Colors.black87),
                                SizedBox(width: 8),
                                Text(
                                  cs['case_Casetype'] ?? 'Unknown Case Type',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.grey[400]),
                            SizedBox(height: 6),
                            Text(
                              'Case Description:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              cs['case_description'] ?? '',
                              style: TextStyle(fontSize: 15),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Status:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              cs['Description'] ?? '',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.deepPurple,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Next Hearing Date:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              cs['Date'] ?? 'Not Available',
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
