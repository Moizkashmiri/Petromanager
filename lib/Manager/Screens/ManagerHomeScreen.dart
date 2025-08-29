import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/AppColors.dart';
import 'ManagerProfileScreen.dart';

class ManagerHomeScreen extends StatefulWidget {
  const ManagerHomeScreen({Key? key}) : super(key: key);

  @override
  State<ManagerHomeScreen> createState() => _ManagerHomeScreenState();
}

class _ManagerHomeScreenState extends State<ManagerHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  final Map<String, dynamic> dashboardData = {
    'todaysSales': 245670.50,
    'weeklySales': 1456789.25,
    'monthlySales': 6234567.80,
    'totalFuelSold': 8940.75,
    'weeklyFuelSold': 62485.30,
    'monthlyFuelSold': 267890.45,
    'activeEmployees': 12,
    'totalCustomers': 156,
    'monthlyTarget': 8500000.0,
    'monthlyAchieved': 6234567.80,
    'weeklyTarget': 2000000.0,
    'weeklyAchieved': 1456789.25,
    'lowStockAlerts': 2,
    'pendingPayments': 4560.0,
    // Growth percentages
    'dailyGrowth': 12.5,
    'weeklyGrowth': 8.3,
    'monthlyGrowth': 15.7,
    // Average daily sales this week
    'avgDailySales': 208112.75,
    // Best performing day this week
    'bestDay': 'Tuesday',
    'bestDaySales': 287450.0,
    // Transaction counts
    'todayTransactions': 156,
    'weeklyTransactions': 1092,
    'monthlyTransactions': 4680,
  };

  final Map<String, String> managerData = {
    'name': 'Rajesh Kumar',
    'id': 'MGR001',
    'position': 'Station Manager',
    'phone': '+91 98765 43210',
    'experience': '8 Years',
    'lastLogin': 'Today 09:30 AM',
  };

  final List<Map<String, dynamic>> recentActivities = [
    {
      'time': '10:30 AM',
      'activity': 'Fuel delivery completed',
      'type': 'fuel',
      'amount': '5000L Petrol',
    },
    {
      'time': '09:45 AM',
      'activity': 'Employee check-in',
      'type': 'staff',
      'amount': 'Ram Singh',
    },
    {
      'time': '09:15 AM',
      'activity': 'Daily cash collection',
      'type': 'money',
      'amount': '₹45,000',
    },
    {
      'time': '08:30 AM',
      'activity': 'Pump maintenance',
      'type': 'maintenance',
      'amount': 'Pump #3',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
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
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _cardAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
    _cardAnimationController.forward();
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

          // Floating decorations
          Positioned(
            top: 60.h,
            right: -30.w,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary.withOpacity(0.05),
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
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            _buildManagerCard(),
                            SizedBox(height: 20.h),
                            _buildEnhancedSalesOverview(),
                            SizedBox(height: 20.h),
                            _buildManagementActions(),
                            SizedBox(height: 20.h),
                            _buildAlertsAndNotifications(),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manager Dashboard',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Station Overview & Controls',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: Colors.red,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 2.w),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagerProfileScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.person_2_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildManagerCard() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              offset: Offset(0, 8.h),
              blurRadius: 25.r,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18.r),
              ),
              child: Icon(
                Icons.admin_panel_settings,
                size: 35.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    managerData['name']!,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Text(
                          managerData['id']!,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        managerData['experience']!,
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Last Login: ${managerData['lastLogin']}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
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

  Widget _buildEnhancedSalesOverview() {
    double monthlyProgressPercentage =
        (dashboardData['monthlyAchieved'] / dashboardData['monthlyTarget']) *
        100;
    double weeklyProgressPercentage =
        (dashboardData['weeklyAchieved'] / dashboardData['weeklyTarget']) * 100;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            offset: Offset(0, 8.h),
            blurRadius: 25.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Monthly Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sales Overview',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: _getProgressColor(
                    monthlyProgressPercentage,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  'Monthly: ${monthlyProgressPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: _getProgressColor(monthlyProgressPercentage),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Sales Metrics Grid
          Row(
            children: [
              Expanded(
                child: _buildDetailedSalesMetric(
                  'Today\'s Sales',
                  '₹${_formatAmount(dashboardData['todaysSales'])}',
                  '${dashboardData['todayTransactions']} transactions',
                  '+${dashboardData['dailyGrowth']}%',
                  Icons.today,
                  Colors.green,
                  dashboardData['dailyGrowth'] > 0,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDetailedSalesMetric(
                  'Fuel Sold Today',
                  '${dashboardData['totalFuelSold']}L',
                  'Avg: ${(dashboardData['totalFuelSold'] / dashboardData['todayTransactions']).toStringAsFixed(1)}L/txn',
                  '',
                  Icons.local_gas_station,
                  Colors.orange,
                  null,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Weekly Sales Metrics
          Row(
            children: [
              Expanded(
                child: _buildDetailedSalesMetric(
                  'Weekly Sales',
                  '₹${_formatAmount(dashboardData['weeklySales'])}',
                  'Avg: ₹${_formatAmount(dashboardData['avgDailySales'])}/day',
                  '+${dashboardData['weeklyGrowth']}%',
                  Icons.calendar_view_week,
                  Colors.blue,
                  dashboardData['weeklyGrowth'] > 0,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDetailedSalesMetric(
                  'Weekly Fuel',
                  '${_formatAmount(dashboardData['weeklyFuelSold'])}L',
                  '${dashboardData['weeklyTransactions']} transactions',
                  'Best: ${dashboardData['bestDay']}',
                  Icons.analytics,
                  Colors.purple,
                  null,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Monthly Sales Metrics
          Row(
            children: [
              Expanded(
                child: _buildDetailedSalesMetric(
                  'Monthly Sales',
                  '₹${_formatAmount(dashboardData['monthlySales'])}',
                  '${dashboardData['monthlyTransactions']} transactions',
                  '+${dashboardData['monthlyGrowth']}%',
                  Icons.calendar_month,
                  Colors.indigo,
                  dashboardData['monthlyGrowth'] > 0,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDetailedSalesMetric(
                  'Monthly Fuel',
                  '${_formatAmount(dashboardData['monthlyFuelSold'])}L',
                  'Avg: ${(dashboardData['monthlyFuelSold'] / 30).toStringAsFixed(0)}L/day',
                  '',
                  Icons.oil_barrel,
                  Colors.teal,
                  null,
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Target Progress Sections
          _buildTargetProgress(
            'Weekly Target Progress',
            weeklyProgressPercentage,
            dashboardData['weeklyAchieved'],
            dashboardData['weeklyTarget'],
          ),

          SizedBox(height: 16.h),

          _buildTargetProgress(
            'Monthly Target Progress',
            monthlyProgressPercentage,
            dashboardData['monthlyAchieved'],
            dashboardData['monthlyTarget'],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedSalesMetric(
    String label,
    String value,
    String subtitle,
    String growth,
    IconData icon,
    Color color,
    bool? isPositiveGrowth,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16.sp, color: color),
              Spacer(),
              if (growth.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: (isPositiveGrowth ?? true)
                        ? Colors.green.withOpacity(0.1)
                        : Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Text(
                    growth,
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: (isPositiveGrowth ?? true)
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          if (subtitle.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary.withOpacity(0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTargetProgress(
    String title,
    double progressPercentage,
    double achieved,
    double target,
  ) {
    Color progressColor = _getProgressColor(progressPercentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${progressPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: progressColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: progressPercentage / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
            minHeight: 8.h,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achieved',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '₹${_formatAmount(achieved)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: progressColor,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Target',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '₹${_formatAmount(target)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Remaining',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '₹${_formatAmount(target - achieved)}',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Color _getProgressColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  Widget _buildManagementActions() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            offset: Offset(0, 8.h),
            blurRadius: 25.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Management Actions',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Staff Management',
                  Icons.groups,
                  AppColors.primary,
                  () {},
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  'Inventory Check',
                  Icons.inventory_2,
                  Colors.orange,
                  () {},
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  'Financial Reports',
                  Icons.assessment,
                  Colors.green,
                  () {},
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildActionButton(
                  'Pump Controls',
                  Icons.settings_applications,
                  Colors.red,
                  () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 20.sp, color: color),
                SizedBox(height: 6.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertsAndNotifications() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.red.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: Colors.red, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Alerts & Notifications',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildAlertItem(
            'Low Stock Alert',
            '${dashboardData['lowStockAlerts']} items running low',
            Icons.inventory_2,
            Colors.orange,
          ),
          SizedBox(height: 10.h),
          _buildAlertItem(
            'Pending Payments',
            '₹${_formatAmount(dashboardData['pendingPayments'])} due',
            Icons.payment,
            Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildAlertItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                description,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios, size: 12.sp, color: color),
      ],
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)}Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)}L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }
}
