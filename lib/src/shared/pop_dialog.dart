import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:shared_component/src/utils/size_config.dart';

class PopDialog {
  static showWidget(
      {required String title,
      required BuildContext context,
      required Widget child,
      VoidCallback? onClose,
      double? modelWidth}) async {
    showAnimatedDialog(
      context: context,
      axis: Axis.vertical,
      alignment: Alignment.center,
      curve: Curves.easeInOutQuart,
      barrierDismissible: false,
      animationType: DialogTransitionType.size,
      duration: const Duration(milliseconds: 800),
      // barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        var buildSize = MediaQuery.of(context).size.width;
        var size = MediaQuery.of(context).size;

        return Container(
          // color: Colors.cyanAccent,
          constraints: BoxConstraints(
              maxHeight: size.height * 0.90, minHeight: size.height * 0.0),
          child: Dialog(
            // backgroundColor: Theme.of(context).disabledColor,
            child: Container(
              color: Theme.of(context).dialogBackgroundColor,
              width: buildSize * (modelWidth ?? 0.5),
              child: Flex(
                direction: Axis.vertical,
                mainAxisSize: MainAxisSize.min,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                children: [
                  ///Dialog [AppBar]
                  AppBar(
                    automaticallyImplyLeading: false,
                    elevation: 0,
                    title: Text(
                      title.toUpperCase(),
                      style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () async {
                            Navigator.pop(context);
                            if (onClose != null) {
                              onClose();
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Icon(Icons.clear),
                          ),
                        ),
                      )
                    ],
                  ),
                  Flexible(fit: FlexFit.loose, child: child)
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static show(
      {required String title,
      required BuildContext context,
      required Widget child,
      VoidCallback? onClose,
      double? modelWidth}) async {
    showAnimatedDialog(
      context: context,
      axis: Axis.vertical,
      alignment: Alignment.center,
      curve: Curves.easeInOutQuart,
      barrierDismissible: false,
      animationType: DialogTransitionType.size,
      duration: const Duration(milliseconds: 800),
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        var buildSize = MediaQuery.of(context).size.width;
        // var size = MediaQuery.of(context).size;

        return LayoutBuilder(
          builder: (context, constraints) {
            double minHeight = 100.0; // Set your desired min height
            double maxHeight = SizeConfig.fullScreen.height *
                0.85; // Set your desired max height

            double containerHeight = constraints.maxHeight;

            if (containerHeight > maxHeight) {
              containerHeight = maxHeight;
            } else if (containerHeight < minHeight) {
              containerHeight = minHeight;
            }

            return Align(
              alignment: Alignment.center,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: minHeight,
                  maxHeight: maxHeight,
                ),
                child: Container(
                  width: buildSize * (modelWidth ?? 0.5),
                  height: containerHeight,
                  color: Theme.of(context).scaffoldBackgroundColor,
                  child: Column(
                    // direction: Axis.vertical,
                    mainAxisSize: MainAxisSize.min,
                    // clipBehavior: Clip.antiAliasWithSaveLayer,
                    children: [
                      ///Dialog [AppBar]
                      AppBar(
                        automaticallyImplyLeading: false,
                        elevation: 0,
                        title: Text(
                          title.toUpperCase(),
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontSize),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(100),
                              onTap: () async {
                                Navigator.pop(context);
                                if (onClose != null) {
                                  onClose();
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5.0),
                                child: Icon(Icons.clear),
                              ),
                            ),
                          )
                        ],
                      ),
                      Flexible(fit: FlexFit.loose, child: child)
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
