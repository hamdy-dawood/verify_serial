import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:verify_serial/core/helpers/navigator.dart';
import 'package:verify_serial/features/check/states.dart';

import '../../core/theming/colors.dart';
import '../../core/widgets/custom_text.dart';
import 'cubit.dart';

class BarcodeScannerScreen extends StatefulWidget {
  final BuildContext oldContext;

  const BarcodeScannerScreen({
    super.key,
    required this.oldContext,
  });

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  final key = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;

  @override
  void initState() {
    isScanning = true;
    super.initState();
  }

  @override
  void dispose() {
    isScanning = false;
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.oldContext.read<CheckCubit>(),
      child: buildQrView(widget.oldContext),
    );
  }

  BlocBuilder buildQrView(BuildContext cubitContext) =>
      BlocBuilder<CheckCubit, CheckStates>(
        builder: (context, state) {
          var cubit = CheckCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              titleSpacing: 0,
              title: CustomText(
                text: "فحص الباركود",
                color: AppColors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            key: cubit.scannerScaffoldKey,
            body: QRView(
              key: key,
              onQRViewCreated: (QRViewController controller) {
                setState(() {
                  this.controller = controller;
                });
                controller.scannedDataStream.listen(
                  (barcode) {
                    if (barcode.code != null && isScanning) {
                      debugPrint("coodee: ${barcode.code}");
                      MagicRouter.navigatePop();
                      cubit.barcodeController.text = "${barcode.code}";
                      isScanning = false;
                    }
                  },
                );
              },
              overlay: QrScannerOverlayShape(
                borderWidth: 10,
                borderLength: 20,
                borderRadius: 10,
                cutOutHeight: 200,
                cutOutWidth: 320,
                borderColor: AppColors.mainColor,
              ),
            ),
          );
        },
      );
}
