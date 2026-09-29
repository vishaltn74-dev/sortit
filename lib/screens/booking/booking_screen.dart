import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/primary_button.dart';
import 'package:sortit/screens/confirmation/confirmation_screen.dart';

class BookingScreen extends StatefulWidget {
  final Repairer repairer;
  final Category category;
  final Issue issue;

  const BookingScreen({
    super.key,
    required this.repairer,
    required this.category,
    required this.issue,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDate = 0;
  int _selectedTime = 0;
  bool _isLoading = false;

  final dates = ['Today', 'Tomorrow', 'Wed', 'Thu'];
  final times = ['10 AM', '12 PM', '2 PM', '5 PM'];

  void _confirmBooking() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => ConfirmationScreen(
            repairer: widget.repairer,
            date: dates[_selectedDate],
            time: times[_selectedTime],
          ),
          transitionsBuilder: (c, a1, a2, child) {
            return FadeTransition(opacity: a1, child: child);
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      appBar: AppBar(
        title: const Text('Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(),
              const SizedBox(height: 32),
              const Text(
                'Preferred Date',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(dates.length, (index) {
                    return _buildChoiceChip(
                      text: dates[index],
                      isSelected: _selectedDate == index,
                      onTap: () => setState(() => _selectedDate = index),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Preferred Time',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                child: Row(
                  children: List.generate(times.length, (index) {
                    return _buildChoiceChip(
                      text: times[index],
                      isSelected: _selectedTime == index,
                      onTap: () => setState(() => _selectedTime = index),
                    );
                  }),
                ),
              ),
              const Spacer(),
              _isLoading 
                ? const Center(child: CircularProgressIndicator(color: AppTheme.royalBlue))
                : PrimaryButton(
                    text: 'Confirm Booking',
                    onPressed: _confirmBooking,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.trueBlack,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.repairer.name,
            style: const TextStyle(
              color: AppTheme.pureWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '\${widget.category.name} - \${widget.issue.name}',
            style: TextStyle(color: AppTheme.pureWhite.withOpacity(0.7)),
          ),
          const Divider(color: Colors.white24, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Inspection Fee', style: TextStyle(color: AppTheme.pureWhite)),
              Text(
                '₹\${widget.repairer.inspectionFee}',
                style: const TextStyle(
                  color: AppTheme.accentYellow,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceChip({required String text, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.trueBlack : AppTheme.pureWhite,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppTheme.trueBlack : AppTheme.lightGrey,
            width: 2,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppTheme.pureWhite : AppTheme.trueBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
