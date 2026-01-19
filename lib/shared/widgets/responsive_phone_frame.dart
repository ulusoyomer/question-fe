import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
class ResponsivePhoneFrame extends StatelessWidget {
  final Widget child;
  final double breakpoint;
  final double phoneWidth;
  final double phoneHeight;
  const ResponsivePhoneFrame({
    super.key,
    required this.child,
    this.breakpoint = 500,
    this.phoneWidth = 390,
    this.phoneHeight = 844,
  });
  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return child;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= breakpoint) {
          return child;
        }
        final availableHeight = constraints.maxHeight - 80; 
        final availableWidth = constraints.maxWidth - 80;
        final scaleX = availableWidth / phoneWidth;
        final scaleY = availableHeight / phoneHeight;
        final scale = (scaleX < scaleY ? scaleX : scaleY).clamp(0.5, 1.0);
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1a1a2e),
                Color(0xFF16213e),
                Color(0xFF0f3460),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'AI Question Generator',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                Transform.scale(
                  scale: scale,
                  child: _PhoneFrame(
                    width: phoneWidth,
                    height: phoneHeight,
                    child: child,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Resize window to remove frame',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
class _PhoneFrame extends StatelessWidget {
  final double width;
  final double height;
  final Widget child;
  const _PhoneFrame({
    required this.width,
    required this.height,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width + 24, 
      height: height + 24,
      decoration: BoxDecoration(
        color: const Color(0xFF1c1c1e),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 40,
            spreadRadius: 5,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: const Color(0xFF3a3a3c),
          width: 2,
        ),
      ),
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(40),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Stack(
            children: [
              SizedBox(
                width: width,
                height: height,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
