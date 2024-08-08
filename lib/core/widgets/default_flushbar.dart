import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theming/colors.dart';

void showDefaultFlushBar({
  required BuildContext context,
  required Color color,
  Widget? icon,
  String? title,
  required String messageText,
}) =>
    Flushbar(
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      flushbarPosition: FlushbarPosition.TOP,
      margin: EdgeInsets.only(
        top: 5.h,
        right: 20.w,
        left: 20.w,
      ),
      backgroundColor: color,
      borderRadius: BorderRadius.circular(10.r),
      barBlur: 5,
      icon: icon ??
          Icon(
            Icons.error_outline,
            color: AppColors.white,
          ),
      messageText: Text(
        messageText,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.white,
              fontFamily: "Regular",
              fontSize: 16.sp,
            ),
      ),
      title: title,
      duration: const Duration(seconds: 4),
    ).show(context);
