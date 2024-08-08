import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import 'custom_text.dart';

class EmitFailedItem extends StatelessWidget {
  const EmitFailedItem({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomText(
        text: text,
        color: AppColors.redPrimary,
        fontSize: 20.sp,
        fontWeight: FontWeight.w500,
        maxLines: 5,
        textAlign: TextAlign.center,
      ),
    );
  }
}
