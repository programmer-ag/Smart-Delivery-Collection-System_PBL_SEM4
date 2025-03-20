import 'package:flutter/material.dart';
import 'profile.dart';
import 'dashboard.dart';
// import 'history.dart';
import 'main.dart';

class NotificationsPage extends StatefulWidget {
  // const DashboardUI({super.key, required this.title});
  const NotificationsPage({super.key});

  //final String title;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {

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
        title:const Row(
          children: [
            const SizedBox(width: 10),
            const Text("Notifications"),
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
            title: Text("Please collect item", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-17 10:30 AM", style: TextStyle(color: textColor),),
          ),
          ListTile(
            title: Text("Item not collected since 3 days", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-14 09:00 AM", style: TextStyle(color: textColor),),
          ),
          ListTile(
            title: Text("Delivery attempted", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-16 05:45 PM", style: TextStyle(color: textColor),),
          ),
          ListTile(
            title: Text("Package is still inside", style: TextStyle(color: textColor),),
            trailing: Text("2025-02-17 02:15 PM", style: TextStyle(color: textColor),),
          ),
        ],
      ),
    );
  }
}