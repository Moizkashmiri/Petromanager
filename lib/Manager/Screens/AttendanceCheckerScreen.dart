import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/AppColors.dart';

class AttendanceCheckerScreen extends StatefulWidget {
  const AttendanceCheckerScreen({Key? key}) : super(key: key);

  @override
  State<AttendanceCheckerScreen> createState() =>
      _AttendanceCheckerScreenState();
}

class _AttendanceCheckerScreenState extends State<AttendanceCheckerScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  String selectedDate = 'Today';
  String selectedFilter = 'All';

  final Map<String, dynamic> attendanceOverview = {
    'totalEmployees': 12,
    'presentToday': 10,
    'absentToday': 2,
    'lateArrivals': 1,
    'earlyDepartures': 0,
    'onLeave': 1,
    'averageAttendance': 91.7,
    'monthlyPresent': 87.5,
    'weeklyPresent': 95.2,
  };

  final List<Map<String, dynamic>> employeeAttendance = [
    {
      'id': 'EMP001',
      'name': 'Ram Singh',
      'position': 'Pump Operator',
      'status': 'Present',
      'checkInTime': '08:30 AM',
      'checkOutTime': '',
      'hoursWorked': '2.5',
      'shift': 'Morning',
      'profileColor': Colors.blue,
      'isLate': false,
    },
    {
      'id': 'EMP002',
      'name': 'Shyam Kumar',
      'position': 'Cashier',
      'status': 'Present',
      'checkInTime': '08:45 AM',
      'checkOutTime': '',
      'hoursWorked': '2.25',
      'shift': 'Morning',
      'profileColor': Colors.green,
      'isLate': true,
    },
    {
      'id': 'EMP003',
      'name': 'Priya Sharma',
      'position': 'Supervisor',
      'status': 'Present',
      'checkInTime': '08:15 AM',
      'checkOutTime': '',
      'hoursWorked': '2.75',
      'shift': 'Morning',
      'profileColor': Colors.purple,
      'isLate': false,
    },
    {
      'id': 'EMP004',
      'name': 'Amit Verma',
      'position': 'Mechanic',
      'status': 'Absent',
      'checkInTime': '',
      'checkOutTime': '',
      'hoursWorked': '0',
      'shift': 'Morning',
      'profileColor': Colors.orange,
      'isLate': false,
    },
    {
      'id': 'EMP005',
      'name': 'Sunita Devi',
      'position': 'Cleaner',
      'status': 'On Leave',
      'checkInTime': '',
      'checkOutTime': '',
      'hoursWorked': '0',
      'shift': 'Morning',
      'profileColor': Colors.teal,
      'isLate': false,
    },
    {
      'id': 'EMP006',
      'name': 'Ravi Prakash',
      'position': 'Security Guard',
      'status': 'Present',
      'checkInTime': '06:00 AM',
      'checkOutTime': '',
      'hoursWorked': '5.0',
      'shift': 'Night',
      'profileColor': Colors.indigo,
      'isLate': false,
    },
  ];

  final List<Map<String, dynamic>> recentCheckIns = [
    {
      'name': 'Ram Singh',
      'time': '08:30 AM',
      'status': 'Check In',
      'isLate': false,
    },
    {
      'name': 'Shyam Kumar',
      'time': '08:45 AM',
      'status': 'Check In',
      'isLate': true,
    },
    {
      'name': 'Priya Sharma',
      'time': '08:15 AM',
      'status': 'Check In',
      'isLate': false,
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
                            _buildAttendanceOverview(),
                            SizedBox(height: 20.h),
                            _buildEmployeeAttendanceList(),
                            SizedBox(height: 20.h),
                            _buildRecentActivity(),
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
          Row(
            children: [
              SizedBox(width: 16.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Attendance Checker',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Employee Attendance Management',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceOverview() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Attendance Overview',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    '${attendanceOverview['averageAttendance']}% Avg',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: _buildAttendanceMetric(
                    'Present Today',
                    '${attendanceOverview['presentToday']}/${attendanceOverview['totalEmployees']}',
                    'Active employees',
                    Icons.check_circle,
                    Colors.green,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildAttendanceMetric(
                    'Absent Today',
                    '${attendanceOverview['absentToday']}',
                    'Missing employees',
                    Icons.cancel,
                    Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: _buildAttendanceMetric(
                    'Late Arrivals',
                    '${attendanceOverview['lateArrivals']}',
                    'Delayed check-ins',
                    Icons.access_time,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildAttendanceMetric(
                    'On Leave',
                    '${attendanceOverview['onLeave']}',
                    'Approved leaves',
                    Icons.event_busy,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            _buildAttendanceProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceMetric(
    String label,
    String value,
    String subtitle,
    IconData icon,
    Color color,
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
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceProgress() {
    double presentPercentage =
        (attendanceOverview['presentToday'] /
            attendanceOverview['totalEmployees']) *
        100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Today\'s Attendance Rate',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${presentPercentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: _getAttendanceColor(presentPercentage),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.r),
          child: LinearProgressIndicator(
            value: presentPercentage / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(
              _getAttendanceColor(presentPercentage),
            ),
            minHeight: 8.h,
          ),
        ),
      ],
    );
  }

  Color _getAttendanceColor(double percentage) {
    if (percentage >= 90) return Colors.green;
    if (percentage >= 75) return Colors.blue;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildEmployeeAttendanceList() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Employee Attendance',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  '${employeeAttendance.length} Employees',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...employeeAttendance
              .map((employee) => _buildEmployeeAttendanceCard(employee))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildEmployeeAttendanceCard(Map<String, dynamic> employee) {
    Color statusColor = _getStatusColor(employee['status']);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 45.w,
            height: 45.w,
            decoration: BoxDecoration(
              color: employee['profileColor'],
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Center(
              child: Text(
                employee['name'].split(' ').map((n) => n[0]).join(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      employee['name'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (employee['isLate'] &&
                        employee['status'] == 'Present') ...[
                      SizedBox(width: 6.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Text(
                          'LATE',
                          style: TextStyle(
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.orange,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  '${employee['id']} • ${employee['position']}',
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 4.h),
                if (employee['checkInTime'].isNotEmpty)
                  Text(
                    'In: ${employee['checkInTime']} • ${employee['hoursWorked']}h worked',
                    style: TextStyle(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Text(
              employee['status'],
              style: TextStyle(
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Present':
        return Colors.green;
      case 'Absent':
        return Colors.red;
      case 'On Leave':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  Widget _buildRecentActivity() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.blue.withOpacity(0.1),
            Colors.green.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.blue, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Recent Check-ins',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...recentCheckIns
              .map((activity) => _buildRecentActivityItem(activity))
              .toList(),
        ],
      ),
    );
  }

  Widget _buildRecentActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(
              color: activity['isLate'] ? Colors.orange : Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['name'],
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${activity['status']} at ${activity['time']}${activity['isLate'] ? ' (Late)' : ''}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                    color: activity['isLate'] ? Colors.orange : Colors.green,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: TextStyle(
              fontSize: 9.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
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
