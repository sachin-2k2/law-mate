import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class viewfeedback extends StatefulWidget {
  const viewfeedback({super.key});

  @override
  State<viewfeedback> createState() => _viewfeedbackState();
}

List<dynamic> view_feedback = [];
Dio dio = Dio();

class _viewfeedbackState extends State<viewfeedback> {
  Future<void> get_ffeedback() async {
    try {
      final response = await dio.get('$baseurl/FeedbackAPI/$loginid');
      print(response.data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          view_feedback=response.data;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('failed to get feedback')));
      }
    } catch (e) {
      print(e);
    }
  }
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_ffeedback();
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
          child: view_feedback.isEmpty
              ? Center(
                  child: Text(
                    "No feedback Found",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: view_feedback.length,
                  itemBuilder: (context, index) {
                  final  vf=view_feedback[index];
                    return Card(
                      child: ListTile(
                        title: Text("Feedback"),
                        subtitle: Column(
                          children: [
                            Row(children: [Text('Rating:'), Text(vf['Rating'].toString())]),
                            Row(
                              children: [Text("Feedback:"), Text(vf['Feedback'])],
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
