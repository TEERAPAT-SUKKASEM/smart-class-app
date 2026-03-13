import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../models/class_record.dart';

class CheckInScreen extends StatefulWidget {
  const CheckInScreen({Key? key}) : super(key: key);

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
  double _currentMood = 3; // Default to Neutral

  Future<void> _getLocation() async {
    Position? position = await LocationService().getCurrentLocation();

    if (position != null) {
      setState(() => currentPosition = position);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get location. Please check permissions.'),
        ),
      );
    }
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

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Check-in Successful!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please scan QR and get GPS first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Check-in'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. QR Scanner Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: qrCode == null
                          ? MobileScanner(
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                setState(
                                  () => qrCode = barcodes.first.displayValue,
                                );
                              },
                            )
                          : Container(
                              color: Colors.green.shade50,
                              child: Center(
                                child: Text(
                                  "QR Scanned:\n$qrCode",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Divider(),

                  // 2. GPS Section
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      currentPosition == null
                          ? "Location: Unknown"
                          : "Location Recorded",
                    ),
                    subtitle: Text(
                      currentPosition == null
                          ? "Please get GPS"
                          : "${currentPosition!.latitude}, ${currentPosition!.longitude}",
                    ),
                    trailing: ElevatedButton.icon(
                      icon: const Icon(Icons.location_on),
                      label: const Text("Get GPS"),
                      onPressed: _getLocation,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 3. Reflection Form
                  const Text(
                    "Pre-Class Reflection",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _prevTopicController,
                    decoration: InputDecoration(
                      labelText: 'Topic from previous class?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _expectTopicController,
                    decoration: InputDecoration(
                      labelText: 'What do you expect today?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Your Mood: ${_currentMood.toInt()}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _currentMood,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: _currentMood.round().toString(),
                    activeColor: Colors.green,
                    onChanged: (val) => setState(() => _currentMood = val),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitData,
                    child: const Text(
                      "Submit Check-in",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
