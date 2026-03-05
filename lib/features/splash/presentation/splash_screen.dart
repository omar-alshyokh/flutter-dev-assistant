import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _lift;

  @override
  void initState() {
    super.initState();

    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOut);
    _lift = Tween<double>(
      begin: 10,
      end: 0,
    ).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));
    _c.forward();

    // Navigate after short delay
    Future.delayed(const Duration(milliseconds: 1300), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/chat');
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, AppColors.bg],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -110,
              right: -70,
              child: _GlowCircle(
                size: 250,
                color: AppColors.primary.withValues(alpha: 0.16),
              ),
            ),
            Positioned(
              bottom: -90,
              left: -70,
              child: _GlowCircle(
                size: 220,
                color: AppColors.accent.withValues(alpha: 0.14),
              ),
            ),
            Center(
              child: FadeTransition(
                opacity: _fade,
                child: AnimatedBuilder(
                  animation: _lift,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, _lift.value),
                    child: child,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 28,
                              offset: const Offset(0, 14),
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.code_rounded,
                          size: 38,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 18),
                      const Text(
                        "WidgetWise",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        "Flutter Development Assistant",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.muted,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
