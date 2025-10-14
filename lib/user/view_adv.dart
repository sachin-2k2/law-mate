import 'dart:io';
import 'package:advocatebooking/user/adv_fulldetails.dart';
import 'package:advocatebooking/user/login.dart'; // ✅ contains baseurl, loginid, advocateid
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class view_adv extends StatefulWidget {
  const view_adv({super.key});

  @override
  State<view_adv> createState() => _view_advState();
}

Dio dio = Dio();
List<dynamic> advocates = [];
Map<String, bool> hasUploadedCaseFile = {};
Map<String, int> caseFileIds = {};
int? advocateid;  // <-- keep this global as you want

class _view_advState extends State<view_adv> {
  @override
  void initState() {
    super.initState();
    get_adv(context);
  }

  Future<void> get_adv(context) async {
    try {
      final response = await dio.get('$baseurl/ViewAdvocates/');
      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.data);
        setState(() {
          // Removed the problematic line below:
          // advocateid = response.data['id'];

          advocates = response.data;
          for (var adv in advocates) {
            hasUploadedCaseFile[adv['id'].toString()] = false;
          }
        });
      } else {
        print('Failed to fetch advocates');
      }
    } catch (e) {
      print(e);
    }
  }

  void _showUploadDialog(String advId) {
    final _formKey = GlobalKey<FormState>();
    String caseType = '';
    String caseDescription = '';
    File? file;
    String? fileName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Upload Case File'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<String>(
                        value: caseType.isEmpty ? null : caseType,
                        onChanged: (value) {
                          setState(() {
                            caseType = value!;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Case Type',
                          border: OutlineInputBorder(),
                        ),
                        items: [
                          DropdownMenuItem(child: Text('Civil'), value: 'Civil'),
                          DropdownMenuItem(child: Text('Criminal'), value: 'Criminal'),
                          DropdownMenuItem(child: Text('Family'), value: 'Family'),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a case type';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            caseDescription = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Case Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a case description';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['pdf'],
                          );
                          if (result != null && result.files.single.path != null) {
                            setState(() {
                              file = File(result.files.single.path!);
                              fileName = result.files.single.name;
                            });
                          }
                        },
                        child: Text('Select PDF File'),
                      ),
                      if (fileName != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Selected: $fileName',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (file != null) {
                              try {
                                FormData formData = FormData.fromMap({
                                  'File': await MultipartFile.fromFile(file!.path),
                                  'Casetype': caseType,
                                  'Discription': caseDescription,
                                });

                                final response = await dio.post(
                                  '$baseurl/CaseFilepost/$loginid/',
                                  data: formData,
                                );

                                if (response.statusCode == 200 || response.statusCode == 201) {
                                  int caseFileId = response.data['id'];

                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('File uploaded successfully!')),
                                  );

                                  setState(() {
                                    hasUploadedCaseFile[advId] = true;
                                    caseFileIds[advId] = caseFileId;
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Failed to upload file')),
                                  );
                                }
                              } catch (e) {
                                print(e);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Error during upload')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Please select a PDF file')),
                              );
                            }
                          }
                        },
                        child: Text('Upload'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> send_request(BuildContext context, int advocateId, int caseFileId) async {
    try {
      advocateid = advocateId; // ✅ Store globally so other pages can use it

      final response = await dio.post(
        '$baseurl/Requestpost/$caseFileId',
        data: {
          'ADVOCATEID': advocateId,
        },
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Request sent')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send request')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/free-photo/photorealistic-lawyer-environment_23-2151152218.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: advocates.length,
          itemBuilder: (context, index) {
            final adv = advocates[index];
            final advIdStr = adv['id'].toString();
            final advIdInt = adv['id'];
            final uploaded = hasUploadedCaseFile[advIdStr] ?? false;

            return Card(
              margin: EdgeInsets.all(10),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      '$baseurl${adv['image']}',
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(Icons.person),
                    ),
                  ),
                  title: Text(adv['Name'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 6),
                      Text('Email: ${adv['Email']}'),
                      Text('Phone: ${adv['Phone']}'),
                      Text('Address: ${adv['Address']}'),
                      Text('Expertise: ${adv['Expertise']}'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              // advocateid = advIdInt; // ✅ also store globally here if needed
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => adv_fullview(index: index),
                                ),
                              );
                            },
                            icon: Icon(Icons.view_agenda_outlined, color: Colors.white),
                            label: Text('View', style: TextStyle(color: Colors.white)),
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(195, 245, 218, 48),
                            ),
                          ),
                          SizedBox(width: 10),
                          TextButton.icon(
                            onPressed: () {
                              if (!uploaded) {
                                _showUploadDialog(advIdStr);
                              } else {
                                final caseFileId = caseFileIds[advIdStr];
                                if (caseFileId != null) {
                                  send_request(context, advIdInt, caseFileId);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('No case file found')),
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              uploaded ? Icons.send_outlined : Icons.upload_file,
                              color: Colors.white,
                            ),
                            label: Text(
                              uploaded ? 'Request' : 'Upload  File',
                              style: TextStyle(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: uploaded
                                  ? Color.fromARGB(195, 33, 150, 243)
                                  : Color.fromARGB(195, 34, 161, 39),
                            ),
                          ),
                        ],
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
