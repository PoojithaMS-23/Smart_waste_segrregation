import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/members_model.dart';
import 'db/database_helper.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  List<Member> topUsers = [];
  bool isLoading = false;
  String selectedPeriod = 'This Month';

  @override
  void initState() {
    super.initState();
    _loadLeaderboard();
  }

  Future<void> _loadLeaderboard() async {
    setState(() {
      isLoading = true;
    });
    
    final users = await DatabaseHelper.instance.getAllMembers();
    setState(() {
      topUsers = users.take(20).toList(); // Top 20 users
      isLoading = false;
    });
  }

  String _getRankIcon(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '${rank}';
    }
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return Colors.grey[200]!;
    }
  }

  double _calculateTaxReduction(int points) {
    // Tax reduction based on points
    if (points >= 500) return 0.20; // 20% reduction
    if (points >= 300) return 0.15; // 15% reduction
    if (points >= 200) return 0.10; // 10% reduction
    if (points >= 100) return 0.05; // 5% reduction
    return 0.0; // No reduction
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadLeaderboard,
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Card
          Card(
            margin: const EdgeInsets.all(16),
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.leaderboard,
                    size: 48,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Monthly Leaderboard',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Top performers get tax reductions!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Period Selector
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange),
                    ),
                    child: DropdownButton<String>(
                      value: selectedPeriod,
                      underline: const SizedBox(),
                      items: ['This Month', 'Last Month', 'This Year'].map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedPeriod = value!;
                        });
                        _loadLeaderboard();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tax Reduction Info
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.savings, color: Colors.green),
                    const SizedBox(width: 8),
                    const Text(
                      'Tax Reduction Benefits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTaxReductionItem('500+ Points', '20% Tax Reduction', Colors.amber),
                _buildTaxReductionItem('300+ Points', '15% Tax Reduction', Colors.orange),
                _buildTaxReductionItem('200+ Points', '10% Tax Reduction', Colors.blue),
                _buildTaxReductionItem('100+ Points', '5% Tax Reduction', Colors.green),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Leaderboard List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: topUsers.length,
                    itemBuilder: (context, index) {
                      final user = topUsers[index];
                      final rank = index + 1;
                      final taxReduction = _calculateTaxReduction(user.points);
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: _getRankColor(rank),
                            radius: 20,
                            child: Text(
                              _getRankIcon(rank),
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          title: Text(
                            user.ownerName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${user.doorNumber}, ${user.area}'),
                              if (taxReduction > 0)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${(taxReduction * 100).toInt()}% Tax Reduction',
                                    style: const TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${user.points}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'pts',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxReductionItem(String points, String reduction, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            points,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          Text(
            reduction,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
