import 'package:ai_touristic_info_tool/constants.dart';
import 'package:ai_touristic_info_tool/reusable_widgets/process_container_widget.dart';
import 'package:ai_touristic_info_tool/state_management/model_error_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showStreamingDialog(BuildContext context, String query) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          backgroundColor: FontAppColors.secondaryFont,
          shadowColor: FontAppColors.secondaryFont,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          // insetPadding: EdgeInsets.zero,
          iconPadding: EdgeInsets.zero,
          titlePadding: const EdgeInsets.only(bottom: 20),
          contentPadding: EdgeInsets.zero,
          actionsPadding: const EdgeInsets.only(bottom: 10),
          surfaceTintColor: FontAppColors.secondaryFont,
          title: Consumer<ModelErrorProvider>(builder:
              (BuildContext context, ModelErrorProvider value, Widget? child) {
            return Center(
              child: Text(!value.isError ? 'Processing ...' : 'Error !',
                  style: TextStyle(
                    color: !value.isError
                        ? FontAppColors.primaryFont
                        : LgAppColors.lgColor2,
                    fontSize: headingSize,
                    fontWeight: FontWeight.bold,
                    fontFamily: fontType,
                  )),
            );
          }),
          content: ProcessContainerWidget(
            query: query,
          ));
    },
  );
}
