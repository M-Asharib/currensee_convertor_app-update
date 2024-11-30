import 'package:flutter/material.dart';

class HelpAndSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Help & Support'),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.deepPurple[700],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Frequently Asked Questions (FAQs)', context),
              _buildFAQItem(
                question: 'How do I convert currencies?',
                answer: 'To convert currencies, enter the amount and select the desired currencies from the dropdown menus.',
              ),
              _buildFAQItem(
                question: 'How do I view market trends?',
                answer: 'Market trends can be viewed in the Market Trends section, which provides charts and analysis.',
              ),
              _buildFAQItem(
                question: 'Can I get notifications for currency changes?',
                answer: 'Yes, you can enable notifications from the settings to get alerts for currency fluctuations.',
              ),
              _buildSectionTitle('User Guides', context),
              _buildGuideCard(
                title: 'Getting Started with the App',
                content: 'A step-by-step guide to help you navigate through the app features and functionalities.',
              ),
              _buildGuideCard(
                title: 'Understanding Currency Conversion',
                content: 'This guide explains how currency conversion works and how to use the conversion tool effectively.',
              ),
              _buildSectionTitle('Contact Support', context),
              _buildSupportSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildFAQItem({required String question, required String answer}) {
    return Card(
      color: Colors.deepPurple[500],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              answer,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuideCard({required String title, required String content}) {
    return Card(
      color: Colors.deepPurple[500],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              content,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
    return Card(
      color: Colors.deepPurple[500],
      margin: EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need further assistance?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              'You can reach out to our customer support team at any time.',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.phone, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  '+1 800 123 4567',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Icon(Icons.email, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'support@example.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
