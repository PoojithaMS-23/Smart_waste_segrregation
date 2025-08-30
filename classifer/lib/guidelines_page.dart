import 'package:flutter/material.dart';

class GuidelinesPage extends StatelessWidget {
  const GuidelinesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Segregation Guidelines'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Card(
              color: Colors.blue,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.eco,
                      size: 48,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Smart Waste Segregation',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Follow these guidelines for proper waste management',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Biodegradable Waste
            _buildWasteCategory(
              'Biodegradable Waste',
              Icons.eco,
              Colors.green,
              [
                'Food waste (vegetables, fruits, cooked food)',
                'Tea leaves and coffee grounds',
                'Eggshells and nutshells',
                'Garden waste (leaves, grass, flowers)',
                'Paper towels and tissues',
                'Wooden items (untreated)',
              ],
              [
                'Do not mix with plastic or metal',
                'Do not include meat or dairy products',
                'Do not add chemicals or cleaning agents',
                'Do not include treated wood or painted items',
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Recyclable Waste
            _buildWasteCategory(
              'Recyclable Waste',
              Icons.recycling,
              Colors.blue,
              [
                'Plastic bottles and containers',
                'Glass bottles and jars',
                'Aluminum cans and foil',
                'Cardboard and paper',
                'Metal containers',
                'Tetrapak cartons',
              ],
              [
                'Do not include dirty or contaminated items',
                'Do not mix with food waste',
                'Do not include broken glass',
                'Do not add plastic bags or wrappers',
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Hazardous Waste
            _buildWasteCategory(
              'Hazardous Waste',
              Icons.warning,
              Colors.red,
              [
                'Batteries (all types)',
                'Electronic waste (phones, chargers)',
                'Medicines and medical waste',
                'Paints and chemicals',
                'Light bulbs and CFLs',
                'Motor oil and lubricants',
              ],
              [
                'Do not dispose in regular bins',
                'Do not mix with other waste types',
                'Do not break or crush items',
                'Do not pour liquids down drains',
              ],
            ),
            
            const SizedBox(height: 20),
            
            // General Tips
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.tips_and_updates, color: Colors.orange, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'General Tips',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTipItem(
                      'Clean recyclables before disposal',
                      Icons.cleaning_services,
                    ),
                    _buildTipItem(
                      'Use separate bins for different waste types',
                      Icons.category,
                    ),
                    _buildTipItem(
                      'Reduce waste by reusing items when possible',
                      Icons.repeat,
                    ),
                    _buildTipItem(
                      'Compost biodegradable waste at home',
                      Icons.compost,
                    ),
                    _buildTipItem(
                      'Educate family members about proper segregation',
                      Icons.school,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Benefits
            Card(
              elevation: 4,
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.green, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'Benefits of Proper Segregation',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildBenefitItem(
                      'Reduces landfill waste',
                      'Proper segregation helps reduce the amount of waste sent to landfills.',
                    ),
                    _buildBenefitItem(
                      'Conserves natural resources',
                      'Recycling helps conserve energy and natural resources.',
                    ),
                    _buildBenefitItem(
                      'Prevents pollution',
                      'Proper disposal of hazardous waste prevents environmental pollution.',
                    ),
                    _buildBenefitItem(
                      'Earns you points and tax benefits',
                      'Good segregation practices earn you points and potential tax reductions.',
                    ),
                    _buildBenefitItem(
                      'Creates a cleaner environment',
                      'Collective effort leads to a cleaner and healthier community.',
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Contact Information
            Card(
              elevation: 4,
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.contact_support, color: Colors.blue, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          'Need Help?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'If you have questions about waste segregation or need assistance:',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    _buildContactItem(
                      'Contact your local municipality',
                      Icons.location_city,
                    ),
                    _buildContactItem(
                      'Use the complaints section in the app',
                      Icons.report,
                    ),
                    _buildContactItem(
                      'Check with waste collection workers',
                      Icons.work,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildWasteCategory(
    String title,
    IconData icon,
    Color color,
    List<String> dos,
    List<String> donts,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Do's
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      const Text(
                        'DO\'S',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...dos.map((item) => Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Colors.green)),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Don'ts
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red),
                      const SizedBox(width: 8),
                      const Text(
                        'DON\'TS',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...donts.map((item) => Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(color: Colors.red)),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.orange, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildBenefitItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String text, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
