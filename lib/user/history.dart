import 'package:advocatebooking/user/registration.dart';
import 'package:advocatebooking/user/view_adv.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:advocatebooking/user/login.dart';

class CaseHistoryPage extends StatefulWidget {
  const CaseHistoryPage({super.key});

  @override
  State<CaseHistoryPage> createState() => _CaseHistoryPageState();
}

class _CaseHistoryPageState extends State<CaseHistoryPage> {
  Dio dio = Dio();
  List<dynamic> caseHistory = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCaseHistory();
  }

  Future<void> fetchCaseHistory() async {
    try {
      final response = await dio.get('$baseurl/RequestHistory/$loginid');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          caseHistory = response.data;
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching case history: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'pending':
      case 'requested':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Case History'),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError
              ? const Center(
                  child: Text('Failed to load case history'),
                )
              : caseHistory.isEmpty
                  ? const Center(
                      child: Text(
                        'No case requests found.',
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchCaseHistory,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12.0),
                        itemCount: caseHistory.length,
                        itemBuilder: (context, index) {
                          final caseItem = caseHistory[index];

                          final advocateName =
                              caseItem['adv_Name'] ?? 'Unknown Advocate';
                          final caseType =
                              caseItem['case_Casetype'] ?? 'Not specified';
                          final caseDesc =
                              caseItem['case_description'] ?? 'No description';
                          final status =
                              caseItem['Status'] ?? 'Requested';
                          final username =
                              caseItem['user_name'] ?? 'No user name provided';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    advocateName,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text('Case Type: $caseType'),
                                  const SizedBox(height: 3),
                                  Text('Description: $caseDesc'),
                                  const SizedBox(height: 3),
                                  Text('Username: $username'),
                                  const SizedBox(height: 8),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: getStatusColor(status)
                                            .withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: getStatusColor(status),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        status.toUpperCase(), // ACCEPTED / REJECTED / PENDING
                                        style: TextStyle(
                                          color: getStatusColor(status),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
