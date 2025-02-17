// landing page for ramaanya foundation have Ramaanaya Education where they teach
// the children of the poor and needy.

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Knowledgewap'),
        centerTitle: true, // Center the title
      ),
      body: SingleChildScrollView( // Allow scrolling for content
        child: Column(
          children: <Widget>[
            Container(
              height: 250, // Height for the hero image
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/hero_image.jpg'), // Hero image
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Text(
                  'Empowering Education for All',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black,
                        offset: Offset(0.0, 0.0),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              height: 200, // Height for the hero slider
              child: PageView(
                children: <Widget>[
                  Image.asset('assets/images/slider_image1.jpg', fit: BoxFit.cover),
                  Image.asset('assets/images/slider_image2.jpg', fit: BoxFit.cover),
                  Image.asset('assets/images/slider_image3.jpg', fit: BoxFit.cover),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(onPressed: () {}, child: Text('Home')),
                TextButton(onPressed: () {}, child: Text('Courses')),
                TextButton(onPressed: () {}, child: Text('About Us')),
                TextButton(onPressed: () {}, child: Text('Contact')),
              ],
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Text('Join Us Today!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to registration page
                    },
                    child: Text('Get Started'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Testimonials', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('"This foundation changed my life!" - A happy student', style: TextStyle(fontStyle: FontStyle.italic)),
                  SizedBox(height: 5),
                  Text('"The support I received was invaluable." - A grateful parent', style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Support Us', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Your contributions help us provide better education and resources.'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to donation page
                    },
                    child: Text('Donate Now'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('What is Knowledgewap?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Knowledgewap is dedicated to providing quality education to underprivileged children.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('What We Provide', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('We offer a variety of courses, mentorship programs, and resources to help students succeed.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('How to Join', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Visit our registration page and fill out the form to become a part of our community.'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('FAQs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Q: How can I contact support? A: You can reach us via the contact page.'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar( // Updated Footer section
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '© 2023 Knowledgewap. All rights reserved.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
