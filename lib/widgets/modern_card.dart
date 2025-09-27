import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';

class ModernCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final bool isLoading;
  final bool showShimmer;
  final double? width;
  final double? height;
  final Border? border;
  final List<BoxShadow>? boxShadow;

  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.isLoading = false,
    this.showShimmer = false,
    this.width,
    this.height,
    this.border,
    this.boxShadow,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _elevationAnimation = Tween<double>(
      begin: widget.elevation ?? 2.0,
      end: (widget.elevation ?? 2.0) + 4.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  void _onTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.showShimmer || widget.isLoading) {
      return _buildShimmerCard();
    }

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: widget.margin ?? EdgeInsets.all(8.w),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onTap,
                onTapDown: _onTapDown,
                onTapUp: _onTapUp,
                onTapCancel: _onTapCancel,
                borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: widget.padding ?? EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: widget.backgroundColor ?? Colors.white,
                    borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
                    border: widget.border,
                    boxShadow: widget.boxShadow ?? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        offset: const Offset(0, 2),
                        blurRadius: _elevationAnimation.value * 2,
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 4),
                        blurRadius: _elevationAnimation.value * 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: widget.child,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      width: widget.width,
      height: widget.height ?? 120.h,
      margin: widget.margin ?? EdgeInsets.all(8.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(16.r),
          ),
          child: Padding(
            padding: widget.padding ?? EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 16.h,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 150.w,
                  height: 14.h,
                  color: Colors.white,
                ),
                SizedBox(height: 8.h),
                Container(
                  width: 100.w,
                  height: 12.h,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Predefined card styles
class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool isLoading;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      isLoading: isLoading,
      backgroundColor: backgroundColor ?? Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: (iconColor ?? const Color(0xFF1A237E)).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? const Color(0xFF1A237E),
                  size: 24.sp,
                ),
              ),
              const Spacer(),
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey.shade400,
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final String category;
  final String price;
  final String stock;
  final String? imageUrl;
  final VoidCallback? onTap;
  final bool isLoading;

  const ProductCard({
    super.key,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      isLoading: isLoading,
      child: Row(
        children: [
          // Product Image
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.wine_bar,
                        color: Colors.grey.shade400,
                        size: 30.sp,
                      ),
                    ),
                  )
                : Icon(
                    Icons.wine_bar,
                    color: Colors.grey.shade400,
                    size: 30.sp,
                  ),
          ),
          
          SizedBox(width: 16.w),
          
          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  category,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A237E),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: int.parse(stock.split(' ')[0]) > 10
                            ? Colors.green.withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        stock,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: int.parse(stock.split(' ')[0]) > 10
                              ? Colors.green.shade700
                              : Colors.orange.shade700,
                        ),
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
}
