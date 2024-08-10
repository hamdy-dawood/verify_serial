import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/theming/colors.dart';
import '../../core/widgets/custom_elevated.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../core/widgets/default_flushbar.dart';
import '../scanner/view.dart';
import 'cubit.dart';
import 'states.dart';

class CheckView extends StatelessWidget {
  const CheckView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CheckCubit(),
      child: const _CheckBody(),
    );
  }
}

class _CheckBody extends StatelessWidget {
  const _CheckBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<CheckCubit>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        title: CustomText(
          text: "فحص الباركود",
          color: AppColors.black,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.15.sh),
              Center(
                child: CustomText(
                  text: "فحص الباركود",
                  color: AppColors.mainColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 0.03.sh),
              BlocBuilder<CheckCubit, CheckStates>(
                builder: (context, state) {
                  return _BarCodeTextField(cubit: cubit);
                },
              ),
              SizedBox(height: 0.1.sh),
              _CheckButton(
                cubit: cubit,
              ),
              SizedBox(height: 0.1.sh),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarCodeTextField extends StatelessWidget {
  const _BarCodeTextField({required this.cubit});

  final CheckCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.barcodeController,
      hint: "الباركود...",
      validator: (value) {
        return null;
      },
      isLastInput: true,
      suffixIcon: IconButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BarcodeScannerScreen(),
            ),
          );

          if (result != null) {
            cubit.barcodeController.text = result;
          }
        },
        icon: Icon(
          Icons.barcode_reader,
          color: AppColors.black,
        ),
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({
    required this.cubit,
  });

  final CheckCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CheckCubit, CheckStates>(
      listener: (context, state) {
        if (state is CheckFailedState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redPrimary,
            messageText: state.msg,
          );
        } else if (state is NetworkErrorState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redPrimary,
            messageText: "افحص الانترنت",
          );
        } else if (state is CheckApprovedState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.green,
            icon: Icon(
              Icons.check,
              color: AppColors.white,
            ),
            messageText: "السيريال مؤكد",
          );
        } else if (state is CheckFailedApprovedState) {
          showDefaultFlushBar(
            context: context,
            color: AppColors.redPrimary,
            messageText: "السيريال غير مؤكد",
          );
        }
      },
      builder: (context, state) {
        if (state is CheckLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
          );
        }
        return CustomElevated(
          text: "فحص",
          press: () {
            if (cubit.barcodeController.text.isNotEmpty) {
              cubit.check();
            } else {
              showDefaultFlushBar(
                context: context,
                color: AppColors.redPrimary,
                messageText: "من فصلك ادخل السيريال !",
              );
            }
          },
          btnColor: AppColors.mainColor,
        );
      },
    );
  }
}
