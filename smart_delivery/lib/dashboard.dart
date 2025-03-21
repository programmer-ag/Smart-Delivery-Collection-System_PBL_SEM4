import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile.dart';
import 'notification.dart';
// import 'history.dart';
import 'main.dart';
import './Services/mqtt_services.dart';

class DashboardUI extends StatefulWidget {
  // const DashboardUI({super.key, required this.title});
  const DashboardUI({super.key});

  //final String title;

  @override
  State<DashboardUI> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardUI> {
  
  bool isButtonDisabledLock = false;
  bool isButtonDisabledFlash = false;
  bool isDarkMode = false;
  bool isLocked = true;
  bool objectDetected = false;
  double objectWeight = 0.0;
  String doorStatus = "Closed";
  String lockStatus = "Locked";
  String parcelStatus = "Not Placed";
  String camURL = "";
  Color backgroundColor = Color(0xFFAEB8FE);
  Color textColor = Color(0xFf000000);

  final TextEditingController URLController = TextEditingController();

  late WebViewController camURLController;

  MqttService newclient = MqttService();

  @override
  void initState() {
    super.initState();
    camURLController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.disabled)
    ..loadRequest(Uri.parse("about:blank"));
    loadPreviousState();
    startListening(); // Start listening when the screen loads
  }

//   // Restore the button state
Future<void> loadPreviousState() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    isButtonDisabledLock = prefs.getBool('isButtonDisabledLock') ?? false;
    isButtonDisabledFlash = prefs.getBool('isButtonDisabledFlash') ?? false;
  });
}

// Save the button state whenever it changes
Future<void> saveButtonState() async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool('isButtonDisabledLock', isButtonDisabledLock);
  prefs.setBool('isButtonDisabledFlash', isButtonDisabledFlash);
}

  void loadUrl() {
    camURL = URLController.text;
    if(camURL != ""){
      setState(() {
      camURLController.loadRequest(Uri.parse(camURL)); // Load the URL in WebView
    });
    }
  }

  void toggleLock() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: Text("Do you want to open the lock?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // isLocked =false;
                // doorStatus = "Open";
                // lockStatus = "Unlocked";
                isButtonDisabledLock = true;
              });
              saveButtonState();
              Navigator.pop(context);
              newclient.publishMessage("servo_bool","Lock_Con");
              // newclient.publishMessage("Ultrasonic_data","placed");
              ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Door Opening...")),
                  );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void toggleFlash() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: Text("Do you want to start the flash?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                // isLocked =false;
                // doorStatus = "Open";
                // lockStatus = "Unlocked";
                isButtonDisabledFlash = true;
              });
              saveButtonState();
              Navigator.pop(context);
              newclient.publishMessage("flash","FCON");
              // newclient.publishMessage("Ultrasonic_data","placed");
              ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Door Opening...")),
                  );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

