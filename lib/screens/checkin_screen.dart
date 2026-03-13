import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/storage_service.dart';
import '../models/class_record.dart';

class CheckInScreen extends StatefulWidget {
  @override
  _CheckInScreenState createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  String? qrCode;
  Position? currentPosition;

  // Form Controllers
  final _prevTopicController = TextEditingController();
  final _expectTopicController = TextEditingController();
  double _currentMood = 3; // Default to Neutral [cite: 29]

  Future<void> _getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() => currentPosition = position);
  }

  void _submitData() async {
    if (_formKey.currentState!.validate() &&
        qrCode != null &&
        currentPosition != null) {
      final record = ClassRecord(
        type: 'check-in',
        timestamp: DateTime.now().toString(),
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        prevTopic: _prevTopicController.text,
        expectedTopic: _expectTopicController.text,
        mood: _currentMood.toInt(),
      );

      await StorageService().saveRecord(record);
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Check-in Successful!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please scan QR and get GPS first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Class Check-in')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. QR Scanner Section [cite: 14]
              Container(
                height: 200,
                child: qrCode == null
                    ? MobileScanner(
                        onDetect: (capture) {
                          final List<Barcode> barcodes = capture.barcodes;
                          setState(() => qrCode = barcodes.first.displayValue);
                        },
                      )
                    : Center(
                        child: Text(
                          "QR Scanned: $qrCode",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              Divider(),
              // 2. GPS Section [cite: 14]
              ListTile(
                title: Text(
                  currentPosition == null
                      ? "Location: Unknown"
                      : "Location: ${currentPosition!.latitude}, ${currentPosition!.longitude}",
                ),
                trailing: ElevatedButton(
                  onPressed: _getLocation,
                  child: Text("Get GPS"),
                ),
              ),
              // 3. Reflection Form [cite: 21, 24]
              TextFormField(
                controller: _prevTopicController,
                decoration: InputDecoration(
                  labelText: 'Topic from previous class?',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _expectTopicController,
                decoration: InputDecoration(
                  labelText: 'What do you expect today?',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 20),
              Text("Mood: ${_currentMood.toInt()}"),
              Slider(
                value: _currentMood,
                min: 1,
                max: 5,
                divisions: 4,
                label: _currentMood.round().toString(),
                onChanged: (val) => setState(() => _currentMood = val),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _submitData,
                child: Text("Submit Check-in"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
