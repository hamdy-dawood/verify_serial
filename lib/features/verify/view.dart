import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:verify_serial/features/home/view.dart';

import '../../core/helpers/navigator.dart';
import '../../core/theming/colors.dart';
import '../../core/widgets/custom_elevated.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../core/widgets/default_flushbar.dart';
import 'cubit.dart';
import 'states.dart';

class VerifyView extends StatelessWidget {
  const VerifyView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyCubit(),
      child: const _VerifyBody(),
    );
  }
}

class _VerifyBody extends StatelessWidget {
  const _VerifyBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<VerifyCubit>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        title: CustomText(
          text: "التفعيل",
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Form(
        key: cubit.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 0.2.sh),
                    BlocBuilder<VerifyCubit, VerifyStates>(
                      builder: (context, state) {
                        return _FieldTextField(cubit: cubit);
                      },
                    ),
                    SizedBox(height: 0.06.sh),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.h),
        child: _VerifyButton(
          cubit: cubit,
        ),
      ),
    );
  }
}

class _FieldTextField extends StatelessWidget {
  const _FieldTextField({required this.cubit});

  final VerifyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.fieldController,
      hint: "كود التفعيل",
      validator: (value) {
        if (value!.isEmpty) {
          return "أدخل الكود !";
        }
        return null;
      },
      isLastInput: true,
    );
  }
}

class _VerifyButton extends StatelessWidget {
  const _VerifyButton({
    required this.cubit,
  });

  final VerifyCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VerifyCubit, VerifyStates>(
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
            cubit.verify();
          },
          btnColor: AppColors.mainColor,
        );
      },
    );
  }
}
