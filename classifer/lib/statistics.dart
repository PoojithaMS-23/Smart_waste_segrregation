import 'package:flutter/material.dart';
import '../db/Waste_stats.dart'; // Your DB helper

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  List<Map<String, dynamic>> areaStats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final data = await WasteStatsDatabase.instance.getAllAreaStats();
    setState(() {
      areaStats = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Waste Segregation Stats')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : areaStats.isEmpty
              ? const Center(child: Text('No data available'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: areaStats.length,
                  itemBuilder: (context, index) {
                    final stat = areaStats[index];
                    final correct = stat['correct_points'] ?? 0;
                    final incorrect = stat['incorrect_points'] ?? 0;
                    final total = correct + incorrect;
                    final correctPercent = total == 0 ? 0.0 : correct / total;
                    final incorrectPercent = total == 0 ? 0.0 : incorrect / total;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${stat['district']} - ${stat['area']}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Progress Bar
                            Stack(
                              children: [
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                Row(
                                  children: [
                                    // Correct bar
                                    Expanded(
                                      flex: (correctPercent * 1000).toInt(),
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Incorrect bar
                                    Expanded(
                                      flex: (incorrectPercent * 1000).toInt(),
                                      child: Container(
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Labels
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Correct: $correct'),
                                Text('Incorrect: $incorrect'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
