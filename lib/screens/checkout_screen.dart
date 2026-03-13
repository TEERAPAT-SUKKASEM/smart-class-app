import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/storage_service.dart';
import '../models/class_record.dart';

class CheckOutScreen extends StatefulWidget {
  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _formKey = GlobalKey<FormState>();
  String? qrCode;
  Position? currentPosition;

  // Form Controllers for After Class
  final _learnedController = TextEditingController();
  final _feedbackController = TextEditingController();

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
        type: 'check-out',
        timestamp: DateTime.now().toString(),
        latitude: currentPosition!.latitude,
        longitude: currentPosition!.longitude,
        learnedToday: _learnedController.text,
        feedback: _feedbackController.text,
      );

      await StorageService().saveRecord(record);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Class Finished! Reflection Saved.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please scan QR and get GPS first!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finish Class')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. QR Scanner (Again)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                ),
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
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
              ),
              Divider(),
              // 2. GPS Verification
              ListTile(
                title: Text(
                  currentPosition == null
                      ? "Location: Required"
                      : "Location Recorded",
                ),
                subtitle: Text(
                  currentPosition != null
                      ? "${currentPosition!.latitude}, ${currentPosition!.longitude}"
                      : "",
                ),
                trailing: ElevatedButton(
                  onPressed: _getLocation,
                  child: Text("Verify GPS"),
                ),
              ),
              // 3. Post-Class Reflection
              TextFormField(
                controller: _learnedController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'What did you learn today?',
                  hintText: 'Short summary of key points...',
                ),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(
                  labelText: 'Feedback for the instructor',
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: _submitData,
                child: Text(
                  "Submit & Finish",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
