import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:http_parser/http_parser.dart';

class casefile_upload extends StatefulWidget {
  @override
  _casefile_uploadState createState() => _casefile_uploadState();
}

class _casefile_uploadState extends State<casefile_upload> {
  List<File> selectedFiles = [];
  TextEditingController casedesc = TextEditingController();
  TextEditingController caseType = TextEditingController();
  final formkey = GlobalKey<FormState>();
  Dio dio = Dio();

  // File picking (PDF only)
  Future<void> pickFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null) {
        setState(() {
          selectedFiles = [File(result.files.single.path!)];
        });
        print("File selected: ${selectedFiles.first.path}");
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  // Check if the file is an image (used for UI icons, not needed for PDF only)
  bool isImage(String filePath) {
    final ext = path.extension(filePath).toLowerCase();
    return ext == '.jpg' || ext == '.jpeg' || ext == '.png' || ext == '.gif';
  }

  // POST to API with file and form data
  Future<void> post_case_file(context) async {
    if (!formkey.currentState!.validate()) return;

    if (selectedFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select a PDF file.")),
      );
      return;
    }

    try {
      String fileName = path.basename(selectedFiles.first.path);

      FormData formData = FormData.fromMap({
        'Discription': casedesc.text,
        'Casetype': caseType.text,
        'File': await MultipartFile.fromFile(
          selectedFiles.first.path,
          filename: fileName,
          contentType: MediaType('application', 'pdf'),
        ),
      });

      final response = await dio.post(
        '$baseurl/CaseFilepost/$loginid',
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submitted Successfully")),
        );

        // Clear fields after successful submission
        caseType.clear();
        casedesc.clear();
        formkey.currentState!.reset();

        setState(() {
          selectedFiles.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error submitting file: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Submission failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    'Upload Case File',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(height: 50),
                  ElevatedButton.icon(
                    onPressed: pickFiles,
                    icon: Icon(Icons.upload_file, color: Colors.white),
                    label: Text("Pick Files", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(200, 50),
                    ),
                  ),
                  SizedBox(height: 20),

                  // Case Type Field
                  TextFormField(
                    controller: caseType,
                    decoration: InputDecoration(
                      labelText: 'Case Type',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter case type';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),

                  // Case Description Field
                  TextFormField(
                    controller: casedesc,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your case details';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Describe Your Case....',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                  SizedBox(height: 20),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: () => post_case_file(context),
                    label: Text("Submit", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(200, 50),
                    ),
                  ),
                  SizedBox(height: 50),

                  // Selected File Preview
                  if (selectedFiles.isNotEmpty) ...[
                    Text(
                      "Selected Files:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: selectedFiles.length,
                      itemBuilder: (context, index) {
                        final file = selectedFiles[index];
                        final fileName = file.path.split('/').last;

                        return ListTile(
                          leading: Icon(Icons.picture_as_pdf, size: 36),
                          subtitle: Text(fileName),
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                selectedFiles.removeAt(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('File removed: $fileName'),
                                  ),
                                );
                              });
                            },
                            icon: Icon(Icons.highlight_remove_sharp, color: Colors.red),
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
