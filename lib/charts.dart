import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MarketNewsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market News & Trends'),
        backgroundColor: Colors.deepPurple[900],
      ),
      backgroundColor: Colors.deepPurple[700],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Market Trends', context),
            _buildMarketTrendsChart(),
            _buildSectionTitle('Latest News', context),
            _buildNewsCard(
              title: 'USD Strengthens Against EUR',
              content:
                  'The US Dollar has gained strength against the Euro amid economic uncertainties in Europe.',
            ),
            _buildNewsCard(
              title: 'Inflation Concerns in the UK',
              content:
                  'The British Pound faces pressure as inflation concerns rise in the United Kingdom.',
            ),
            _buildSectionTitle('Market Analysis', context),
            _buildNewsCard(
              title: 'Expert Analysis: Future of USD',
              content:
                  'Experts predict that the USD might continue its upward trend for the next quarter.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

  Widget _buildNewsCard({required String title, required String content}) {
    return Card(
      color: Colors.deepPurple[500],
      margin: EdgeInsets.all(16.0),
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
                  color: Colors.white38,
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: Colors.white38,
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 30,
                  // margin: 8,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    );
                  },
                  reservedSize: 30,
                  // margin: 8,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: Colors.white54,
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
                // colors: [Colors.pinkAccent],
                barWidth: 5,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  // colors: [Colors.pinkAccent.withOpacity(0.3)],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
