import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:geolocator/geolocator.dart';
import '../services/storage_service.dart';
import '../services/location_service.dart';
import '../models/class_record.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _formKey = GlobalKey<FormState>();
  String? qrCode;
  Position? currentPosition;

  // Form Controllers
  final _learnedController = TextEditingController();
  final _feedbackController = TextEditingController();

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
        type: 'check-out',
        timestamp: DateTime.now().toString(),
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        learnedToday: _learnedController.text,
        feedback: _feedbackController.text,
      );

      await StorageService().saveRecord(record);

      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Class Finished! Reflection Saved.')),
      );
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
        title: const Text('Finish Class'),
        backgroundColor: Colors.orange,
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
                  // 1. QR Scanner (Again)
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
                              color: Colors.orange.shade50,
                              child: Center(
                                child: Text(
                                  "QR Scanned:\n$qrCode",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.orange,
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

                  // 2. GPS Verification
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      currentPosition == null
                          ? "Location: Required"
                          : "Location Recorded",
                    ),
                    subtitle: Text(
                      currentPosition == null
                          ? "Please verify GPS"
                          : "${currentPosition!.latitude}, ${currentPosition!.longitude}",
                    ),
                    trailing: ElevatedButton.icon(
                      icon: const Icon(Icons.location_on),
                      label: const Text("Verify GPS"),
                      onPressed: _getLocation,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 16),

                  // 3. Post-Class Reflection
                  const Text(
                    "Post-Class Reflection",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _learnedController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'What did you learn today?',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _feedbackController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: 'Feedback for the instructor (Optional)',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _submitData,
                    child: const Text(
                      "Submit & Finish",
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
