import 'package:advocatebooking/advocate/pdfviwer.dart';
import 'package:advocatebooking/user/login.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:intl/intl.dart';

class AdvocateCaseDetailsPage extends StatefulWidget {
  const AdvocateCaseDetailsPage({super.key});

  @override
  State<AdvocateCaseDetailsPage> createState() =>
      _AdvocateCaseDetailsPageState();
}

class _AdvocateCaseDetailsPageState extends State<AdvocateCaseDetailsPage> {
  List<dynamic> caseDetails = [];
  bool isLoading = true;
  Dio dio = Dio();
  

  @override
  void initState() {
    super.initState();
    getCaseDetails();
  }

  Future<void> getCaseDetails() async {
    try {
      final response = await dio.get('$baseurl/AdvocateHistory/$loginid');
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          caseDetails = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to fetch cases')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error fetching cases')));
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'requested':
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // Open update dialog
  Future<void> showUpdateDialog(Map<String, dynamic> caseData) async {
    final TextEditingController noteController = TextEditingController();
    DateTime? selectedDate;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text('Update Case'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: noteController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Enter notes or remarks',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate ?? DateTime.now(),
                        firstDate: DateTime.now().subtract(const Duration(days: 365)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setStateDialog(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        selectedDate == null
                            ? 'Select Next Hearing Date'
                            : 'Next Hearing: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
                        style: TextStyle(
                          color: selectedDate == null ? Colors.grey : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (noteController.text.isEmpty || selectedDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter note and select date')),
                    );
                    return;
                  }

                  try {
                    final response = await dio.post(
                      '$baseurl/Casepost/$loginid', // Your API endpoint
                      data: {
                        'Description': noteController.text,
                        'Date': DateFormat('yyyy-MM-dd').format(selectedDate!),
                        'REQUESTID':caseData['id']
                      },
                    );

                    if (response.statusCode == 200 || response.statusCode == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Case updated successfully')),
                      );
                      Navigator.pop(context);
                      getCaseDetails(); // Refresh cases
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update case')),
                      );
                    }
                  } catch (e) {
                    print('Error updating case: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Error updating case')),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Case Details', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://img.freepik.com/free-photo/view-3d-justice-scales_23-2151228105.jpg?semt=ais_hybrid&w=740&q=80',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : caseDetails.isEmpty
                ? const Center(
                    child: Text(
                      'No cases assigned yet',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ListView.builder(
                      itemCount: caseDetails.length,
                      itemBuilder: (context, index) {
                        final caseData = caseDetails[index];

                        final status = caseData['Status'] ?? 'Pending';
                        final fileUrl = '$baseurl${caseData['case_File']}';
                        final caseType = caseData['case_Casetype'] ?? 'N/A';
                        final clientName = caseData['user_name'] ?? 'N/A';
                        final description = caseData['case_description'] ?? '';
                        final advocateName = caseData['adv_Name'] ?? 'N/A';

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          color: Colors.white.withOpacity(0.85),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Case Type: $caseType',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text("Client: $clientName"),
                                Text("Advocate: $advocateName"),
                                Text("Status: $status",
                                    style: TextStyle(
                                        color: getStatusColor(status),
                                        fontWeight: FontWeight.bold)),
                                Text("Description: $description"),
                                const SizedBox(height: 8),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PdfViewerPage(fileUrl: fileUrl),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'View Case File',
                                    style: TextStyle(
                                      color: Colors.blue[800],
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () {
                                    showUpdateDialog(caseData);
                                  },
                                  child: const Text('Update Case'),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
