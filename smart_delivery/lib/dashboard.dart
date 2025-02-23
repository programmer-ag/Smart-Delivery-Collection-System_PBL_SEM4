import 'package:flutter/material.dart';
import 'profile.dart';
import 'notification.dart';
import 'history.dart';
import 'main.dart';

class DashboardUI extends StatefulWidget {
  // const DashboardUI({super.key, required this.title});
  const DashboardUI({super.key});

  //final String title;

  @override
  State<DashboardUI> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardUI> {
  
  bool isDarkMode = false;
  bool isLocked = true;
  bool objectDetected = false;
  double objectWeight = 0.0;
  Color backgroundColor = Color(0xFFAEB8FE);
  Color textColor = Color(0xFf000000);

  void toggleLock() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm"),
        content: Text("Do you want to ${isLocked ? 'open' : 'close'} the lock?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                isLocked = !isLocked;
              });
              Navigator.pop(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }


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
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text("History"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: toggleLock,
              child: Text(isLocked ? "Open Lock" : "Close Lock"),
            ),
            const SizedBox(height: 20),
            Text("Box Status", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold ,color: textColor)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  _buildStatusCard(
                    icon: isLocked ? Icons.lock : Icons.lock_open,
                    label: "Lock Status",
                    value: isLocked ? "Closed" : "Open",
                  ),
                  _buildStatusCard(
                    icon: Icons.inbox,
                    label: "Object Detection",
                    value: objectDetected ? "Detected" : "Not Detected",
                  ),
                  _buildStatusCard(
                    icon: Icons.scale,
                    label: "Object Weight",
                    value: objectWeight == 0.0 ? "0 Kg" : "$objectWeight Kg",
                  ),
                ],
              ),
            ),
          ],
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