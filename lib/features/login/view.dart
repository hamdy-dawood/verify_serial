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
import '../check/barcode_scanner_screen.dart';
import '../check/view.dart';
import 'cubit.dart';
import 'states.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const _LoginBody(),
    );
  }
}

class _LoginBody extends StatelessWidget {
  const _LoginBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Form(
        key: cubit.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 0.3.sh),
                CustomText(
                  text: "تسجيل الدخول",
                  color: AppColors.black,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 0.03.sh),
                BlocBuilder<LoginCubit, LoginStates>(
                  builder: (context, state) {
                    return _UsernameTextField(cubit: cubit);
                  },
                ),
                SizedBox(height: 0.02.sh),
                BlocBuilder<LoginCubit, LoginStates>(
                  builder: (context, state) {
                    return _PasswordTextField(cubit: cubit);
                  },
                ),
                SizedBox(height: 0.06.sh),
                _LoginButton(
                  cubit: cubit,
                ),
                SizedBox(height: 0.02.sh),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      MagicRouter.navigateTo(
                        page: const CheckView(),
                      );
                    },
                    child: CustomText(
                      text: "فحص الباركود",
                      color: AppColors.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      textDecoration: TextDecoration.underline,
                    ),
                  ),
                ),
                SizedBox(height: 0.1.sh),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  const _UsernameTextField({required this.cubit});

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.usernameController,
      hint: "اسم المستخدم...",
      validator: (value) {
        if (value!.isEmpty) {
          return "أدخل اسم المستخدم !";
        }
        return null;
      },
    );
  }
}

class _PasswordTextField extends StatelessWidget {
  const _PasswordTextField({required this.cubit});

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.controllers.passwordController,
      hint: "كلمة السر...",
      validator: (value) {
        if (value!.isEmpty) {
          return "أدخل كلمة السر !";
        }
        return null;
      },
      suffixIcon: SizedBox(
        height: 0.02.sh,
        child: GestureDetector(
          onTap: () {
            cubit.changeVisibility();
          },
          child: Icon(
            cubit.isObscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.grey3,
          ),
        ),
      ),
      obscureText: cubit.isObscure,
      interactiveSelection: false,
      isLastInput: true,
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton({
    required this.cubit,
  });

  final LoginCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginStates>(
      listener: (context, state) {
        if (state is LoginFailedState) {
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
        } else if (state is LoginSuccessState) {
          return MagicRouter.navigateTo(
            page: const HomeView(),
            withHistory: false,
          );
        }
      },
      builder: (context, state) {
        if (state is LoginLoadingState) {
          return Center(
            child: CircularProgressIndicator(
              color: AppColors.mainColor,
            ),
          );
        }
        return CustomElevated(
          text: "تسجيل",
          press: () {
            cubit.login();
          },
          btnColor: AppColors.mainColor,
        );
      },
    );
  }
}
