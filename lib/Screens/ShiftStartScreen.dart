import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../utils/AppColors.dart';

class ShiftStartScreen extends StatefulWidget {
  const ShiftStartScreen({Key? key}) : super(key: key);

  @override
  State<ShiftStartScreen> createState() => _ShiftStartScreenState();
}

class _ShiftStartScreenState extends State<ShiftStartScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  late AnimationController _animationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  // Form Controllers for Tank Levels
  final TextEditingController _petrolTankController = TextEditingController();
  final TextEditingController _dieselTankController = TextEditingController();

  // Form Controllers for Cash
  final TextEditingController _cashController = TextEditingController();

  // Form Controllers for Rates
  final TextEditingController _petrolRateController = TextEditingController();
  final TextEditingController _dieselRateController = TextEditingController();

  // Form Controllers for Digital Readings
  final TextEditingController _pump1Nozzle1aController =
      TextEditingController();
  final TextEditingController _pump1Nozzle1bController =
      TextEditingController();
  final TextEditingController _pump2Nozzle2aController =
      TextEditingController();
  final TextEditingController _pump2Nozzle2bController =
      TextEditingController();

  // Form Controllers for Analogue Readings
  final TextEditingController _analoguePump1Nozzle1aController =
      TextEditingController();
  final TextEditingController _analoguePump1Nozzle1bController =
      TextEditingController();
  final TextEditingController _analoguePump2Nozzle2aController =
      TextEditingController();
  final TextEditingController _analoguePump2Nozzle2bController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeDefaultValues();
  }

  Future<void> _pickImage() async {
    if (_selectedImage != null) {
      // Show confirmation dialog to replace existing image
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

  void _initializeDefaultValues() {
    _petrolTankController.text = '';
    _dieselTankController.text = '';
    _cashController.text = '';
    _petrolRateController.text = '';
    _dieselRateController.text = '';
    _pump1Nozzle1aController.text = '';
    _pump1Nozzle1bController.text = '';
    _pump2Nozzle2aController.text = '';
    _pump2Nozzle2bController.text = '';
    _analoguePump1Nozzle1aController.text = '';
    _analoguePump1Nozzle1bController.text = '';
    _analoguePump2Nozzle2aController.text = '';
    _analoguePump2Nozzle2bController.text = '';
  }

  Future<void> _submitForm() async {
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
        content: Text('Shift details saved successfully!'),
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
                            _buildFormSection(),
                            SizedBox(height: 24.h),
                            _buildSubmitButton(),
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
            'Shift Details',
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

  Widget _buildFormSection() {
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
              'Opening (Start of the Shift)',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 30.h),

            // Today's Rates Section
            _buildSectionCard(
              title: "Today's Fuel Rates",
              icon: Icons.local_offer,
              subtitle: 'Enter current fuel rates',
              children: [
                _buildInputField(
                  controller: _petrolRateController,
                  label: "Today's Petrol Rate",
                  hint: 'Enter petrol rate per liter',
                  prefix: '₹',
                  suffix: '/L',
                  icon: Icons.local_gas_station_outlined,
                  color: Colors.green,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _dieselRateController,
                  label: "Today's Diesel Rate",
                  hint: 'Enter diesel rate per liter',
                  prefix: '₹',
                  suffix: '/L',
                  icon: Icons.local_gas_station,
                  color: Colors.orange,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Tank Levels Section
            _buildSectionCard(
              title: 'Tank Levels',
              icon: Icons.local_gas_station,
              children: [
                _buildInputField(
                  controller: _petrolTankController,
                  label: 'Petrol Tank Level',
                  hint: 'Enter petrol tank level',
                  suffix: 'Liters',
                  icon: Icons.local_gas_station_outlined,
                  color: Colors.green,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _dieselTankController,
                  label: 'Diesel Tank Level',
                  hint: 'Enter diesel tank level',
                  suffix: 'Liters',
                  icon: Icons.local_gas_station,
                  color: Colors.orange,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Cash On Hand Section
            _buildSectionCard(
              title: 'Cash On Hand',
              icon: Icons.account_balance_wallet,
              children: [
                _buildInputField(
                  controller: _cashController,
                  label: 'Cash Amount',
                  hint: 'Enter cash amount',
                  prefix: '₹',
                  icon: Icons.currency_rupee,
                  color: Colors.blue,
                  keyboardType: TextInputType.number,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Meter Readings Section
            _buildSectionCard(
              title: 'Digital Meter Readings',
              icon: Icons.speed,
              subtitle: 'Record current digital readings',
              children: [
                _buildInputField(
                  controller: _pump1Nozzle1aController,
                  label: 'Pump 1 - Nozzle A',
                  hint: '0.00',
                  suffix: 'L',
                  icon: Icons.speed,
                  color: Colors.purple,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _pump1Nozzle1bController,
                  label: 'Pump 1 - Nozzle B',
                  hint: '0.00',
                  suffix: 'L',
                  icon: Icons.speed,
                  color: Colors.purple,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _pump2Nozzle2aController,
                  label: 'Pump 2 - Nozzle A',
                  hint: '0.00',
                  suffix: 'L',
                  icon: Icons.speed,
                  color: Colors.teal,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _pump2Nozzle2bController,
                  label: 'Pump 2 - Nozzle B',
                  hint: '0.00',
                  suffix: 'L',
                  icon: Icons.speed,
                  color: Colors.teal,
                ),
              ],
            ),

            SizedBox(height: 24.h),

            // Analogue Readings Section
            _buildSectionCard(
              title: 'Analogue Meter Readings',
              icon: Icons.analytics,
              subtitle: 'Record current analogue readings',
              children: [
                _buildInputField(
                  controller: _analoguePump1Nozzle1aController,
                  label: 'Pump 1 - Nozzle A',
                  hint: '0.0',
                  suffix: 'V',
                  icon: Icons.analytics_outlined,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _analoguePump1Nozzle1bController,
                  label: 'Pump 1 - Nozzle B',
                  hint: '0.0',
                  suffix: 'V',
                  icon: Icons.analytics_outlined,
                  color: Colors.red,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _analoguePump2Nozzle2aController,
                  label: 'Pump 2 - Nozzle A',
                  hint: '0.0',
                  suffix: 'V',
                  icon: Icons.analytics_outlined,
                  color: Colors.indigo,
                ),
                SizedBox(height: 16.h),
                _buildInputField(
                  controller: _analoguePump2Nozzle2bController,
                  label: 'Pump 2 - Nozzle B',
                  hint: '0.0',
                  suffix: 'V',
                  icon: Icons.analytics_outlined,
                  color: Colors.indigo,
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
          ],
        ),
      ),
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
    TextInputType keyboardType = TextInputType.text,
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

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
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
                        'Saving...',
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
                        Icons.save_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Save Shift Details',
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
    _petrolTankController.dispose();
    _dieselTankController.dispose();
    _cashController.dispose();
    _petrolRateController.dispose();
    _dieselRateController.dispose();
    _pump1Nozzle1aController.dispose();
    _pump1Nozzle1bController.dispose();
    _pump2Nozzle2aController.dispose();
    _pump2Nozzle2bController.dispose();
    _analoguePump1Nozzle1aController.dispose();
    _analoguePump1Nozzle1bController.dispose();
    _analoguePump2Nozzle2aController.dispose();
    _analoguePump2Nozzle2bController.dispose();

    super.dispose();
  }
}
