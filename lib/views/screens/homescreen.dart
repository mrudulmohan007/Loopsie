import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import the Get package
import 'package:loopsie/constants.dart';
import 'package:loopsie/views/screens/add_video_screen.dart';
import 'package:loopsie/views/screens/video_screen.dart';
import 'package:loopsie/views/widgets/custom_icon.dart';

class HomeScreen extends StatelessWidget {
  final RxInt pageIdx =
      0.obs; // Create an observable variable for the selected page

  // Define a list of pages to display for each tab
  final pages = [
    VideoScreen(),
    Text('Search Screen'),
    AddVideoScreen(),
    Text('Messages Screen'),
    Text('Profile Screen'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          // Use Obx to observe changes in pageIdx
          onTap: (idx) {
            pageIdx.value = idx; // Update the selected page
          },
          backgroundColor: backgroundColor,
          selectedItemColor: const Color.fromARGB(255, 233, 2, 79),
          unselectedItemColor: Colors.white,
          currentIndex: pageIdx.value, // Access the value of pageIdx
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(icon: CustomIcon(), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
      body: Obx(
        () => pages[pageIdx.value], // Display the selected page
      ),
    );
  }
}
