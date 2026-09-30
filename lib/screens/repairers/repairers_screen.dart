import 'package:flutter/material.dart';
import 'package:sortit/models/category.dart';
import 'package:sortit/models/issue.dart';
import 'package:sortit/models/repairer.dart';
import 'package:sortit/theme/app_theme.dart';
import 'package:sortit/widgets/repairer_card.dart';
import 'package:sortit/widgets/sponsored_card.dart';
import 'package:sortit/widgets/admob_banner.dart';
import 'package:sortit/screens/repairer_details/repairer_details_screen.dart';
import 'package:sortit/services/location_service.dart';
import 'package:sortit/services/repairer_service.dart';

class RepairersScreen extends StatefulWidget {
  final Category category;
  final Issue issue;
  final LocationService? locationService;
  final RepairerService? repairerService;

  const RepairersScreen({
    super.key,
    required this.category,
    required this.issue,
    this.locationService,
    this.repairerService,
  });

  @override
  State<RepairersScreen> createState() => _RepairersScreenState();
}

class _RepairersScreenState extends State<RepairersScreen> {
  bool _isLoading = true;
  String _locationStatus = 'Detecting location...';
  List<NearbyRepairer> _repairers = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final locService = widget.locationService ?? const LocationService();
    final repService = widget.repairerService ?? RepairerService();

    try {
      final locResult = await locService.getCurrentLocation();
      if (!mounted) return;

      if (!locResult.isSuccess || locResult.latitude == null || locResult.longitude == null) {
        setState(() {
          _locationStatus = locResult.errorMessage ?? 'Location failed';
        });
      } else {
        setState(() {
          _locationStatus = 'Location obtained';
        });
      }

      final repairers = await repService.fetchRepairersByCategory(widget.category.name);
      if (!mounted) return;

      List<NearbyRepairer> sorted = [];
      if (locResult.isSuccess && locResult.latitude != null && locResult.longitude != null) {
        sorted = locService.getNearestRepairers(
          userLatitude: locResult.latitude!,
          userLongitude: locResult.longitude!,
          repairers: repairers,
        );
      } else {
        sorted = repairers.map((r) => NearbyRepairer(
          repairer: r, 
          distanceKm: 0.0, 
          formattedDistance: 'Unknown'
        )).toList();
      }

      setState(() {
        _repairers = sorted;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load repairers.';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppTheme.bgLightGrey,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.45,
            child: Image.asset(
              'assets/images/bg_gradient.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  foregroundColor: AppTheme.pureWhite,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text('Nearby Repairers'),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          decoration: BoxDecoration(
                            color: AppTheme.pureWhite,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryRed.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.location_on, color: AppTheme.primaryRed, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _locationStatus,
                                  style: const TextStyle(
                                    color: AppTheme.trueBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.pureWhite,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                    ),
                    child: _isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryRed))
                      : _errorMessage != null
                          ? Center(child: Text(_errorMessage!, style: const TextStyle(color: AppTheme.primaryRed)))
                          : _repairers.isEmpty
                              ? const Center(child: Text('No repairers found in this category.', style: TextStyle(color: AppTheme.greyText)))
                              : ListView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(24),
                                  children: [
                                    if (_repairers.isNotEmpty)
                                      SponsoredCard(
                                        repairer: _repairers[0].repairer,
                                        onTap: () => _navigateToDetails(context, _repairers[0].repairer),
                                      ),
                                    if (_repairers.isNotEmpty)
                                      const SizedBox(height: 8),
                                    ..._repairers.map((r) => RepairerCard(
                                      repairer: r.repairer,
                                      distance: r.distanceKm,
                                      onTap: () => _navigateToDetails(context, r.repairer),
                                    )),
                                  ],
                                ),
                  ),
                ),
                const AdMobBanner(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context, Repairer repairer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RepairerDetailsScreen(
          repairer: repairer,
          category: widget.category,
          issue: widget.issue,
        ),
      ),
    );
  }
}