//   newclient.onConnected = () {
//   // print("Connected to MQTT Broker");
//   newclient.subscibe('Ultrasonic_data');
//   newclient.subscibe('servo_stat');
//   newclient.subscibe('MagCon_data');
// };

  void startListening() {
  Timer.periodic(Duration(seconds:5), (timer) {
    // newclient.subscibe('Ultrasonic_data');
    // newclient.subscibe('servo_stat');
    // newclient.subscibe('MagCon_data');
    // String? message;
    // String? topics;
      newclient.client.updates!.listen((List<MqttReceivedMessage<MqttMessage>>? messages) {
      final MqttPublishMessage recMessage = messages![0].payload as MqttPublishMessage;
      String message = MqttPublishPayload.bytesToStringAsString(recMessage.payload.message);
      String topics = messages![0].topic;
      print('Received message: $message from topic: $topics');
      if (topics == "servo_stat" && message == "Ack") {
      setState(() {
        // isLocked = false;
        isButtonDisabledLock = false;
        // lockStatus = "Unlock";
        if(isLocked==true){
        isLocked = false;
        lockStatus = "Unlock";
        }
        else{
          isLocked = true;
          lockStatus = "Locked";
        }
      });
      saveButtonState();
    }
    if (topics == "flash_ack" && message == "Ack") {
      setState(() {
        isButtonDisabledFlash = false;
      });
      saveButtonState();
    }
    // else {
    //   setState(() {
    //     // isLocked = false;
    //     isButtonDisabled = true;
    //     // doorStatus = "Open";
    //   });
    // }
    if (topics == "MagCon_data" && message == "close") {
      setState(() {
        // isLocked = true;
        // isButtonDisabled = false;
        // lockStatus = "Locked";
        doorStatus = "Closed";
      });
    }
    if (topics == "MagCon_data" && message == "open") {
      setState(() {
        // isLocked = false;
        // isButtonDisabled = true;
        // lockStatus = "Unlocked";
        doorStatus = "Open";
      });
    }
    if (topics == "Ultrasonic_data" && message == "placed") {
      setState(() {
        parcelStatus = "Placed";
      });
    }
    if (topics == "Ultrasonic_data" && message == "unplaced") {
      setState(() {
        parcelStatus = "Unplaced";
      });
    }
      });
    // String doorMessage = newclient.subscibe("servo_bool");
    // String parcelMessage = newclient.subscibe("Ultrasonic_data");
    // if (topics == "servo_bool" && message == "Lock closed") {
    //   setState(() {
    //     isLocked = true;
    //     doorStatus = "Closed";
    //   });
    // }
    // else
    // {
    //   print("Some error");
    // }
    // if (topics == "Ultrasonic_data" && message == "Placed") {
    //   setState(() {
    //     parcelStatus = "Placed";
    //   });
    //   print(parcelStatus);
    // //   Future.delayed(Duration(seconds: 5), () {
    // //   setState(() {
    // //     parcelStatus = "Not Placed"; // Enable the button
    // //   });
    // // });
    // }
    // else
    // {
    //   print("Some error");
    // }
  });
}

  // while(true){ {
  //   String message = newclient.subscibe("servo_bool");
  //   if(message == "Lock closed")
  //   {
  //     setState(() {
  //       isLocked = true;
  //       doorStatus = "Closed";
  //     });
  //   }
  // }

  @override
 Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Row(
          children: [
            // Image.asset('assets/logo.png', height: 30),
            SizedBox(width: 10),
            Text("Smart Box Dashboard"),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              setState(() {
                isDarkMode = !isDarkMode;
                backgroundColor = isDarkMode ? Color(0xff110b11) : Color(0xFFAEB8FE);
                textColor = isDarkMode ? Color(0xffffffff) : Color(0xFF000000);
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text("Menu", style: TextStyle(fontSize: 24)),
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profile"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.history),
            //   title: const Text("History"),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const HistoryPage()),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Notifications"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationsPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Log Out"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyApp()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
      child:Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isButtonDisabledLock ? null : toggleLock,
              style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50), // Width: 200, Height: 50
              ),  
              child: Text("Open Lock", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: textColor)),
            ),
            const SizedBox(height: 40),
            Text("Box Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: textColor)),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildStatusCard(
                    icon: isLocked ? Icons.lock : Icons.lock_open,
                    label: "Lock Status",
                    value: "Door : $doorStatus \nLatch : $lockStatus",
                  ),
                  _buildStatusCard(
                    icon: Icons.inbox,
                    label: "Object Detection",
                    value: parcelStatus,
                  ),
                  // _buildStatusCard(
                  //   icon: Icons.scale,
                  //   label: "Object Weight",
                  //   value: objectWeight == 0.0 ? "0 Kg" : "$objectWeight Kg",
                  // ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed:  isButtonDisabledFlash ? null : toggleFlash,
              style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50), // Width: 200, Height: 50
              ),  
              child: Text("Start Flash", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: textColor)),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
               Text("Cam Module URL : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                Row(
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  width: 325,
                  child:TextField(
                  controller: URLController,
                  autofocus: true, // Ensures keyboard appears when screen loads
                  decoration: InputDecoration(
                    hintText: "Enter the URL : ",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.text,
                )
                ),
                SizedBox(
                  child:IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: loadUrl, // Load URL when button is pressed
                ),
                ) 
              ]
            ),
            const SizedBox(height: 20),
            SizedBox(
              width:double.infinity,
              height: 400,
              child: camURL!=""?WebViewWidget(controller: camURLController):Container(width: 200,height: 200, color: Colors.white, child: Text("Cam module"),),
            )
              ]
            )
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildStatusCard({required IconData icon, required String label, required String value}) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 10),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}