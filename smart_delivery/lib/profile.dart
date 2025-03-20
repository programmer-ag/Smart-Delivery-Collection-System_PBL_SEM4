import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'notification.dart';
// import 'history.dart';
import 'global.dart';
import 'main.dart';

class Profile extends StatefulWidget {
  // const DashboardUI({super.key, required this.title});
  // final String boxId;
  // final String personName;
  // final String mobileNumber;

  // const Profile.withParameters({required this.boxId, required this.personName, required this.mobileNumber});

  const Profile({super.key});

  //final String title;

  @override
  State<Profile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<Profile> {
  
  bool isDarkMode = false;
  Color backgroundColor = Color(0xFFAEB8FE);
  Color textColor = Color(0xFf000000);

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
            Text("Profile"),
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
              leading: const Icon(Icons.dashboard),
              title: const Text("DashBoard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardUI()),
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
      body : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            const CircleAvatar(
              radius: 50,
              child : Icon(Icons.person),
              // backgroundImage: AssetImage('assets/profile.jpg'), // Replace with your profile image
            ),
            const SizedBox(height: 10),

            // User Info
           Text(
              UserData().personName,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 5),
            Text(UserData().mobileNumber, style: TextStyle(fontSize: 16, color: textColor)),
            const SizedBox(height: 20),

            // Device Info
            const Divider(),
            const SizedBox(height: 10),
            Text(
              "Device Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 10),
            _buildInfoRow("Device ID", UserData().boxId),
            _buildInfoRow("Person1", UserData().personName),
            _buildInfoRow("Person2", "-"),
            const SizedBox(height: 20),

            // Edit Profile Button
            ElevatedButton(
              onPressed: () {
                // Navigate to Edit Profile page (if needed)
              },
              child: const Text("Edit Profile"),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to create an info row
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
          Text(value, style: TextStyle(fontSize: 16, color: textColor)),
        ],
      ),
    );
  }
}