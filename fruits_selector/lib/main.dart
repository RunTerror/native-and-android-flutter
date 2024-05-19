import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FruitSelectorScreen(),
    );
  }
}

class FruitSelectorScreen extends StatefulWidget {
  const FruitSelectorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FruitSelectorScreenState createState() => _FruitSelectorScreenState();
}

class _FruitSelectorScreenState extends State<FruitSelectorScreen> {
  static const platform =
      MethodChannel('com.example.fruits_selector/select_fruits');
  List<String> selectedFruits = [];

  @override
  void initState() {
    super.initState();
    platform.setMethodCallHandler(_handleNativeMethodCall);
  }

  Future<void> _handleNativeMethodCall(MethodCall call) async {
    if (call.method == "selectedFruits") {
      setState(() {
        selectedFruits = List<String>.from(call.arguments);
      });
    }
  }

  Future<void> _selectFruits() async {
    try {
      await platform.invokeMethod('selectFruits');
    } on PlatformException catch (e) {
      debugPrint("Failed to invoke: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Fruits'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectFruits,
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black)),
              child: const Text('Select Fruits'),
            ),
            const SizedBox(height: 20),
            if (selectedFruits.isNotEmpty)
              Expanded(
                child: ListView(
                  children: selectedFruits.map((fruit) {
                    return Column(
                      children: [
                        Text(fruit),
                        Image.asset('assets/images/$fruit.jpg',
                            width: 100, height: 100),
                      ],
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
