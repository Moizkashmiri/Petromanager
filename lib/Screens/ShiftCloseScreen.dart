import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/AppColors.dart';

class ShiftCloseScreen extends StatefulWidget {
  const ShiftCloseScreen({Key? key}) : super(key: key);

  @override
  State<ShiftCloseScreen> createState() => _ShiftCloseScreenState();
}

class _ShiftCloseScreenState extends State<ShiftCloseScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Selected nozzle
  String? _selectedNozzle;
  final List<String> _nozzleOptions = [
    'Pump 1 - Nozzle A',
    'Pump 1 - Nozzle B',
    'Pump 2 - Nozzle A',
    'Pump 2 - Nozzle B',
  ];

  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Opening Values (Start of Shift) - Read Only
  final Map<String, double> _openingValues = {
    'petrolTank': 10000,
    'dieselTank': 8000,
    'cash': 2000,
    'pump1NozzleA': 10000, // Petrol
    'pump1NozzleB': 8000, // Diesel
    'pump2NozzleA': 10000, // Petrol
    'pump2NozzleB': 8000, // Diesel
    'analoguePump1NozzleA': 149.5,
    'analoguePump1NozzleB': 119.8,
    'analoguePump2NozzleA': 149.5,
    'analoguePump2NozzleB': 119.8,
  };

  // Form Controllers for Closing Tank Levels
  final TextEditingController _closingPetrolTankController =
      TextEditingController();
  final TextEditingController _closingDieselTankController =
      TextEditingController();

  // Form Controllers for Closing Cash
  final TextEditingController _closingCashController = TextEditingController();

  // Form Controllers for Selected Nozzle Readings
  final TextEditingController _digitalReadingController =
      TextEditingController();
  final TextEditingController _analogueReadingController =
      TextEditingController();

  // Online Payment Controller
  final TextEditingController _onlinePaymentController =
      TextEditingController();

  // Fuel prices per liter
  final double _petrolPricePerLiter = 1.45;
  final double _dieselPricePerLiter = 1.35;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeClosingValues();
    _addListeners();
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

  void _initializeClosingValues() {
    // Set example closing values
    _closingPetrolTankController.text = '7500';
    _closingDieselTankController.text = '5200';
    _closingCashController.text = '3850';
    _onlinePaymentController.text = '1250';
    _digitalReadingController.text = '12450';
    _analogueReadingController.text = '187.2';
  }

  void _addListeners() {
    // Add listeners to all controllers to trigger recalculation
    List<TextEditingController> controllers = [
      _closingPetrolTankController,
      _closingDieselTankController,
      _closingCashController,
      _digitalReadingController,
      _onlinePaymentController,
    ];

    for (var controller in controllers) {
      controller.addListener(() {
        setState(() {
          // Trigger rebuild for calculations
        });
      });
    }
  }

  Color _getNozzleColor(String nozzle) {
    switch (nozzle) {
      case 'Pump 1 - Nozzle A':
        return Colors.purple;
      case 'Pump 1 - Nozzle B':
        return Colors.purple.shade700;
      case 'Pump 2 - Nozzle A':
        return Colors.teal;
      case 'Pump 2 - Nozzle B':
        return Colors.teal.shade700;
      default:
        return Colors.grey;
    }
  }

  String _getNozzleKey(String nozzle) {
    switch (nozzle) {
      case 'Pump 1 - Nozzle A':
        return 'pump1NozzleA';
      case 'Pump 1 - Nozzle B':
        return 'pump1NozzleB';
      case 'Pump 2 - Nozzle A':
        return 'pump2NozzleA';
      case 'Pump 2 - Nozzle B':
        return 'pump2NozzleB';
      default:
        return '';
    }
  }

  bool _isNozzlePetrol(String nozzle) {
    return nozzle.contains('Nozzle A'); // Assuming A is petrol, B is diesel
  }

  // Calculate fuel sales for selected nozzle
  double get _fuelSalesLiters {
    if (_selectedNozzle == null) return 0.0;

    double closingReading = _parseDouble(_digitalReadingController.text);
    String nozzleKey = _getNozzleKey(_selectedNozzle!);
    double openingReading = _openingValues[nozzleKey] ?? 0.0;

    return closingReading - openingReading;
  }

  // Calculate fuel sales amount for selected nozzle
  double get _fuelSalesAmount {
    if (_selectedNozzle == null) return 0.0;

    double pricePerLiter = _isNozzlePetrol(_selectedNozzle!)
        ? _petrolPricePerLiter
        : _dieselPricePerLiter;

    return _fuelSalesLiters * pricePerLiter;
  }

  // Calculate cash sales
  double get _cashSales {
    double closingCash = _parseDouble(_closingCashController.text);
    double openingCash = _openingValues['cash']!;
    return closingCash - openingCash;
  }

  // Get online payments
  double get _onlinePayments {
    return _parseDouble(_onlinePaymentController.text);
  }

  // Calculate total payments
  double get _totalPayments {
    return _cashSales + _onlinePayments;
  }

  double _parseDouble(String value) {
    return double.tryParse(value.replaceAll(',', '')) ?? 0.0;
  }

  Future<void> _pickImage() async {
    if (_selectedImage != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Replace Image'),
            content: Text(
              'You can only upload one image. Do you want to replace the current image?',
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: Text('Replace'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _selectImage();
                },
              ),
            ],
          );
        },
      );
    } else {
      _selectImage();
    }
  }

  Future<void> _selectImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _removeImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  bool _isFormValid() {
    return _selectedNozzle != null &&
        _closingPetrolTankController.text.isNotEmpty &&
        _closingDieselTankController.text.isNotEmpty &&
        _closingCashController.text.isNotEmpty &&
        _digitalReadingController.text.isNotEmpty &&
        _analogueReadingController.text.isNotEmpty &&
        _onlinePaymentController.text.isNotEmpty;
  }

  Future<void> _submitForm() async {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all required fields and select a nozzle'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 2000));

    setState(() {
      _isLoading = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Shift closed successfully for $_selectedNozzle!'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
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
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Column(
                          children: [
                            SizedBox(height: 20.h),
                            _buildNozzleSelectionCard(),
                            SizedBox(height: 24.h),
                            if (_selectedNozzle != null) ...[
                              _buildClosingSection(),
                              SizedBox(height: 24.h),
                              _buildCalculationsSection(),
                              SizedBox(height: 24.h),
                              _buildSubmitButton(),
                            ],
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
          Text(
            'Close Your Shift',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNozzleSelectionCard() {
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
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.15),
              offset: Offset(0, 12.h),
              blurRadius: 30.r,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 4.h),
              blurRadius: 15.r,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.stop_circle,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Your Nozzle',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Choose the nozzle you operated during shift',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Nozzle Selection Grid
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 2.5,
              ),
              itemCount: _nozzleOptions.length,
              itemBuilder: (context, index) {
                final nozzle = _nozzleOptions[index];
                final isSelected = _selectedNozzle == nozzle;
                final nozzleColor = _getNozzleColor(nozzle);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedNozzle = nozzle;
                      // Clear previous readings when switching nozzles
                      _digitalReadingController.clear();
                      _analogueReadingController.clear();
                      // Reset with example values for demo
                      _digitalReadingController.text = '12450';
                      _analogueReadingController.text = '187.2';
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? nozzleColor.withOpacity(0.1)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected ? nozzleColor : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: nozzleColor.withOpacity(0.2),
                                offset: Offset(0, 4.h),
                                blurRadius: 12.r,
                              ),
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          color: isSelected
                              ? nozzleColor
                              : Colors.grey.shade500,
                          size: 20.sp,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          nozzle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: isSelected
                                ? nozzleColor
                                : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            if (_selectedNozzle != null) ...[
              SizedBox(height: 16.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: _getNozzleColor(_selectedNozzle!).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: _getNozzleColor(_selectedNozzle!).withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: _getNozzleColor(_selectedNozzle!),
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Selected: $_selectedNozzle',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: _getNozzleColor(_selectedNozzle!),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildClosingSection() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.95)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              offset: Offset(0, 12.h),
              blurRadius: 30.r,
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 4.h),
              blurRadius: 15.r,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shift Closing Details',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 30.h),

            // Tank Levels Section
            _buildSectionCard(
              title: 'Tank Levels',
              icon: Icons.local_gas_station,
              children: [
                _buildInputField(
                  controller: _closingPetrolTankController,
                  label: 'Petrol Tank Level',
                  hint: 'Enter closing petrol tank level',
                  suffix: 'Liters',
                  icon: Icons.local_gas_station_outlined,
                  color: Colors.green,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _closingDieselTankController,
                  label: 'Diesel Tank Level',
                  hint: 'Enter closing diesel tank level',
                  suffix: 'Liters',
                  icon: Icons.local_gas_station,
                  color: Colors.orange,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Cash & Payments Section
            _buildSectionCard(
              title: 'Cash & Payments',
              icon: Icons.account_balance_wallet,
              children: [
                _buildInputField(
                  controller: _closingCashController,
                  label: 'Closing Cash Amount',
                  hint: 'Enter closing cash amount',
                  prefix: '₹',
                  icon: Icons.currency_rupee,
                  color: Colors.blue,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _onlinePaymentController,
                  label: 'Online Payments',
                  hint: 'Enter online payments received',
                  prefix: '₹',
                  icon: Icons.payment,
                  color: Colors.purple,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Selected Nozzle Readings Section
            _buildSectionCard(
              title: '$_selectedNozzle Readings',
              icon: Icons.speed,
              subtitle: 'Record closing readings for your selected nozzle',
              children: [
                _buildInputField(
                  controller: _digitalReadingController,
                  label: 'Digital Reading',
                  hint: '0.00',
                  suffix: 'L',
                  icon: Icons.speed,
                  color: _getNozzleColor(_selectedNozzle!),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _analogueReadingController,
                  label: 'Analogue Reading',
                  hint: '0.0',
                  suffix: 'V',
                  icon: Icons.analytics_outlined,
                  color: _getNozzleColor(_selectedNozzle!),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Image Upload Section
            _buildSectionCard(
              title: 'Shift Summary Photo',
              icon: Icons.camera_alt,
              subtitle: 'Upload one photo of shift summary (optional)',
              children: [_buildImageUploadSection()],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    String? subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 4.h),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? prefix,
    String? suffix,
    required IconData icon,
    required Color color,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.1),
                offset: Offset(0, 2.h),
                blurRadius: 8.r,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade400,
                fontWeight: FontWeight.w500,
              ),
              prefixIcon: Container(
                margin: EdgeInsets.all(8.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, size: 18.sp, color: color),
              ),
              prefixText: prefix,
              suffixText: suffix,
              prefixStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              suffixStyle: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide(color: color, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageUploadSection() {
    return Container(
      width: double.infinity,
      child: _selectedImage == null
          ? _buildImageUploadButton()
          : _buildSelectedImagePreview(),
    );
  }

  Widget _buildImageUploadButton() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 120.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey.shade300,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 32.sp, color: Colors.grey.shade600),
            SizedBox(height: 8.h),
            Text(
              'Take Photo',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Tap to open camera',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedImagePreview() {
    return Container(
      height: 200.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: Image.file(
              _selectedImage!,
              height: 200.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: _removeImage,
              child: Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Icon(Icons.close, color: Colors.white, size: 18.sp),
              ),
            ),
          ),
          Positioned(
            bottom: 8.h,
            left: 8.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'Photo Uploaded',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.green.withOpacity(0.2), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
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
              Icon(Icons.calculate, color: Colors.green, size: 24.sp),
              SizedBox(width: 12.w),
              Text(
                'Sales Summary',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Selected Nozzle Sales
          _buildSummaryCard(
            title: '$_selectedNozzle Sales',
            icon: Icons.local_gas_station,
            color: _getNozzleColor(_selectedNozzle!),
            items: [
              _buildSummaryItem(
                _isNozzlePetrol(_selectedNozzle!)
                    ? 'Petrol Sales'
                    : 'Diesel Sales',
                '${_fuelSalesLiters.toStringAsFixed(1)} L',
                '₹${_fuelSalesAmount.toStringAsFixed(2)}',
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Payment Summary
          _buildSummaryCard(
            title: 'Payment Summary',
            icon: Icons.payments,
            color: Colors.orange,
            items: [
              _buildSummaryItem(
                'Cash Sales',
                '',
                '₹${_cashSales.toStringAsFixed(2)}',
              ),
              _buildSummaryItem(
                'Online Payments',
                '',
                '₹${_onlinePayments.toStringAsFixed(2)}',
              ),
              Divider(color: Colors.grey.shade300),
              _buildSummaryItem(
                'Total Payments',
                '',
                '₹${_totalPayments.toStringAsFixed(2)}',
                isTotal: true,
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // Variance Check
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: _fuelSalesAmount == _totalPayments
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: _fuelSalesAmount == _totalPayments
                    ? Colors.green
                    : Colors.orange,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _fuelSalesAmount == _totalPayments
                      ? Icons.check_circle
                      : Icons.warning,
                  color: _fuelSalesAmount == _totalPayments
                      ? Colors.green
                      : Colors.orange,
                  size: 24.sp,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Variance Check',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _fuelSalesAmount == _totalPayments
                            ? 'Sales and payments match perfectly!'
                            : 'Variance: ₹${(_fuelSalesAmount - _totalPayments).abs().toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: _fuelSalesAmount == _totalPayments
                              ? Colors.green
                              : Colors.orange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> items,
  }) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            offset: Offset(0, 4.h),
            blurRadius: 12.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: color, size: 20.sp),
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...items,
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String label,
    String quantity,
    String amount, {
    bool isTotal = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16.sp : 14.sp,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.textPrimary : AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              if (quantity.isNotEmpty) ...[
                Text(
                  quantity,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(width: 8.w),
              ],
              Text(
                amount,
                style: TextStyle(
                  fontSize: isTotal ? 16.sp : 14.sp,
                  fontWeight: FontWeight.w700,
                  color: isTotal
                      ? Colors.green.shade700
                      : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.4),
            offset: Offset(0, 6.h),
            blurRadius: 20.r,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: _isLoading ? null : _submitForm,
          child: Container(
            alignment: Alignment.center,
            child: _isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.h,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Closing Shift...',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.stop_circle_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Close Shift for $_selectedNozzle',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardAnimationController.dispose();

    // Dispose all controllers
    _closingPetrolTankController.dispose();
    _closingDieselTankController.dispose();
    _closingCashController.dispose();
    _digitalReadingController.dispose();
    _analogueReadingController.dispose();
    _onlinePaymentController.dispose();

    super.dispose();
  }
}
