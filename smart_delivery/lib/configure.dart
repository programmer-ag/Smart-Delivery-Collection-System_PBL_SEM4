import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'global.dart';
import 'main.dart';
import './Services/mqtt_services.dart';

class Configure extends StatefulWidget {
  // const DashboardUI({super.key, required this.title});
  const Configure({super.key});

  //final String title;

  @override
  State<Configure> createState() => _ConfigurePageState();
}

class _ConfigurePageState extends State<Configure> {

  bool isDarkMode = false;
  Color backgroundColor = Color(0xFFAEB8FE);
  Color textColor = Color(0xFf000000);
  final TextEditingController boxIdController = TextEditingController();
  final TextEditingController personNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  MqttService newclient = MqttService();

  @override
 Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
        title: const Row(
          children: [
            // Image.asset('assets/logo.png', height: 30),
            SizedBox(width: 10),
            Text("Configure Box"),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MyApp()),
              );
            },
          ),
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
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
      child: Padding(
      padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Box Name Input
            Text("Device ID", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            TextField(
              controller: boxIdController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter device ID",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            Text("Person name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            TextField(
              controller: personNameController,
              autofocus: true, // Ensures keyboard appears when screen loads
              decoration: InputDecoration(
                hintText: "Enter name of person",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 20),
            Text("Mobile no. : ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
            const SizedBox(height: 8),
            TextField(
              controller: mobileController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Enter mobile no. ",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 40),

            // Submit Button at the Bottom
            SizedBox(
              child: ElevatedButton(
                onPressed: () {
                  UserData().boxId = boxIdController.text;
                  UserData().personName = personNameController.text;
                  UserData().mobileNumber = mobileController.text;

                  if (boxIdController.text.isEmpty || personNameController.text.isEmpty || mobileController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Box configured successfully!")),
                  );

                  newclient.connect();

                  Navigator.push(    
                    context,      
                    MaterialPageRoute(builder: (context) => DashboardUI()),
                  );
                },
                child: const Text("Configure", style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    )
    );
  }
}