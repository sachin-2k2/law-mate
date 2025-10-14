import 'package:advocatebooking/user/login.dart'; // contains baseurl
import 'package:advocatebooking/user/registration.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class PublicUsrView extends StatefulWidget {
  const PublicUsrView({super.key});

  @override
  State<PublicUsrView> createState() => _PublicUsrViewState();
}

class _PublicUsrViewState extends State<PublicUsrView> {
  Dio dio = Dio();
  List<dynamic> advocates = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAdvocates();
  }

  Future<void> getAdvocates() async {
    try {
      final response = await dio.get('$baseurl/ViewAdvocates/');
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          advocates = response.data;
          isLoading = false;
        });
      } else {
        print('Failed to fetch advocates');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching advocates: $e');
      setState(() {
        isLoading = false;
      });
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
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : advocates.isEmpty
                ? const Center(child: Text('No advocates found.'))
                : ListView.builder(
                    itemCount: advocates.length,
                    itemBuilder: (context, index) {
                      final adv = advocates[index];
                      return Card(
                        margin: const EdgeInsets.all(10),
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
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.person),
                              ),
                            ),
                            title: Text(
                              adv['Name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 6),
                                Text('Email: ${adv['Email']}'),
                                Text('Phone: ${adv['Phone'].toString()}'),
                                Text('Address: ${adv['Address']}'),
                                Text('Expertise: ${adv['Expertise']}'),
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
