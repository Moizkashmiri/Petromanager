import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/AppColors.dart';

class FinancialReportsScreen extends StatefulWidget {
  const FinancialReportsScreen({Key? key}) : super(key: key);

  @override
  State<FinancialReportsScreen> createState() => _FinancialReportsScreenState();
}

class _FinancialReportsScreenState extends State<FinancialReportsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  String selectedPeriod = 'Monthly';
  String selectedReportType = 'Revenue';

  final List<String> periods = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final List<String> reportTypes = ['Revenue', 'Expenses', 'Profit', 'Tax'];

  final Map<String, dynamic> financialData = {
    // Revenue Data
    'totalRevenue': 6234567.80,
    'fuelRevenue': 5487234.50,
    'serviceRevenue': 324567.30,
    'otherRevenue': 422766.00,
    'revenueGrowth': 15.7,

    // Expense Data
    'totalExpenses': 4156789.20,
    'fuelPurchase': 3245678.90,
    'staffSalaries': 456789.12,
    'maintenance': 123456.78,
    'utilities': 87654.32,
    'insurance': 45678.90,
    'rent': 125000.00,
    'otherExpenses': 72531.18,

    // Profit Data
    'grossProfit': 2077778.60,
    'netProfit': 1845321.48,
    'profitMargin': 29.6,
    'operatingProfit': 1923456.78,

    // Tax Data
    'totalTax': 232457.12,
    'gst': 156789.45,
    'incomeTax': 75667.67,

    // Previous Period Comparison
    'previousRevenue': 5389234.45,
    'previousExpenses': 3789456.23,
    'previousProfit': 1599778.22,

    // Daily Breakdown (Last 7 days)
    'dailyRevenue': [
      245670.50,
      267890.25,
      234567.80,
      289456.75,
      256789.30,
      298765.45,
      278934.60,
    ],
    'dailyExpenses': [
      167890.25,
      178456.78,
      156789.45,
      189234.56,
      165432.12,
      192345.67,
      178965.43,
    ],
    'dailyProfit': [
      77780.25,
      89433.47,
      77778.35,
      100222.19,
      91357.18,
      106419.78,
      99969.17,
    ],

    // Monthly Breakdown (Last 6 months)
    'monthlyRevenue': [
      4567890.12,
      4789234.56,
      5123456.78,
      5456789.23,
      5789123.45,
      6234567.80,
    ],
    'monthlyExpenses': [
      3123456.78,
      3234567.89,
      3456789.12,
      3678901.23,
      3890123.45,
      4156789.20,
    ],
    'monthlyProfit': [
      1444433.34,
      1554666.67,
      1666667.66,
      1777887.00,
      1899000.00,
      2077778.60,
    ],

    // Fuel Type Revenue Breakdown
    'petrolRevenue': 3245678.90,
    'dieselRevenue': 2145789.60,
    'cngRevenue': 95766.00,

    // Payment Method Breakdown
    'cashPayments': 2456789.12,
    'cardPayments': 2789012.34,
    'digitalPayments': 988766.34,

    // Top Expenses Categories
    'expenseCategories': [
      {'name': 'Fuel Purchase', 'amount': 3245678.90, 'percentage': 78.1},
      {'name': 'Staff Salaries', 'amount': 456789.12, 'percentage': 11.0},
      {'name': 'Rent', 'amount': 125000.00, 'percentage': 3.0},
      {'name': 'Maintenance', 'amount': 123456.78, 'percentage': 3.0},
      {'name': 'Utilities', 'amount': 87654.32, 'percentage': 2.1},
      {'name': 'Others', 'amount': 118210.08, 'percentage': 2.8},
    ],
  };

  final List<Map<String, dynamic>> transactions = [
    {
      'id': 'TXN001',
      'type': 'Sale',
      'amount': 2345.67,
      'paymentMethod': 'Card',
      'time': '14:30',
      'date': 'Today',
      'fuelType': 'Petrol',
      'quantity': '45.5L',
    },
    {
      'id': 'TXN002',
      'type': 'Sale',
      'amount': 1876.45,
      'paymentMethod': 'Digital',
      'time': '13:45',
      'date': 'Today',
      'fuelType': 'Diesel',
      'quantity': '32.8L',
    },
    {
      'id': 'TXN003',
      'type': 'Expense',
      'amount': 45000.00,
      'paymentMethod': 'Bank Transfer',
      'time': '11:20',
      'date': 'Today',
      'category': 'Staff Salary',
      'description': 'Monthly Salary - Ram Singh',
    },
    {
      'id': 'TXN004',
      'type': 'Sale',
      'amount': 3456.78,
      'paymentMethod': 'Cash',
      'time': '10:15',
      'date': 'Today',
      'fuelType': 'Petrol',
      'quantity': '67.2L',
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
                    _buildFilterSection(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 15.w),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            _buildFinancialOverview(),
                            SizedBox(height: 20.h),
                            _buildRevenueBreakdown(),
                            SizedBox(height: 20.h),
                            _buildExpenseAnalysis(),
                            SizedBox(height: 20.h),
                            _buildProfitAnalysis(),
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
      padding: EdgeInsets.all(12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Financial Reports',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Revenue, Expenses & Profit Analysis',
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.download, color: Colors.green, size: 20.sp),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.print, color: Colors.blue, size: 20.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedPeriod,
                  icon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedPeriod = newValue!;
                    });
                  },
                  items: periods.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedReportType,
                  icon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedReportType = newValue!;
                    });
                  },
                  items: reportTypes.map<DropdownMenuItem<String>>((
                    String value,
                  ) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialOverview() {
    return Container(
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
                'Financial Overview',
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
                  '+${financialData['revenueGrowth']}% Growth',
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
                child: _buildOverviewCard(
                  'Total Revenue',
                  '₹${_formatAmount(financialData['totalRevenue'])}',
                  '+${financialData['revenueGrowth']}%',
                  Icons.trending_up,
                  Colors.green,
                  true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOverviewCard(
                  'Total Expenses',
                  '₹${_formatAmount(financialData['totalExpenses'])}',
                  '+12.3%',
                  Icons.trending_down,
                  Colors.orange,
                  false,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildOverviewCard(
                  'Net Profit',
                  '₹${_formatAmount(financialData['netProfit'])}',
                  '+${financialData['profitMargin']}%',
                  Icons.account_balance_wallet,
                  Colors.blue,
                  true,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildOverviewCard(
                  'Profit Margin',
                  '${financialData['profitMargin']}%',
                  '+2.1%',
                  Icons.pie_chart,
                  Colors.purple,
                  true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard(
    String title,
    String amount,
    String change,
    IconData icon,
    Color color,
    bool isPositive,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 18.sp, color: color),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                    color: isPositive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueBreakdown() {
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
          Text(
            'Revenue Breakdown',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildRevenueItem(
            'Fuel Sales',
            financialData['fuelRevenue'],
            financialData['totalRevenue'],
            Colors.blue,
            Icons.local_gas_station,
          ),
          SizedBox(height: 12.h),
          _buildRevenueItem(
            'Service Revenue',
            financialData['serviceRevenue'],
            financialData['totalRevenue'],
            Colors.green,
            Icons.build,
          ),
          SizedBox(height: 12.h),
          _buildRevenueItem(
            'Other Revenue',
            financialData['otherRevenue'],
            financialData['totalRevenue'],
            Colors.orange,
            Icons.more_horiz,
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueItem(
    String title,
    double amount,
    double total,
    Color color,
    IconData icon,
  ) {
    double percentage = (amount / total) * 100;

    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                '₹${_formatAmount(amount)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 6.h),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodCard(
    String method,
    double amount,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18.sp, color: color),
          SizedBox(height: 6.h),
          Text(
            method,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            '₹${_formatAmount(amount)}',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseAnalysis() {
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
          Text(
            'Expense Analysis',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          ...financialData['expenseCategories'].map<Widget>((expense) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildExpenseItem(
                expense['name'],
                expense['amount'],
                expense['percentage'],
                _getExpenseColor(expense['name']),
                _getExpenseIcon(expense['name']),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(
    String title,
    double amount,
    double percentage,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, size: 16.sp, color: color),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
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
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(1)}%',
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                '₹${_formatAmount(amount)}',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              SizedBox(height: 6.h),
              LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 4.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfitAnalysis() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.green.withOpacity(0.1),
            Colors.blue.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.green.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                'Profit Analysis',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildProfitCard(
                  'Gross Profit',
                  financialData['grossProfit'],
                  '+18.5%',
                  Colors.green,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildProfitCard(
                  'OPT. Profit',
                  financialData['operatingProfit'],
                  '+16.2%',
                  Colors.blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Net Profit Breakdown',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Revenue',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${_formatAmount(financialData['totalRevenue'])}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- Total Expenses',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${_formatAmount(financialData['totalExpenses'])}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '- Tax',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '₹${_formatAmount(financialData['totalTax'])}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                Divider(height: 16.h, color: Colors.grey.withOpacity(0.3)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Net Profit',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '₹${_formatAmount(financialData['netProfit'])}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfitCard(
    String title,
    double amount,
    String growth,
    Color color,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  growth,
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            '₹${_formatAmount(amount)}',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactions() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...transactions.map((transaction) {
            return Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildTransactionItem(transaction),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(Map<String, dynamic> transaction) {
    Color typeColor = transaction['type'] == 'Sale' ? Colors.green : Colors.red;
    IconData typeIcon = transaction['type'] == 'Sale'
        ? Icons.arrow_upward
        : Icons.arrow_downward;

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: typeColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: typeColor.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(typeIcon, size: 16.sp, color: typeColor),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      transaction['id'],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '₹${_formatAmount(transaction['amount'])}',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: typeColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                if (transaction.containsKey('fuelType')) ...[
                  Text(
                    '${transaction['fuelType']} - ${transaction['quantity']}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ] else if (transaction.containsKey('category')) ...[
                  Text(
                    '${transaction['category']} - ${transaction['description']}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: _getPaymentMethodColor(
                          transaction['paymentMethod'],
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        transaction['paymentMethod'],
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          color: _getPaymentMethodColor(
                            transaction['paymentMethod'],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      '${transaction['date']} ${transaction['time']}',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getExpenseColor(String expenseName) {
    switch (expenseName) {
      case 'Fuel Purchase':
        return Colors.blue;
      case 'Staff Salaries':
        return Colors.green;
      case 'Rent':
        return Colors.purple;
      case 'Maintenance':
        return Colors.orange;
      case 'Utilities':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getExpenseIcon(String expenseName) {
    switch (expenseName) {
      case 'Fuel Purchase':
        return Icons.local_gas_station;
      case 'Staff Salaries':
        return Icons.people;
      case 'Rent':
        return Icons.home;
      case 'Maintenance':
        return Icons.build;
      case 'Utilities':
        return Icons.power;
      default:
        return Icons.more_horiz;
    }
  }

  Color _getPaymentMethodColor(String method) {
    switch (method) {
      case 'Cash':
        return Colors.green;
      case 'Card':
        return Colors.blue;
      case 'Digital':
        return Colors.purple;
      case 'Bank Transfer':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
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
