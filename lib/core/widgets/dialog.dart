import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';
import 'custom_text.dart';

alertDialog({
  required BuildContext context,
  required VoidCallback yesPress,
  required String title,
  required String subTitle,
}) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: CustomText(
          text: title,
          color: AppColors.black,
          fontSize: 20.sp,
          fontWeight: FontWeight.w500,
        ),
        content: CustomText(
          text: subTitle,
          color: AppColors.black,
          fontSize: 16.sp,
          fontWeight: FontWeight.normal,
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomText(
                text: "لا",
                color: AppColors.mainColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 10.w),
          TextButton(
            onPressed: yesPress,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: CustomText(
                text: "نعم",
                color: AppColors.mainColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      );
    },
  );
}
