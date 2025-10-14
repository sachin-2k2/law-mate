import 'package:advocatebooking/user/login.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class usr_registration extends StatefulWidget {
  const usr_registration({super.key});

  @override
  State<usr_registration> createState() => _usr_registrationState();
}

TextEditingController name = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController phone = TextEditingController();
TextEditingController password = TextEditingController();
TextEditingController usrname = TextEditingController();
final formkey=GlobalKey<FormState>();
Dio dio = Dio();
final baseurl = 'http://192.168.1.39:5000';
Future<void> post_reg(context) async {
  final response = await dio.post(
    '$baseurl/user_api/',
    data: {
      'Name': name.text,
      'Email': email.text,
      'Phone': phone.text,
      'Password': password.text,
      'Username':usrname.text
    },
  );
  if (response.statusCode == 200 || response.statusCode == 201) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => login()));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Registration Successfull')));
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
  }
}

class _usr_registrationState extends State<usr_registration> {
  bool visible = true;
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'Registration Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 70),
                
                    TextFormField(
                      controller: name,
                      validator: (value) => value!.isEmpty ? "Enter your name" : null,
                      style: TextStyle(
                        color: const Color.fromARGB(227, 255, 255, 255),
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          'Name',
                          style: TextStyle(
                            color: const Color.fromARGB(227, 255, 255, 255),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(122, 255, 255, 255),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40,),
                    TextFormField(
                      controller: usrname,
                      validator: (value) => value!.isEmpty ? "Enter your name" : null,
                      style: TextStyle(
                        color: const Color.fromARGB(227, 255, 255, 255),
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          'User Name',
                          style: TextStyle(
                            color: const Color.fromARGB(227, 255, 255, 255),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(122, 255, 255, 255),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: email,
                      validator: (value) => value!.isEmpty ? "Enter your email" : null,
                      style: TextStyle(
                        color: const Color.fromARGB(227, 255, 255, 255),
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          'Email',
                          style: TextStyle(
                            color: const Color.fromARGB(227, 255, 255, 255),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(122, 255, 255, 255),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      controller: phone,
                      validator: (value) => value!.isEmpty ? "Enter your phno" : null,
                      style: TextStyle(
                        color: const Color.fromARGB(227, 255, 255, 255),
                      ),
                      decoration: InputDecoration(
                        label: Text(
                          'Phone number',
                          style: TextStyle(
                            color: const Color.fromARGB(227, 255, 255, 255),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(122, 255, 255, 255),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    TextFormField(
                      obscureText: visible,
                      controller: password,
                      validator: (value) => value!.isEmpty ? "Enter your password" : null,
                      style: TextStyle(
                        color: const Color.fromARGB(227, 255, 255, 255),
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            visible = !visible;
                            setState(() {});
                          },
                          icon: Icon(
                            visible
                                ? Icons.remove_red_eye
                                : Icons.remove_red_eye_sharp,
                          ),
                        ),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            color: const Color.fromARGB(227, 255, 255, 255),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            color: const Color.fromARGB(122, 255, 255, 255),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                       if(formkey.currentState!.validate()){
                        post_reg(context);
                       }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: const Color.fromARGB(255, 91, 17, 151),
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
