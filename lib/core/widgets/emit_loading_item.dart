import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';

class EmitLoadingItem extends StatelessWidget {
  const EmitLoadingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.mainColor,
      ),
    );
  }
}

class SmallCircleIndicator extends StatelessWidget {
  const SmallCircleIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1,
      widthFactor: 1,
      child: SizedBox(
        height: 16.h,
        width: 16.h,
        child: CircularProgressIndicator(
          color: AppColors.mainColor,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
