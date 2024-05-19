import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: UserInputScreen(),
    );
  }
}

class UserInputScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();

  static const platform = MethodChannel('com.example.pdf_creator/textToSpeech');

  UserInputScreen({super.key});

  void _submitData(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      final name = _nameController.text;
      final address = _addressController.text;
      final city = _cityController.text;
      final state = _stateController.text;
      final country = _countryController.text;

      final userData = {
        'name': name,
        'address': address,
        'city': city,
        'state': state,
        'country': country,
      };

      try {
        await platform.invokeMethod('speakText', userData);
      } on PlatformException catch (e) {
        debugPrint("Failed to invoke method: '${e.message}'.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Input')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                CustomTextFormField(
                  controller: _nameController,
                  labelText: 'Name',
                ),
                CustomTextFormField(
                  controller: _addressController,
                  labelText: 'Address Line 1',
                ),
                CustomTextFormField(
                  controller: _cityController,
                  labelText: 'City',
                ),
                CustomTextFormField(
                  controller: _stateController,
                  labelText: 'State',
                ),
                CustomTextFormField(
                  controller: _countryController,
                  labelText: 'Country',
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => _submitData(context),
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;

  const CustomTextFormField({
    required this.controller,
    required this.labelText,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $labelText';
        }
        return null;
      },
    );
  }
}
