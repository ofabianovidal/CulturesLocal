import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class CultureAuthScaffold extends StatelessWidget {
  const CultureAuthScaffold({
    super.key,
    required this.title,
    required this.child,
    this.onBack,
  });

  final String title;
  final Widget child;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.yellow,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 158,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 0),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Positioned(
                      top: 20,
                      left: 0,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onBack ?? () => Navigator.of(context).maybePop(),
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Icon(
                            Icons.chevron_left_rounded,
                            size: 28,
                            color: AppColors.green,
                          ),
                        ),
                      ),
                    ),
                    const Positioned(
                      top: 28,
                      right: 8,
                      child: SizedBox(width: 28),
                    ),
                    Positioned(
                      top: 24,
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.softPanel,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(34)),
                ),
                child: SafeArea(top: false, child: child),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
