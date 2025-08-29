import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/AppColors.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({Key? key}) : super(key: key);

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Low Stock', 'Out of Stock', 'Normal'];

  final Map<String, dynamic> inventoryOverview = {
    'totalItems': 45,
    'lowStockItems': 8,
    'outOfStockItems': 2,
    'normalStockItems': 35,
    'totalValue': 2850000.0,
    'lastUpdated': 'Today 11:30 AM',
    'pendingDeliveries': 3,
    'nextDelivery': 'Tomorrow 2:00 PM',
  };

  final List<Map<String, dynamic>> fuelInventory = [
    {
      'id': 'F001',
      'name': 'Petrol (Octane 87)',
      'type': 'fuel',
      'currentStock': 12500.0,
      'capacity': 15000.0,
      'unit': 'L',
      'price': 105.50,
      'status': 'normal',
      'lastRefill': '3 days ago',
      'supplier': 'IOCL',
      'minThreshold': 2000.0,
      'consumption': 850.5, // per day
    },
    {
      'id': 'F002',
      'name': 'Diesel',
      'type': 'fuel',
      'currentStock': 1200.0,
      'capacity': 20000.0,
      'unit': 'L',
      'price': 98.75,
      'status': 'low',
      'lastRefill': '2 weeks ago',
      'supplier': 'BPCL',
      'minThreshold': 2500.0,
      'consumption': 1250.0,
    },
    {
      'id': 'F003',
      'name': 'Premium Petrol (Octane 91)',
      'type': 'fuel',
      'currentStock': 0.0,
      'capacity': 8000.0,
      'unit': 'L',
      'price': 112.30,
      'status': 'out',
      'lastRefill': '1 week ago',
      'supplier': 'HPCL',
      'minThreshold': 1000.0,
      'consumption': 425.0,
    },
    {
      'id': 'F004',
      'name': 'CNG',
      'type': 'fuel',
      'currentStock': 5600.0,
      'capacity': 8000.0,
      'unit': 'kg',
      'price': 85.40,
      'status': 'normal',
      'lastRefill': '5 days ago',
      'supplier': 'IGL',
      'minThreshold': 800.0,
      'consumption': 320.0,
    },
  ];

  final List<Map<String, dynamic>> otherInventory = [
    {
      'id': 'O001',
      'name': 'Engine Oil (5W-30)',
      'type': 'lubricant',
      'currentStock': 45.0,
      'capacity': 100.0,
      'unit': 'bottles',
      'price': 650.0,
      'status': 'normal',
      'supplier': 'Castrol',
      'minThreshold': 20.0,
    },
    {
      'id': 'O002',
      'name': 'Brake Fluid',
      'type': 'automotive',
      'currentStock': 8.0,
      'capacity': 50.0,
      'unit': 'bottles',
      'price': 250.0,
      'status': 'low',
      'supplier': 'Bosch',
      'minThreshold': 15.0,
    },
    {
      'id': 'O003',
      'name': 'Air Freshener',
      'type': 'accessory',
      'currentStock': 0.0,
      'capacity': 200.0,
      'unit': 'pieces',
      'price': 50.0,
      'status': 'out',
      'supplier': 'Local',
      'minThreshold': 25.0,
    },
    {
      'id': 'O004',
      'name': 'Windshield Cleaner',
      'type': 'automotive',
      'currentStock': 35.0,
      'capacity': 60.0,
      'unit': 'bottles',
      'price': 120.0,
      'status': 'normal',
      'supplier': 'Colin',
      'minThreshold': 10.0,
    },
  ];

  final List<Map<String, dynamic>> recentTransactions = [
    {
      'time': '10:15 AM',
      'type': 'delivery',
      'item': 'Petrol (Octane 87)',
      'quantity': '5000L',
      'action': 'Stock Added',
    },
    {
      'time': '09:30 AM',
      'type': 'sale',
      'item': 'Engine Oil (5W-30)',
      'quantity': '5 bottles',
      'action': 'Stock Reduced',
    },
    {
      'time': '08:45 AM',
      'type': 'adjustment',
      'item': 'Diesel',
      'quantity': '-50L',
      'action': 'Stock Adjusted',
    },
    {
      'time': 'Yesterday 6:30 PM',
      'type': 'delivery',
      'item': 'CNG',
      'quantity': '2000kg',
      'action': 'Stock Added',
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

  List<Map<String, dynamic>> get filteredInventory {
    List<Map<String, dynamic>> allItems = [...fuelInventory, ...otherInventory];

    if (selectedFilter == 'All') return allItems;
    if (selectedFilter == 'Low Stock') {
      return allItems.where((item) => item['status'] == 'low').toList();
    }
    if (selectedFilter == 'Out of Stock') {
      return allItems.where((item) => item['status'] == 'out').toList();
    }
    if (selectedFilter == 'Normal') {
      return allItems.where((item) => item['status'] == 'normal').toList();
    }
    return allItems;
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


                            SizedBox(height: 15.h),
                            _buildFuelInventorySection(),
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
                'Inventory Management',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Stock Levels & Management',
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
    );
  }





  Widget _buildFuelInventorySection() {
    List<Map<String, dynamic>> fuelItems = fuelInventory.where((item) {
      if (selectedFilter == 'All') return true;
      if (selectedFilter == 'Low Stock') return item['status'] == 'low';
      if (selectedFilter == 'Out of Stock') return item['status'] == 'out';
      if (selectedFilter == 'Normal') return item['status'] == 'normal';
      return false;
    }).toList();

    if (fuelItems.isEmpty) return SizedBox.shrink();

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
            children: [
              Icon(Icons.local_gas_station, size: 18.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                'Fuel Inventory',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...fuelItems.map((item) => _buildInventoryItem(item, true)).toList(),
        ],
      ),
    );
  }


  Widget _buildInventoryItem(Map<String, dynamic> item, bool isFuel) {
    Color statusColor = _getStatusColor(item['status']);
    double fillPercentage = item['currentStock'] / item['capacity'] * 100;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'ID: ${item['id']} • ${item['supplier']}',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  _getStatusText(item['status']),
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Stock Level Progress
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock Level',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: fillPercentage / 100,
                        backgroundColor: Colors.grey.withOpacity(0.2),
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                '${fillPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Stock Details
          Row(
            children: [
              Expanded(
                child: _buildStockDetail(
                  'Current',
                  '${item['currentStock']} ${item['unit']}',
                  statusColor,
                ),
              ),
              Expanded(
                child: _buildStockDetail(
                  'Capacity',
                  '${item['capacity']} ${item['unit']}',
                  Colors.grey,
                ),
              ),
              Expanded(
                child: _buildStockDetail(
                  'Price',
                  '₹${item['price']}',
                  Colors.green,
                ),
              ),
            ],
          ),

          if (isFuel) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: _buildStockDetail(
                    'Consumption',
                    '${item['consumption']} ${item['unit']}/day',
                    Colors.blue,
                  ),
                ),
                Expanded(
                  child: _buildStockDetail(
                    'Last Refill',
                    item['lastRefill'],
                    Colors.orange,
                  ),
                ),
                Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockDetail(String label, String value, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }



  Color _getStatusColor(String status) {
    switch (status) {
      case 'low':
        return Colors.orange;
      case 'out':
        return Colors.red;
      case 'normal':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'low':
        return 'Low Stock';
      case 'out':
        return 'Out of Stock';
      case 'normal':
        return 'Normal';
      default:
        return 'Unknown';
    }
  }

  Color _getTransactionColor(String type) {
    switch (type) {
      case 'delivery':
        return Colors.green;
      case 'sale':
        return Colors.blue;
      case 'adjustment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getTransactionIcon(String type) {
    switch (type) {
      case 'delivery':
        return Icons.local_shipping;
      case 'sale':
        return Icons.shopping_cart;
      case 'adjustment':
        return Icons.tune;
      default:
        return Icons.inventory;
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

  void _showAddInventoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Add Inventory Stock',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          content: Container(
            width: 300.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogOption(
                  'Fuel Delivery',
                  'Add fuel stock from supplier',
                  Icons.local_gas_station,
                  Colors.blue,
                      () {
                    Navigator.pop(context);
                    _showFuelDeliveryDialog();
                  },
                ),
                SizedBox(height: 12.h),
                _buildDialogOption(
                  'Other Items',
                  'Add lubricants, accessories, etc.',
                  Icons.category,
                  Colors.orange,
                      () {
                    Navigator.pop(context);
                    _showOtherItemsDialog();
                  },
                ),
                SizedBox(height: 12.h),
                _buildDialogOption(
                  'Stock Adjustment',
                  'Manual stock level correction',
                  Icons.tune,
                  Colors.purple,
                      () {
                    Navigator.pop(context);
                    _showStockAdjustmentDialog();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDialogOption(
      String title,
      String subtitle,
      IconData icon,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(icon, size: 20.sp, color: color),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14.sp,
              color: color,
            ),
          ],
        ),
      ),
    );
  }

  void _showFuelDeliveryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Fuel Delivery',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          content: Text(
            'Fuel delivery functionality would be implemented here with forms for selecting fuel type, quantity, supplier details, and delivery confirmation.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showOtherItemsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Add Other Items',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          content: Text(
            'Other items addition functionality would be implemented here with forms for item selection, quantity, supplier, and pricing details.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showStockAdjustmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          title: Text(
            'Stock Adjustment',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          content: Text(
            'Stock adjustment functionality would be implemented here for manual corrections to inventory levels with reason codes and approval workflows.',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Close',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }}