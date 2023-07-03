import 'package:flutter_blue/flutter_blue.dart';
import 'package:puckjs_app/one_tap.dart';
import 'package:puckjs_app/main.dart';

/* Beacon's data services */
const String SINGLE_TAP = "[16, 248, 1, 111, 110, 101, 7]";
const String DOUBLE_TAP = "[16, 248, 1, 116, 119, 111, 7]";
const String LONG_TAP   = "[16, 248, 1, 108, 111, 110, 103, 7]";

class BeaconScanner {

  // Default constructor
  BeaconScanner() {}

  // Retrieve FlutterBlue instance (singleton design pattern)
  FlutterBlue flutterBlue = FlutterBlue.instance; 

  // Puck.js parameters 
  final String mac = "E9:A8:AF:13:16:F2";
  final String eddystoneUrlUuid = "0000feaa-0000-1000-8000-00805f9b34fb";
  
  
  void _handleButtonPress() {
    if (sendAutomatedMessage) {
        sendMessageFromAutomatedMessage();
      } else if (callSpecificContact) {
        // TODO: Perform action for single tap with another condition
      } else{ 
          // Default single-tap action 
          callEmergencyNumber();  
      }
  }

  // Scanning and filtering process 
  void scanForBeacons() {

    // Initiate scanning process in the background
    flutterBlue.startScan(allowDuplicates: true);

    // Filter out incoming beacons
    flutterBlue.scanResults.listen((results) {
        for (ScanResult r in results) {
          /*
           Filter out packets, , keep only those sent from Puck.js 
           Check is based on sender's MAC 
          */
          if(r.device.id.toString() == mac) {
                var payload = r.advertisementData.serviceData[eddystoneUrlUuid].toString(); 
                switch(payload){
                  case SINGLE_TAP : _handleButtonPress(); break;
                  case DOUBLE_TAP : /* TODO: Add double-click functionality */ break;
                  case LONG_TAP   : /* TODO: Add long press functionality */ break;
                  default: return; 
                }           
          }   
        }

    }
  );

}


}