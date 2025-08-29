import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/AppColors.dart';
import 'ShiftHistoryScreen.dart';

class ShiftDetailsScreen extends StatefulWidget {
  final ShiftRecord shiftRecord;
  final int shiftIndex;

  const ShiftDetailsScreen({
    Key? key,
    required this.shiftRecord,
    required this.shiftIndex,
  }) : super(key: key);

  @override
  State<ShiftDetailsScreen> createState() => _ShiftDetailsScreenState();
}

class _ShiftDetailsScreenState extends State<ShiftDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Sample detailed data for the shift
  late ShiftDetailData _shiftDetails;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeShiftDetails();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _cardAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardAnimationController, curve: Curves.elasticOut),
    );

    _animationController.forward();
    _cardAnimationController.forward();
  }

  void _initializeShiftDetails() {
    // Generate sample data based on the shift record
    _shiftDetails = ShiftDetailData(
      // Opening Data
      petrolTankOpening: 10000,
      dieselTankOpening: 8000,
      cashOnHandOpening: widget.shiftRecord.totalCash - 450.75,

      // Digital Readings Opening
      pump1Nozzle1aOpening: 10000,
      pump1Nozzle1bOpening: 8000,
      pump2Nozzle2aOpening: 10000,
      pump2Nozzle2bOpening: 8000,

      // Analogue Readings Opening
      analoguePump1Nozzle1aOpening: 149.5,
      analoguePump1Nozzle1bOpening: 119.8,
      analoguePump2Nozzle2aOpening: 149.5,
      analoguePump2Nozzle2bOpening: 119.8,

      // Closing Data
      petrolTankClosing: 9250,
      dieselTankClosing: 7450,
      cashOnHandClosing: widget.shiftRecord.totalCash,

      // Digital Readings Closing
      pump1Nozzle1aClosing: 10350,
      pump1Nozzle1bClosing: 8280,
      pump2Nozzle2aClosing: 10420,
      pump2Nozzle2bClosing: 8320,

      // Analogue Readings Closing
      analoguePump1Nozzle1aClosing: 172.8,
      analoguePump1Nozzle1bClosing: 139.4,
      analoguePump2Nozzle2aClosing: 175.2,
      analoguePump2Nozzle2bClosing: 141.6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background decoration
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topRight,
                radius: 1.5,
                colors: [
                  AppColors.secondary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                  AppColors.background,
                ],
              ),
            ),
          ),

          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            _buildShiftSummaryCard(),
                            SizedBox(height: 20.h),
                            _buildOpeningSection(),
                            SizedBox(height: 20.h),
                            _buildClosingSection(),
                            SizedBox(height: 20.h),
                            _buildComparisonSection(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.h,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.1),
                    offset: Offset(0, 4.h),
                    blurRadius: 12.r,
                  ),
                ],
              ),
              child: Icon(
                Icons.arrow_back,
                color: AppColors.primary,
                size: 20.sp,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shift Details',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  '#${(widget.shiftIndex + 1).toString().padLeft(3, '0')}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShiftSummaryCard() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              offset: Offset(0, 12.h),
              blurRadius: 30.r,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 56.w,
                  height: 56.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Center(
                    child: Text(
                      widget.shiftRecord.employeeName
                          .split(' ')
                          .map((name) => name[0])
                          .join('')
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.shiftRecord.employeeName,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.shiftRecord.date,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shift Duration',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '${widget.shiftRecord.startTime} - ${widget.shiftRecord.endTime}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Total Cash',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      '\$${widget.shiftRecord.totalCash.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOpeningSection() {
    return _buildDetailSection(
      title: 'Opening (Start of Shift)',
      color: AppColors.primary,
      children: [
        _buildSectionHeader('Tank Levels'),
        SizedBox(height: 12.h),
        _buildDetailRow('Petrol Tank', '${_shiftDetails.petrolTankOpening.toStringAsFixed(0)} L', Icons.local_gas_station),
        _buildDetailRow('Diesel Tank', '${_shiftDetails.dieselTankOpening.toStringAsFixed(0)} L', Icons.local_gas_station),

        SizedBox(height: 20.h),
        _buildSectionHeader('Cash On Hand'),
        SizedBox(height: 12.h),
        _buildDetailRow('Cash', '\$${_shiftDetails.cashOnHandOpening.toStringAsFixed(2)}', Icons.attach_money),

        SizedBox(height: 20.h),
        _buildSectionHeader('Digital Readings'),
        SizedBox(height: 12.h),
        _buildDetailRow('Pump 1 (Nozzle 1a)', '${_shiftDetails.pump1Nozzle1aOpening.toStringAsFixed(0)} L', Icons.speed),
        _buildDetailRow('Pump 1 (Nozzle 1b)', '${_shiftDetails.pump1Nozzle1bOpening.toStringAsFixed(0)} L', Icons.speed),
        _buildDetailRow('Pump 2 (Nozzle 2a)', '${_shiftDetails.pump2Nozzle2aOpening.toStringAsFixed(0)} L', Icons.speed),
        _buildDetailRow('Pump 2 (Nozzle 2b)', '${_shiftDetails.pump2Nozzle2bOpening.toStringAsFixed(0)} L', Icons.speed),

        SizedBox(height: 20.h),
        _buildSectionHeader('Analogue Readings'),
        SizedBox(height: 12.h),
        _buildDetailRow('Pump 1 (Nozzle 1a)', '${_shiftDetails.analoguePump1Nozzle1aOpening.toStringAsFixed(1)} V', Icons.analytics),
        _buildDetailRow('Pump 1 (Nozzle 1b)', '${_shiftDetails.analoguePump1Nozzle1bOpening.toStringAsFixed(1)} V', Icons.analytics),
        _buildDetailRow('Pump 2 (Nozzle 2a)', '${_shiftDetails.analoguePump2Nozzle2aOpening.toStringAsFixed(1)} V', Icons.analytics),
        _buildDetailRow('Pump 2 (Nozzle 2b)', '${_shiftDetails.analoguePump2Nozzle2bOpening.toStringAsFixed(1)} V', Icons.analytics),
      ],
    );
  }

  Widget _buildClosingSection() {
    return _buildDetailSection(
      title: 'Closing (End of Shift)',
      color: AppColors.secondary,
      children: [
        _buildSectionHeader('Tank Levels'),
        SizedBox(height: 12.h),
        _buildDetailRow('Petrol Tank', '${_shiftDetails.petrolTankClosing.toStringAsFixed(0)} L', Icons.local_gas_station),
        _buildDetailRow('Diesel Tank', '${_shiftDetails.dieselTankClosing.toStringAsFixed(0)} L', Icons.local_gas_station),

        SizedBox(height: 20.h),
        _buildSectionHeader('Cash On Hand'),
        SizedBox(height: 12.h),
        _buildDetailRow('Cash', '\$${_shiftDetails.cashOnHandClosing.toStringAsFixed(2)}', Icons.attach_money),

        SizedBox(height: 20.h),
        _buildSectionHeader('Digital Readings'),
        SizedBox(height: 12.h),
        _buildDetailRow('Pump 1 (Nozzle 1a)', '${_shiftDetails.pump1Nozzle1aClosing.toStringAsFixed(0)} L', Icons.speed),
        _buildDetailRow('Pump 1 (Nozzle 1b)', '${_shiftDetails.pump1Nozzle1bClosing.toStringAsFixed(0)} L', Icons.speed),
        _buildDetailRow('Pump 2 (Nozzle 2a)', '${_shiftDetails.pump2Nozzle2aClosing.toStringAsFixed(0)} L', Icons.speed),
        _buildDetailRow('Pump 2 (Nozzle 2b)', '${_shiftDetails.pump2Nozzle2bClosing.toStringAsFixed(0)} L', Icons.speed),

        SizedBox(height: 20.h),
        _buildSectionHeader('Analogue Readings'),
        SizedBox(height: 12.h),
        _buildDetailRow('Pump 1 (Nozzle 1a)', '${_shiftDetails.analoguePump1Nozzle1aClosing.toStringAsFixed(1)} V', Icons.analytics),
        _buildDetailRow('Pump 1 (Nozzle 1b)', '${_shiftDetails.analoguePump1Nozzle1bClosing.toStringAsFixed(1)} V', Icons.analytics),
        _buildDetailRow('Pump 2 (Nozzle 2a)', '${_shiftDetails.analoguePump2Nozzle2aClosing.toStringAsFixed(1)} V', Icons.analytics),
        _buildDetailRow('Pump 2 (Nozzle 2b)', '${_shiftDetails.analoguePump2Nozzle2bClosing.toStringAsFixed(1)} V', Icons.analytics),
      ],
    );
  }

  Widget _buildComparisonSection() {
    double petrolDiff = _shiftDetails.petrolTankClosing - _shiftDetails.petrolTankOpening;
    double dieselDiff = _shiftDetails.dieselTankClosing - _shiftDetails.dieselTankOpening;
    double cashDiff = _shiftDetails.cashOnHandClosing - _shiftDetails.cashOnHandOpening;

    return _buildDetailSection(
      title: 'Shift Summary & Changes',
      color: Colors.green,
      children: [
        _buildSectionHeader('Tank Changes'),
        SizedBox(height: 12.h),
        _buildComparisonRow('Petrol Consumed', '${petrolDiff.abs().toStringAsFixed(0)} L', petrolDiff < 0 ? Colors.red : Colors.green, Icons.trending_down),
        _buildComparisonRow('Diesel Consumed', '${dieselDiff.abs().toStringAsFixed(0)} L', dieselDiff < 0 ? Colors.red : Colors.green, Icons.trending_down),

        SizedBox(height: 20.h),
        _buildSectionHeader('Cash Changes'),
        SizedBox(height: 12.h),
        _buildComparisonRow('Cash Generated', '\$${cashDiff.abs().toStringAsFixed(2)}', cashDiff > 0 ? Colors.green : Colors.red, Icons.trending_up),

        SizedBox(height: 20.h),
        _buildSectionHeader('Pump Activity'),
        SizedBox(height: 12.h),
        _buildComparisonRow('Pump 1 Total', '${(_shiftDetails.pump1Nozzle1aClosing - _shiftDetails.pump1Nozzle1aOpening + _shiftDetails.pump1Nozzle1bClosing - _shiftDetails.pump1Nozzle1bOpening).toStringAsFixed(0)} L', Colors.blue, Icons.local_gas_station),
        _buildComparisonRow('Pump 2 Total', '${(_shiftDetails.pump2Nozzle2aClosing - _shiftDetails.pump2Nozzle2aOpening + _shiftDetails.pump2Nozzle2bClosing - _shiftDetails.pump2Nozzle2bOpening).toStringAsFixed(0)} L', Colors.blue, Icons.local_gas_station),
      ],
    );
  }

  Widget _buildDetailSection({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.95),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              offset: Offset(0, 12.h),
              blurRadius: 30.r,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            SizedBox(height: 24.h),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.textSecondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: AppColors.primary,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String label, String value, Color valueColor, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: valueColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: valueColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: valueColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              icon,
              size: 16.sp,
              color: valueColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }
}

// Data model for detailed shift information
class ShiftDetailData {
  // Opening values
  final double petrolTankOpening;
  final double dieselTankOpening;
  final double cashOnHandOpening;
  final double pump1Nozzle1aOpening;
  final double pump1Nozzle1bOpening;
  final double pump2Nozzle2aOpening;
  final double pump2Nozzle2bOpening;
  final double analoguePump1Nozzle1aOpening;
  final double analoguePump1Nozzle1bOpening;
  final double analoguePump2Nozzle2aOpening;
  final double analoguePump2Nozzle2bOpening;

  // Closing values
  final double petrolTankClosing;
  final double dieselTankClosing;
  final double cashOnHandClosing;
  final double pump1Nozzle1aClosing;
  final double pump1Nozzle1bClosing;
  final double pump2Nozzle2aClosing;
  final double pump2Nozzle2bClosing;
  final double analoguePump1Nozzle1aClosing;
  final double analoguePump1Nozzle1bClosing;
  final double analoguePump2Nozzle2aClosing;
  final double analoguePump2Nozzle2bClosing;

  ShiftDetailData({
    required this.petrolTankOpening,
    required this.dieselTankOpening,
    required this.cashOnHandOpening,
    required this.pump1Nozzle1aOpening,
    required this.pump1Nozzle1bOpening,
    required this.pump2Nozzle2aOpening,
    required this.pump2Nozzle2bOpening,
    required this.analoguePump1Nozzle1aOpening,
    required this.analoguePump1Nozzle1bOpening,
    required this.analoguePump2Nozzle2aOpening,
    required this.analoguePump2Nozzle2bOpening,
    required this.petrolTankClosing,
    required this.dieselTankClosing,
    required this.cashOnHandClosing,
    required this.pump1Nozzle1aClosing,
    required this.pump1Nozzle1bClosing,
    required this.pump2Nozzle2aClosing,
    required this.pump2Nozzle2bClosing,
    required this.analoguePump1Nozzle1aClosing,
    required this.analoguePump1Nozzle1bClosing,
    required this.analoguePump2Nozzle2aClosing,
    required this.analoguePump2Nozzle2bClosing,
  });
}