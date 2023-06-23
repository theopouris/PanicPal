import 'package:flutter/material.dart';
import 'settings.dart';
//import 'reminders.dart';
import 'testrem.dart';
import 'contacts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


void main() {
  runApp(const PanicButtonApp());
}

class PanicButtonApp extends StatelessWidget {
  const PanicButtonApp({super.key});

    @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (BuildContext context, Widget? child) {
        // Initialize the screen util
      
        return MaterialApp(
          title: 'PanicPal',
          theme: ThemeData(
            primaryColor: const Color(0xFF2C3D7A),
            scaffoldBackgroundColor: const Color(0xFF2C3D7A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1D1A22),
            ),
          ),
          home: const HomePage(),
        );
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleButtonPress() {
    // Print a message to the console
    print('SOS button pressed!');
  }

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsScreen()),
    );
  }

  void _navigateToReminders(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const ReminderScreen(
                reminders: [],
              )),
    );
  }

  void _navigateToContacts(BuildContext context) {
    Navigator.pop(context); // Close the drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ContactPage()),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: Theme.of(context).copyWith(
            dialogBackgroundColor:
                const Color(0xFF1D1A22), // Set background color
            textTheme: const TextTheme(
              headline6: TextStyle(
                color: Colors.white, // Set text color
                fontWeight: FontWeight.bold,
              ),
              bodyText2: TextStyle(
                color: Colors.white, // Set text color
              ),
            ),
            buttonTheme: const ButtonThemeData(
              buttonColor: Color(0xFF2C3D7A), // Set button color
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0), // Set round edges
            ),
            title: const Text('Information'),
            content: const Text(
                'Welcome to PanicPal app! With our innovative technology you have complete control over you panic button experience. The functionality of the sensor puck-js varies depending on how you press it. For instance, a single press can send a quick message to a pre-selected contact. We understand that everyone has different needs and preferences, so you can easily customize these functionalities through the settings section in the menu. Want to customize it even further? Just head to settings and explore the options. Additionally, we understand the importance of having emergency contacts readily available. That’s why we’ve made it easy for you to manage your emergency contacts by simply  pressing the contacts button in the menu. Also, for those who need to stay on top of their medication schedule, our app allows you to set reminders for them. Just navigate to the reminders section in the menu. '),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20.0), // Set button border radius
                  ),
                  primary: const Color(0xFF332D41),
                ),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => _openDrawer(context),
          ),
        ),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF332D41), // Background color for Drawer
          child: ListView(
            padding: EdgeInsets.zero, // Add this line to remove padding
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFF1D1A22),
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                color: const Color(0xFF332D41), // Background color for Settings
                child: ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _navigateToSettings(context); // Navigate to SettingsScreen
                  },
                ),
              ),
              Container(
                color: const Color(0xFF332D41), // Background color for Contacts
                child: ListTile(
                  leading: const Icon(
                    Icons.contacts,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Contacts',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _navigateToContacts(context); // Navigate to ContactScreen
                  },
                ),
              ),
              Container(
                color:
                    const Color(0xFF332D41), // Background color for Reminders
                child: ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Reminders',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    _navigateToReminders(
                        context); // Navigate to RemindersScreen
                  },
                ),
              ),
              Container(
                color: const Color(0xFF332D41), // Background color for Info
                child: ListTile(
                  leading: const Icon(
                    Icons.info,
                    color: Colors.white,
                  ),
                  title: const Text(
                    'Info',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    _showInfoDialog(
                        context); // Call the method to show the dialog
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        // Wrap the Column with a Center widget
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 50), // Add bottom padding
              child: Text(
                'PanicPal',
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            GestureDetector(
              onTapDown: (_) {
                _animationController.forward();
              },
              onTapUp: (_) {
                _animationController.reverse();
                _handleButtonPress();
              },
              onTapCancel: () {
                _animationController.reverse();
              },
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: child,
                  );
                },
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDE3730),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      'SOS',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
