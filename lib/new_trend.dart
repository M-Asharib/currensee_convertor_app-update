import 'package:currensee_convertor_app/appbar.dart';
import 'package:currensee_convertor_app/custom_navigator_bar.dart';
import 'package:currensee_convertor_app/customdrawer.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsTrendsScreen extends StatefulWidget {
  @override
  _NewsTrendsScreenState createState() => _NewsTrendsScreenState();
}

class _NewsTrendsScreenState extends State<NewsTrendsScreen> {
  List articles = [];
  int _selectedIndex = 0; // Home tab will be active by default

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  fetchNews() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/everything?q=currency&apiKey=8bc98ca6a1774cf385fed50f6c9674a7'),
    );
    if (response.statusCode == 200) {
      setState(() {
        articles = json
            .decode(response.body)['articles']
            .where((article) =>
                article['urlToImage'] != null &&
                article['urlToImage'].isNotEmpty)
            .toList();
      });
    } else {
      throw Exception('Failed to load news');
    }
  }

  // Handle the bottom navigation bar item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false, // Removes the back button
      //   backgroundColor: Color(0xFFF7F7F7), // Updated AppBar color
      //   elevation: 0, // Removes shadow
      //   title: Row(
      //     children: [
      //       Image.asset(
      //         'assets/logo_sm.png',
      //         width: 50, // Set width of the logo
      //         height: 50, // Set height of the logo
      //       ),
      //       SizedBox(width: 8), // Space between logo and title text
      //       Text(
      //         'Currency News & Trends',
      //         style: TextStyle(
      //           color: Colors.black, // Title text color
      //           fontSize: 18,
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     IconButton(
      //       icon: Icon(Icons.notifications_none, color: Colors.black),
      //       onPressed: () {
      //         // Handle notification button press
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.menu, color: Colors.black),
      //       onPressed: () {
      //         // Handle menu button press
      //       },
      //     ),
      //   ],
      // ),

      backgroundColor: Color(0xFFF7F7F7), // Updated background color
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Market Trends', context),
            _buildMarketTrendsChart(),
            _buildSectionTitle('Latest News', context),
            articles.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: articles.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ArticleDetailScreen(
                                article: articles[index],
                              ),
                            ),
                          );
                        },
                        child: _buildNewsCard(
                          title: articles[index]['title'],
                          content: articles[index]['description'] ??
                              'No description available',
                          imageUrl: articles[index]['urlToImage'] ?? '',
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      //   backgroundColor: Color(0xFFF7F7F7),
      //   selectedItemColor:
      //       Colors.black, // Set selected icon/text color to black
      //   unselectedItemColor:
      //       Colors.grey, // Set unselected icon/text color to black
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.notifications),
      //       label: 'Notifications',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.account_circle),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black, // Updated text color
          fontSize: 22.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildNewsCard({
    required String title,
    required String content,
    required String imageUrl,
  }) {
    const String fallbackImageUrl =
        'https://c8.alamy.com/comp/2AYXPDG/traditional-newspaper-crier-outside-the-post-office-on-oliver-plunkett-street-in-cork-2AYXPDG.jpg';

    return Card(
      color: Color(0xFFF7F7F7), // Updated card color
      margin: EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Left side with 30% width for the image
            Flexible(
              flex: 3, // 30% of the width
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    8.0), // Optional: rounded corners for the image
                child: Image.network(
                  imageUrl.isNotEmpty ? imageUrl : fallbackImageUrl,
                  width: double.infinity,
                  height: 120.0, // Adjusted height for a balanced card look
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(
                      fallbackImageUrl,
                      width: double.infinity,
                      height: 120.0,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
            ),

            SizedBox(width: 16.0), // Spacer between image and text

            // Right side with 70% width for title and description
            Expanded(
              flex: 7, // 70% of the width
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Colors.black, // Updated text color
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarketTrendsChart() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 200.0,
        child: LineChart(
          LineChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.black38, // Updated line color
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.black38, // Updated line color
                  strokeWidth: 1,
                );
              },
            ),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.black, // Updated title color
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.black, // Updated title color
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.black54, // Updated border color
                width: 1,
              ),
            ),
            minX: 0,
            maxX: 11,
            minY: 0,
            maxY: 6,
            lineBarsData: [
              LineChartBarData(
                spots: [
                  FlSpot(0, 3),
                  FlSpot(2.6, 2),
                  FlSpot(4.9, 5),
                  FlSpot(6.8, 3.1),
                  FlSpot(8, 4),
                  FlSpot(9.5, 3),
                  FlSpot(11, 4),
                ],
                isCurved: true,
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final dynamic article;

  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String fallbackImageUrl =
        'https://c8.alamy.com/comp/2AYXPDG/traditional-newspaper-crier-outside-the-post-office-on-oliver-plunkett-street-in-cork-2AYXPDG.jpg';

    return Scaffold(
      appBar: AppBar(
        title: Text('Article Detail'),
        backgroundColor: Color(0xFFF7F7F7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article['urlToImage'] != null
                  ? article['urlToImage']
                  : fallbackImageUrl,
              width: double.infinity,
              height: 250.0,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.network(
                  fallbackImageUrl,
                  width: double.infinity,
                  height: 250.0,
                  fit: BoxFit.cover,
                );
              },
            ),
            SizedBox(height: 20.0),
            Text(
              article['title'] ?? 'No title',
              style: TextStyle(
                color: Colors.black, // Updated text color
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              article['content'] ?? 'No content available',
              style: TextStyle(
                color: Colors.black87, // Updated text color
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
