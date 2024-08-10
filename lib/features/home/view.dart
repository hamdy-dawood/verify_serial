import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:verify_serial/core/widgets/emit_failed_item.dart';

import '../../core/helpers/cache_helper.dart';
import '../../core/helpers/navigator.dart';
import '../../core/theming/colors.dart';
import '../../core/widgets/custom_text.dart';
import '../../core/widgets/dialog.dart';
import '../../core/widgets/emit_network_item.dart';
import '../login/view.dart';
import 'cubit.dart';
import 'states.dart';
import 'widgets/verify_button.dart';
import 'widgets/verify_text_field.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()..profile(),
      child: const _HomeBody(),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<HomeCubit>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: GestureDetector(
              onTap: () {
                alertDialog(
                  context: context,
                  title: "تسجيل خروج",
                  subTitle: "هل انت متأكد من تسجيل الخروج؟",
                  yesPress: () {
                    CacheHelper.removeData(key: "access_token");
                    CacheHelper.removeData(key: "id");
                    CacheHelper.removeData(key: "user_name");
                    MagicRouter.navigateTo(
                      page: const LoginView(),
                      withHistory: false,
                    );
                  },
                );
              },
              child: CustomText(
                text: "خروج",
                color: AppColors.mainColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<HomeCubit, HomeStates>(
        builder: (context, state) {
          if (state is ProfileLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          } else if (state is ProfileFailedState) {
            return EmitFailedItem(text: state.msg);
          } else if (state is NetworkErrorState) {
            return const EmitNetworkItem();
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: SizedBox(
              width: 1.sw,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 0.1.sh),
                    CustomText(
                      text: "مرحبا بك ${CacheHelper.get(key: "user_name")}",
                      color: AppColors.mainColor,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                    ),
                    SizedBox(height: 0.1.sh),
                    BlocBuilder<HomeCubit, HomeStates>(
                      builder: (context, state) {
                        return VerifyTextField(cubit: cubit);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.all(20.h),
        child: VerifyButton(cubit: cubit),
      ),
    );
  }
}
