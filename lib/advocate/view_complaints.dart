import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class view_complaints extends StatefulWidget {
  const view_complaints({super.key});

  @override
  State<view_complaints> createState() => _view_complaintsState();
}

List<dynamic> view_complint = [];
Dio dio = Dio();

class _view_complaintsState extends State<view_complaints> {
  Future<void> get_comp(context) async {
    try {
      final response = await dio.get('$baseurl/');
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          view_complint = response.data;
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed')));
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://img.freepik.com/free-photo/view-3d-justice-scales_23-2151228105.jpg?semt=ais_hybrid&w=740&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: view_complint.isEmpty
              ? Center(
                  child: Text(
                    "No Complaints Found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: view_complint.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text("Complaint"),
                        subtitle: Column(
                          children: [
                            Row(children: [Text('Replay:'), Text('replay')]),
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
