import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../utils/AppColors.dart';

class PumpTestingScreen extends StatefulWidget {
  const PumpTestingScreen({Key? key}) : super(key: key);

  @override
  State<PumpTestingScreen> createState() => _PumpTestingScreenState();
}

class _PumpTestingScreenState extends State<PumpTestingScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Form Controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _testVolumeController = TextEditingController();
  final TextEditingController _meterReadingController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Form Data
  String _selectedTester = 'Select Tester';
  String _selectedNozzle = '1';
  double _errorPercentage = 0.0;
  String _testStatus = 'Pass';

  // Auto-filled data
  late String _currentDate;
  late String _currentTime;

  // Photo
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  // GPS Location (Mock)
  String _gpsLocation = "23.2599° N, 77.4126° E";

  // Dropdown options
  final List<String> _testers = [
    'Select Tester',
    'John Doe',
    'Jane Smith',
    'Mike Johnson',
    'Sarah Wilson',
    'David Brown',
  ];

  final List<String> _nozzles = ['1', '2', '3', '4', '5', '6'];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeDateTime();
    _getMockGPSLocation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );

    _animationController.forward();
  }

  void _initializeDateTime() {
    final now = DateTime.now();
    _currentDate =
        "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";
    _currentTime =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";
  }

  void _getMockGPSLocation() {
    setState(() {
      _gpsLocation = "23.2599° N, 77.4126° E (Indore)";
    });
  }

  void _calculateError() {
    final testVolume = double.tryParse(_testVolumeController.text) ?? 0.0;
    final meterReading = double.tryParse(_meterReadingController.text) ?? 0.0;

    if (testVolume > 0 && meterReading > 0) {
      final error = meterReading - testVolume;
      final errorPercentage = (error / testVolume) * 100;

      setState(() {
        _errorPercentage = errorPercentage;
        // Auto-determine status based on ±2% tolerance
        _testStatus = errorPercentage.abs() <= 2.0 ? 'Pass' : 'Fail';
      });
    }
  }

  Future<void> _takePicture() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        imageQuality: 80,
      );

      if (photo != null) {
        setState(() {
          _photo = File(photo.path);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Photo added successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to take picture: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveTest() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTester == 'Select Tester') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a tester'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16.h),
                Text('Saving Test...'),
              ],
            ),
          ),
        ),
      );

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop(); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 24.sp),
              SizedBox(width: 8.w),
              Text('Success'),
            ],
          ),
          content: Text('Test saved successfully!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _generateReport() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedTester == 'Select Tester') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select a tester'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: AppColors.primary),
                SizedBox(height: 16.h),
                Text('Generating Report...'),
              ],
            ),
          ),
        ),
      );

      // Simulate API call
      await Future.delayed(Duration(seconds: 3));
      Navigator.of(context).pop(); // Close loading dialog

      // Show success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          title: Row(
            children: [
              Icon(Icons.description, color: AppColors.primary, size: 24.sp),
              SizedBox(width: 8.w),
              Text('Report Generated'),
            ],
          ),
          content: Text('Test report has been generated and saved!'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('View Report'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
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
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          child: Column(
                            children: [
                              SizedBox(height: 20.h),
                              _buildTestEntrySection(),
                              SizedBox(height: 30.h),
                            ],
                          ),
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
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: AppColors.primary),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Test Entry',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Fuel Pump Accuracy Test',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.location_on,
                  size: 16.sp,
                  color: AppColors.secondary,
                ),
                SizedBox(width: 4.w),
                Text(
                  'GPS',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: AppColors.secondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestEntrySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            offset: Offset(0, 4.h),
            blurRadius: 15.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.edit_note, size: 20.sp, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                'Test Details',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Tester Dropdown
          _buildDropdown(
            value: _selectedTester,
            label: 'Tester',
            icon: Icons.person,
            items: _testers,
            onChanged: (value) => setState(() => _selectedTester = value!),
          ),

          SizedBox(height: 16.h),

          // Nozzle Selection
          _buildDropdown(
            value: _selectedNozzle,
            label: 'Nozzle',
            icon: Icons.local_gas_station,
            items: _nozzles,
            onChanged: (value) => setState(() => _selectedNozzle = value!),
          ),

          SizedBox(height: 16.h),

          // Test Volume and Meter Reading
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _testVolumeController,
                  label: 'Test Volume (L)',
                  icon: Icons.straighten,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => _calculateError(),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildTextField(
                  controller: _meterReadingController,
                  label: 'Meter Reading (L)',
                  icon: Icons.speed,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) => _calculateError(),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Error % and Status (Auto-calculated)
          if (_testVolumeController.text.isNotEmpty &&
              _meterReadingController.text.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: _testStatus == 'Pass'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: _testStatus == 'Pass' ? Colors.green : Colors.red,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate,
                        size: 18.sp,
                        color: _testStatus == 'Pass'
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Error %: ${_errorPercentage.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: _testStatus == 'Pass'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      Spacer(),
                      Icon(
                        _testStatus == 'Pass'
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 20.sp,
                        color: _testStatus == 'Pass'
                            ? Colors.green
                            : Colors.red,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        _testStatus,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: _testStatus == 'Pass'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Tolerance: ±2% | Actual Difference: ${((double.tryParse(_meterReadingController.text) ?? 0) - (double.tryParse(_testVolumeController.text) ?? 0)).toStringAsFixed(3)}L',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

          SizedBox(height: 20.h),

          _buildTextField(
            controller: _notesController,
            label: 'Notes (Optional)',
            icon: Icons.note,
            maxLines: 3,
          ),

          SizedBox(height: 20.h),

          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      size: 18.sp,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      '(Meter)Photo',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Spacer(),
                    ElevatedButton.icon(
                      onPressed: _takePicture,
                      icon: Icon(Icons.camera_alt, size: 16.sp),
                      label: Text('Take Photo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 8.h,
                        ),
                      ),
                    ),
                  ],
                ),
                if (_photo != null) ...[
                  SizedBox(height: 12.h),
                  Container(
                    height: 120.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(_photo!, fit: BoxFit.cover),
                    ),
                  ),
                ],
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _saveTest,
                  icon: Icon(Icons.save, size: 20.sp),
                  label: Text('SAVE TEST'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20.sp, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required IconData icon,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20.sp, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(
              color: item == 'Select Tester'
                  ? AppColors.textSecondary
                  : AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _testVolumeController.dispose();
    _meterReadingController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
