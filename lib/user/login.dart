import 'package:advocatebooking/advocate/adv_home.dart';
import 'package:advocatebooking/advocate/adv_register.dart';
import 'package:advocatebooking/public%20user/viewadv.dart';
import 'package:advocatebooking/user/home.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

int? loginid;

class _loginState extends State<login> {
  final TextEditingController usrname = TextEditingController();
  final TextEditingController password = TextEditingController();
  final formkey = GlobalKey<FormState>();
  final Dio dio = Dio();
  void dialog_reg() {
    showDialog(
      context: context,
      builder: (context) {
        return Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => advocate_registration(),));
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(280, 50),
                backgroundColor: Color.fromARGB(255, 91, 17, 151),
              ),
              child: Text('Advocate', style: TextStyle(color: Colors.white)),
            ),
            SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => usr_registration(),));},
               
              style: ElevatedButton.styleFrom(
                minimumSize: Size(280, 50),
                backgroundColor: Color.fromARGB(255, 91, 17, 151),
              ),
              child: Text('User', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  bool visible = true; // ✅ State variable - not inside build()
  Future<void> login_api(BuildContext context) async {
    try {
      final response = await dio.post(
        '$baseurl/loginapi/',
        data: {'Username': usrname.text, 'Password': password.text},
      );

      print(response.data);
      final usr_type = response.data['usertype'];

      if (response.statusCode == 200 || response.statusCode == 201) {
        loginid = response.data['login_id'];
        if (usr_type == 'USER') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home_page()),
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login Successful")));
        } else if (usr_type == 'pending') {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login Pending")));
        } else if (usr_type == 'Advocate') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdvocateHomePage()),
          );
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login Successful")));
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Invalid user")));
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed')));
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: formkey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 120),
                    Text(
                      'Login Page',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 80),

                    // Username field
                    TextFormField(
                      controller: usrname,
                      validator: (value) =>
                          value!.isEmpty ? "Enter username" : null,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),

                    // Password field
                    TextFormField(
                      controller: password,
                      obscureText: visible,
                      validator: (value) =>
                          value!.isEmpty ? "Enter password" : null,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              visible = !visible;
                            });
                          },
                          icon: Icon(
                            visible ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white38),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                    ),

                    // // Forgot password
                    // Padding(
                    //   padding: const EdgeInsets.only(left: 220.0),
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'Forgot password?',
                    //       style: TextStyle(color: Colors.white, fontSize: 13),
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 40),

                    // Login button
                    ElevatedButton(
                      onPressed: () {
                        if (formkey.currentState!.validate()) {
                          login_api(context);
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(280, 50),
                        backgroundColor: Color.fromARGB(255, 91, 17, 151),
                      ),
                    ),

                    SizedBox(height: 150),

                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    TextButton(
              
                      onPressed: dialog_reg,
                      child: Text(
                        'Register Now',
                        style: TextStyle(
                          color: Color.fromARGB(255, 39, 55, 133),
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Login As', style: TextStyle(color: Colors.white)),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PublicUsrView(),
                              ),
                            );
                          },
                          child: Text(
                            'Guest',
                            style: TextStyle(
                              color: Color.fromARGB(255, 39, 55, 133),
                            ),
                          ),
                        ),
                      ],
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
