import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:advocatebooking/user/view_adv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class usr_comp extends StatefulWidget {
  const usr_comp({super.key});

  @override
  State<usr_comp> createState() => _usr_compState();
}

final _formKey = GlobalKey<FormState>();
TextEditingController complaint = TextEditingController();
Dio dio=Dio();
Future<void> post_comp(context)async{
  try {
    final response=await dio.post('$baseurl/ComplaintPostAPI/$loginid',
    data: {
      'Complaints':complaint.text
    });
    if(response.statusCode==200||response.statusCode==201){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Complaint submitted successfully')));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed')));
    
    }
  } catch (e) {
    print(e);
  }
} 

class _usr_compState extends State<usr_comp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Complaint Form')),
      body: Form(key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(crossAxisAlignment:  CrossAxisAlignment.start,
          
            children: [
              Text('Complaint Form...',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 25),),
              SizedBox(height: 50,),
              TextFormField(
                controller: complaint,
                
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'enter your feedback';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'complaint......',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              SizedBox(height: 50),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                     post_comp(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(150, 50),
                    backgroundColor: Colors.green,
                  ),
                  child: Text(
                    'Submit Complaint',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
