import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_elevated.dart';
import '../../../core/widgets/default_flushbar.dart';
import '../cubit.dart';
import '../states.dart';

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is VerifyFailedState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redPrimary,
            messageText: state.msg,
          );
        } else if (state is VerifyNetworkErrorState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redPrimary,
            messageText: "افحص الانترنت",
          );
        } else if (state is VerifySuccessState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.green,
            icon: Icon(
              Icons.check,
              color: AppColors.white,
            ),
            messageText: "تم تأكيد السيريال بنجاح",
          );
        }
      },
      builder: (context, state) {
        if (state is VerifyLoadingState) {
          return Container(
            height: 0.0689.sh,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: AppColors.mainColor,
            ),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            ),
          );
        }
        return CustomElevated(
          text: "تأكيد",
          press: () {
            if (cubit.fieldController.text.isNotEmpty) {
              cubit.verify();
            } else {
              showDefaultFlushBar(
                context: context,
                color: AppColors.redPrimary,
                messageText: "من فصلك ادخل الكود !",
              );
            }
          },
          btnColor: AppColors.mainColor,
        );
      },
    );
  }
}
