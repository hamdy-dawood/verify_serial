import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:verify_serial/core/helpers/navigator.dart';

import '../../core/helpers/cache_helper.dart';
import '../../core/theming/colors.dart';
import '../../core/widgets/custom_text.dart';
import '../home/view.dart';
import '../login/view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  _goNext() async {
    String token = CacheHelper.get(key: "access_token") ?? "";

    await Future.delayed(const Duration(milliseconds: 3000), () {});
    MagicRouter.navigateTo(
      page: token.isNotEmpty ? const HomeView() : const LoginView(),
      withHistory: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      body: Center(
        child: FittedBox(
          child: CustomText(
            text: "VERIFY SERIAL",
            color: AppColors.white,
            fontSize: 30.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
