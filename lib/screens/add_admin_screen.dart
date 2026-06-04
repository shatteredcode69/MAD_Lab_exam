import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Screen with a form to add admin email and security passcode.
class AddAdminScreen extends StatefulWidget {
  const AddAdminScreen({super.key});

  @override
  State<AddAdminScreen> createState() => _AddAdminScreenState();
}

class _AddAdminScreenState extends State<AddAdminScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passcodeController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Admin Email cannot be empty';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePasscode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Security Passcode cannot be empty';
    }
    if (!RegExp(r'^\d+$').hasMatch(value.trim())) {
      return 'Passcode must contain numbers only';
    }
    final int? passcode = int.tryParse(value.trim());
    if (passcode == null || passcode <= 5000) {
      return 'Passcode must be greater than 5000';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Admin added successfully!'), backgroundColor: Colors.green),
      );
      _emailController.clear();
      _passcodeController.clear();
      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Admin'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Admin Email', prefixIcon: Icon(Icons.email), border: OutlineInputBorder()),
                keyboardType: TextInputType.emailAddress,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validateEmail,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passcodeController,
                decoration: const InputDecoration(labelText: 'Security Passcode', prefixIcon: Icon(Icons.lock), border: OutlineInputBorder(), helperText: 'Numbers only, > 5000'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: _validatePasscode,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                child: const Text('Add Admin', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}