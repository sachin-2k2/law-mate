import 'package:advocatebooking/advocate/pdfviwer.dart';
import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewCaseResult extends StatefulWidget {
  const ViewCaseResult({super.key});

  @override
  State<ViewCaseResult> createState() => _ViewCaseResultState();
}

class _ViewCaseResultState extends State<ViewCaseResult> {
  List<dynamic> request = [];
  Dio dio = Dio();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getRequests();
  }

  // Fetch all requests
  Future<void> getRequests() async {
    try {
      final response = await dio.get('$baseurl/ViewRequest/$loginid');
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          request = response.data;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to load requests')));
      }
    } catch (e) {
      print('Error fetching requests: $e');
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error loading requests')));
    }
  }

  // Accept API call
  Future<void> acceptCase(int caseId) async {
    try {
      final response = await dio.get(
        '$baseurl/CaseStatusPost/$caseId', // Replace with your actual accept API endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Case accepted successfully')));
        getRequests(); // Refresh list
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to accept case')));
      }
    } catch (e) {
      print('Error accepting case: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error accepting case')));
    }
  }

  // Reject API call
  Future<void> rejectCase(int caseId) async {
    try {
      final response = await dio.post(
        '$baseurl/CaseStatusPost/$caseId', // Replace with your actual reject API endpoint
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Case rejected successfully')));
        getRequests(); // Refresh list
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Failed to reject case')));
      }
    } catch (e) {
      print('Error rejecting case: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error rejecting case')));
    }
  }

  Color getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Request History', style: TextStyle(color: Colors.white)),
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
            : request.isEmpty
                ? const Center(
                    child: Text(
                      'No requests found',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  )
                : ListView.builder(
                    itemCount: request.length,
                    itemBuilder: (context, index) {
                      final req = request[index];
                      final caseFile = req['case_File'] ?? 'No file';
                      final status = req['Status'] ?? 'Requested';
                      final advocateName = req['user_name'] ?? 'Unknown';
                      final caseId = req['id']; // Get case id from API

                      return Card(
                        color: Colors.white.withOpacity(0.9),
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User: $advocateName',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text('Case Type: ${req['case_Casetype']}'),
                              Text('Description: ${req['case_description']}'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    'Case File: ',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      final fullUrl = '$baseurl${req['case_File']}';
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PdfViewerPage(fileUrl: fullUrl),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      caseFile.split('/').last,
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Text(
                                    'Status: ',
                                    style: TextStyle(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    status,
                                    style: TextStyle(
                                      color: getStatusColor(status),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // ✅ Accept / Reject buttons only if status is requested/pending
                              if (status.toLowerCase() == 'requested' ||
                                  status.toLowerCase() == 'pending')
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => acceptCase(caseId),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green),
                                      child: const Text('Accept'),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () => rejectCase(caseId),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      child: const Text('Reject'),
                                    ),
                                  ],
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
