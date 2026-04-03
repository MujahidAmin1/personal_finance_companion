import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_finance_companion_app/core/appcolors.dart';
import 'package:personal_finance_companion_app/features/btm_navbar/view/navbar_view.dart';
import 'package:personal_finance_companion_app/features/onboarding/controller/onboarding_ctrl.dart';
import 'package:personal_finance_companion_app/features/onboarding/first_setup.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      final isFirstTime = ref.read(onboardingControllerProvider).isFirstTime;
      if (isFirstTime) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FirstSetupScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const BtmNavBarScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFFEFE9FE),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 32,
                    right: 32,
                    child: CircleAvatar(radius: 12, backgroundColor: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 40,
                    left: 36,
                    child: CircleAvatar(radius: 10, backgroundColor: AppColors.primary),
                  ),
                  Positioned(
                    bottom: 30,
                    right: 48,
                    child: CircleAvatar(radius: 8, backgroundColor: AppColors.primary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Finsight',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your personal budget tracker',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
