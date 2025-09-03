import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:fuleflowpro/Screens/DashboardScreen.dart';
import '../../utils/AppColors.dart';
import '../Providers/LoginProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _logoAnimationController;
  late AnimationController _errorAnimationController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _errorShakeAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _errorAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.elasticOut,
          ),
        );

    _logoRotateAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _errorShakeAnimation = Tween<double>(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _errorAnimationController,
        curve: Curves.elasticOut,
      ),
    );

    _animationController.forward();
    _logoAnimationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          _buildFloatingDecorations(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: Consumer<LoginProvider>(
                      builder: (context, provider, child) {
                        return Form(
                          key: provider.formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildAnimatedLogo(),
                              SizedBox(height: 32.h),
                              _buildWelcomeText(),
                              SizedBox(height: 40.h),
                              _buildLoginForm(provider),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
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
    );
  }

  Widget _buildFloatingDecorations() {
    return Stack(
      children: [
        Positioned(
          top: 80.h,
          right: -40.w,
          child: _buildFloatingCircle(
            120.w,
            AppColors.secondary.withOpacity(0.05),
          ),
        ),
        Positioned(
          bottom: 150.h,
          left: -60.w,
          child: _buildFloatingCircle(
            160.w,
            AppColors.primary.withOpacity(0.03),
          ),
        ),
        Positioned(
          top: 200.h,
          left: 30.w,
          child: _buildFloatingCircle(
            80.w,
            AppColors.secondary.withOpacity(0.02),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoRotateAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _logoRotateAnimation.value * 0.1,
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(28.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  offset: Offset(0, 8.h),
                  blurRadius: 20.r,
                ),
              ],
            ),
            child: Icon(Icons.house, size: 40.sp, color: AppColors.textLight),
          ),
        );
      },
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
            letterSpacing: -1.0,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Secure access to your financial world',
          style: TextStyle(
            fontSize: 15.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(LoginProvider provider) {
    return Container(
      padding: EdgeInsets.all(28.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.1),
            offset: Offset(0, 10.h),
            blurRadius: 30.r,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2.h),
            blurRadius: 10.r,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          if (provider.errorMessage != null)
            _buildErrorMessage(provider.errorMessage!),
          SizedBox(height: 5.h),
          _buildEnhancedTextField(
            controller: provider.idController,
            label: 'User ID',
            icon: Icons.person_outline_rounded,
            validator: provider.validateUserId,
            onChanged: (_) => provider.clearError(),
          ),
          SizedBox(height: 20.h),
          _buildEnhancedTextField(
            controller: provider.passwordController,
            label: 'Password',
            icon: Icons.lock_outline_rounded,
            isPassword: true,
            isPasswordVisible: provider.isPasswordVisible,
            onPasswordToggle: provider.togglePasswordVisibility,
            validator: provider.validatePassword,
            onChanged: (_) => provider.clearError(),
          ),
          SizedBox(height: 16.h),
          _buildRememberMeCheckbox(provider),
          SizedBox(height: 24.h),
          _buildEnhancedButton(provider),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordToggle,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              letterSpacing: 0.3,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.05),
                offset: Offset(0, 2.h),
                blurRadius: 8.r,
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            obscureText: isPassword && !isPasswordVisible,
            validator: validator,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              prefixIcon: Container(
                width: 48.w,
                height: 48.h,
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 8.w),
                child: Icon(icon, color: AppColors.secondary, size: 22.sp),
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: AppColors.textHint,
                        size: 22.sp,
                      ),
                      onPressed: onPasswordToggle,
                    )
                  : null,
              filled: true,
              fillColor: AppColors.background.withOpacity(0.7),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: AppColors.border.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: AppColors.secondary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: AppColors.error, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(color: AppColors.error, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 20.h,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeCheckbox(LoginProvider provider) {
    return Row(
      children: [
        Transform.scale(
          scale: 0.8,
          child: Checkbox(
            value: provider.rememberMe,
            onChanged: provider.toggleRememberMe,
            activeColor: AppColors.secondary,
            checkColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        Text(
          'Remember me',
          style: TextStyle(
            fontSize: 13.sp,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedButton(LoginProvider provider) {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.4),
            offset: Offset(0, 6.h),
            blurRadius: 20.r,
          ),
          BoxShadow(
            color: AppColors.secondary.withOpacity(0.2),
            offset: Offset(0, 2.h),
            blurRadius: 8.r,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: provider.isLoading ? null : () => _handleLogin(provider),
          child: Container(
            alignment: Alignment.center,
            child: provider.isLoading
                ? _buildLoadingState()
                : _buildNormalState(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20.w,
          height: 20.h,
          child: const CircularProgressIndicator(
            color: AppColors.textLight,
            strokeWidth: 2.5,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          'Signing In...',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildNormalState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.login_rounded, color: AppColors.textLight, size: 20.sp),
        SizedBox(width: 8.w),
        Text(
          'Sign In',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textLight,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage(String message) {
    return AnimatedBuilder(
      animation: _errorShakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_errorShakeAnimation.value * 10, 0),
          child: Container(
            margin: EdgeInsets.only(top: 16.h),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 20.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _handleLogin(LoginProvider provider) async {
    final success = await provider.signIn();
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DashboardScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
        (Route<dynamic> route) => false,
      );
    } else if (!success && mounted) {
      _errorAnimationController.forward().then((_) {
        _errorAnimationController.reverse();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _logoAnimationController.dispose();
    _errorAnimationController.dispose();
    super.dispose();
  }
}
