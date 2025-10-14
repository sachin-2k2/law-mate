import 'package:advocatebooking/user/login.dart';
import 'package:advocatebooking/user/registration.dart';
import 'package:advocatebooking/user/view_adv.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  double _rating = 3;
  String _comments = '';
  final TextEditingController _commentController = TextEditingController();
  Dio dio = Dio();

  Future<void> post_feedback(context) async {
    try {
      final response = await dio.post(
        '$baseurl/FeedbackpostAPI/$loginid',
        data: {
          'Rating': _rating,
          'Feedback': _comments,
          'ADVOCATEID': advocateid,
        },
      );
      print(advocateid);

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Feedback submitted successfully')),
        );

        // ✅ Clear the form fields after successful submission
        setState(() {
          _rating = 3; // reset to default rating
          _comments = '';
          _commentController.clear(); // clear the text field
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to submit feedback')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error submitting feedback')));
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feedback Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'How Would You Rate Us?',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),

                // ⭐ Rating System
                Text('Rate Your Experience:'),
                SizedBox(height: 15),
                RatingBar.builder(
                  initialRating: _rating,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemPadding: EdgeInsets.symmetric(horizontal: 2),
                  itemBuilder: (context, _) =>
                      Icon(Icons.star, color: Colors.amber),
                  onRatingUpdate: (rating) {
                    setState(() {
                      _rating = rating;
                    });
                  },
                ),
                SizedBox(height: 16),

                // 📝 Comment Box
                TextFormField(
                  controller: _commentController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your feedback';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Tell us more...',
                    border: OutlineInputBorder(),
                    hintText: 'What did you like? What can we improve?',
                  ),
                  maxLines: 5,
                  onChanged: (value) {
                    _comments = value;
                  },
                ),
                SizedBox(height: 16),

                // 🚀 Submit Button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        post_feedback(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(200, 60),
                      backgroundColor: Colors.green,
                    ),
                    child: Text(
                      'Submit Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
