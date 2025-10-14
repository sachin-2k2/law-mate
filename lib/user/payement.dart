import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedPaymentMethod = 'Credit/Debit Card';
  final List<String> _paymentMethods = ['Credit/Debit Card', 'UPI', 'Net Banking'];

  // Method to simulate payment
  void _processPayment() {
    if (_amountController.text.isEmpty) {
      // If no amount is entered, show error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an amount!')),
      );
      return;
    }

    double amount = double.tryParse(_amountController.text) ?? 0;

    if (amount <= 0) {
      // Validate if amount is greater than zero
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid amount!')),
      );
      return;
    }

    // Simulate payment processing
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Processing Payment...'),
        content: CircularProgressIndicator(),
      ),
    );

    // Simulating delay for payment processing
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context); // Close the progress dialog
      // Show success message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful'),
          content: Text('You have successfully paid \$${amount.toStringAsFixed(2)} to the admin via $_selectedPaymentMethod.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the success dialog
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and Instructions
            Text(
              'Make a Payment to Admin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Enter the amount you want to pay below:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),

            // Amount Input Field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixIcon: Icon(Icons.money),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),

            // Payment Method Dropdown
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: _paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
              decoration: InputDecoration(
                labelText: 'Select Payment Method',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40),

            // Payment Button
            ElevatedButton(
              onPressed: _processPayment,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Pay Now',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
