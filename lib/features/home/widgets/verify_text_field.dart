import 'package:flutter/material.dart';

import '../../../core/theming/colors.dart';
import '../../../core/widgets/custom_text_form_field.dart';
import '../../scanner/view.dart';
import '../cubit.dart';

class VerifyTextField extends StatelessWidget {
  const VerifyTextField({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return CustomTextFormField(
      controller: cubit.fieldController,
      hint: "كود التفعيل",
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
            cubit.fieldController.text = result;
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
