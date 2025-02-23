import 'package:flutter/material.dart';
import 'profile.dart';
import 'notification.dart';
import 'dashboard.dart';
import 'main.dart';

class HistoryPage extends StatefulWidget {
  // const DashboardUI({super.key, required this.title});
  const HistoryPage({super.key});

  //final String title;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  bool isDarkMode = false;
  Color backgroundColor = Color(0xFFAEB8FE);
  Color textColor = Color(0xFF000000);

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
             SizedBox(width: 10),
             Text("History"),
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
            ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text("Dashboard"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardUI()),
                );
              },
            ),
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text("Box Opened", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-17 10:30 AM", style: TextStyle(color: textColor),),
          ),
          ListTile(
            title: Text("Object Kept", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-17 10:32 AM", style: TextStyle(color: textColor),),
          ),
          ListTile(
            title: Text("Box Closed", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-17 10:35 AM", style: TextStyle(color: textColor),),
          ),
          ListTile(
            title: Text("Object Removed", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-17 11:00 AM", style: TextStyle(color: textColor),),
          ),
        ],
      ),
    );
  }
}