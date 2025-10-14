import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class casestatus_update extends StatefulWidget {
  const casestatus_update({super.key});

  @override
  State<casestatus_update> createState() => _casestatus_updateState();
}

final _formKey = GlobalKey<FormState>();

class _casestatus_updateState extends State<casestatus_update> {
  TextEditingController _statusController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.day}-${picked.month}-${picked.year}";
      });
    }
  }
  Dio dio=Dio();

Future<void>post_status(context)async{
try {
  final response=await dio.post('$baseurl/');
  if (response.statusCode==200||response.statusCode==201) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('case status upadted successfully')));
    
  } else {
    
  }
} catch (e) {
  
}
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://img.freepik.com/free-photo/view-3d-justice-scales_23-2151228105.jpg?semt=ais_hybrid&w=740&q=80',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Case Status TextField
                  TextFormField(
                    controller: _statusController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Case status...',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                          color: Colors.white,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter case status';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Next Hearing Date TextField
                  TextFormField(
                    controller: _dateController,
                    style: const TextStyle(color: Colors.white),
                    readOnly: true,
                    onTap: _pickDate,
                    decoration: InputDecoration(
                      labelText: 'Next Hearing Date',
                      labelStyle: const TextStyle(color: Colors.white),
                      suffixIcon: const Icon(Icons.calendar_today, color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),

                  // Update Button
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Submitting status...')),
                        );
                        // Here you can add your logic to save status and date
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 60),
                      backgroundColor: Colors.green,
                    ),
                    child: const Text(
                      'Update Status',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
