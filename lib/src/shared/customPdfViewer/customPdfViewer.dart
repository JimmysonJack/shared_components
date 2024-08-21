import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
// import 'package:printing/printing.dart';
import 'package:shared_component/shared_component.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class CustomPdfViewer extends StatefulWidget {
  const CustomPdfViewer({Key? key, this.documentBytes, this.showAvatar = true})
      : super(key: key);
  final Uint8List? documentBytes;
  final bool showAvatar;

  @override
  // ignore: library_private_types_in_public_api
  _CustomPdfViewerState createState() => _CustomPdfViewerState();
}

class _CustomPdfViewerState extends State<CustomPdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  PdfViewerController pdfViewerController = PdfViewerController();
  TextEditingController searchController = TextEditingController();
  Widget? child;
  int pageCount = 0;
  int pageNumber = 0;
  int levelZoom = 0;
  bool pan = false;
  bool navigation = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.documentBytes != null) {
      child = SfPdfViewer.memory(
        widget.documentBytes!,
        pageLayoutMode: navigation == true
            ? PdfPageLayoutMode.single
            : PdfPageLayoutMode.continuous,
        otherSearchTextHighlightColor: Colors.red,
        onDocumentLoaded: (PdfDocumentLoadedDetails data) {
          pageCount = data.document.pages.count;
          pageNumber = pdfViewerController.pageNumber;
          levelZoom = ((pdfViewerController.zoomLevel * 100) / 3).round();
          setState(() {});
        },
        onPageChanged: (PdfPageChangedDetails data) {
          setState(() {
            pageNumber = data.newPageNumber;
          });
        },
        onDocumentLoadFailed: (err) {
          NotificationService.snackBarError(
              context: context, title: err.description);
        },
        interactionMode: pan == false
            ? PdfInteractionMode.selection
            : PdfInteractionMode.pan,
        enableTextSelection: true,
        enableDocumentLinkAnnotation: true,
        canShowScrollHead: true,
        canShowPaginationDialog: true,
        controller: pdfViewerController,
        // initialZoomLevel: 50,
        canShowScrollStatus: true,
        // initialZoomLevel: 1.5,
        // initialScrollOffset: Offset(0,500),
        enableDoubleTapZooming: true,
        onTextSelectionChanged: (PdfTextSelectionChangedDetails select) {},
        pageSpacing: 10,
        onZoomLevelChanged: (PdfZoomDetails zoom) {
          setState(() {
            levelZoom = ((zoom.newZoomLevel * 100) / 3).round();
          });
        },
        // scrollDirection: PdfScrollDirection.vertical,
        key: _pdfViewerKey,
      );
    }
    return Card(
      color: Colors.black.withOpacity(0.1),
      elevation: 0,
      child: Column(
        children: [
          Material(
            elevation: 5,
            child: SizedBox(
              height: 30,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //TODO SEARCH SHOULD BE IMPLEMENTED HERE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Tooltip(
                        message: 'Scroll Mode',
                        child: InkWell(
                            onTap: () {
                              setState(() {
                                navigation = !navigation;
                              });
                            },
                            child: Text(
                              navigation == true
                                  ? '[ Horizontally ]'
                                  : '[ Vertically ]',
                              style: TextStyle(
                                  color: ThemeController.getInstance().darkMode(
                                      darkColor: Colors.white54,
                                      lightColor: Colors.black54)),
                            )),
                      ),
                    ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    //   child: Tooltip(
                    //     message: 'Rotate',
                    //     child: InkWell(
                    //       borderRadius: BorderRadius.circular(20),
                    //       onTap: () {
                    //         setState(() {
                    //               pdfViewerController.;
                    //             });
                    //       },
                    //       child: Icon(
                    //         Icons.rotate_left,
                    //         color: ThemeController.getInstance().darkMode(
                    //             darkColor: Colors.white54,
                    //             lightColor: Colors.black54),
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    ///NAVIGATION PANEL
                    Container(
                      width: MediaQuery.of(context).size.width / 9,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      height: 25,
                      decoration: BoxDecoration(
                          // color: Colors.black26,
                          border: Border.all(
                              color: ThemeController.getInstance().darkMode(
                                  darkColor: Colors.white54,
                                  lightColor: Colors.black54)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          Tooltip(
                            message: 'Previous Page',
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  pdfViewerController.previousPage();
                                });
                              },
                              child: Icon(
                                CupertinoIcons.chevron_left,
                                size: 17,
                                color: ThemeController.getInstance().darkMode(
                                    darkColor: Colors.white54,
                                    lightColor: Colors.black54),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text(pageNumber.toString()),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              pdfViewerController.nextPage();
                              setState(() {});
                            },
                            child: Tooltip(
                                message: 'Next Page',
                                child: Icon(
                                  CupertinoIcons.chevron_forward,
                                  size: 17,
                                  color: ThemeController.getInstance().darkMode(
                                      darkColor: Colors.white54,
                                      lightColor: Colors.black54),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              children: [
                                Text(
                                  'Pages..',
                                  style: TextStyle(
                                      color: ThemeController.getInstance()
                                          .darkMode(
                                              darkColor: Colors.white54,
                                              lightColor: Colors.black54),
                                      fontSize: 10),
                                ),
                                Text('$pageCount'),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    ///ZOOM PANEL
                    Container(
                      width: MediaQuery.of(context).size.width / 15,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      height: 25,
                      decoration: BoxDecoration(
                          // color: Colors.black26,
                          border: Border.all(
                              color: ThemeController.getInstance().darkMode(
                                  darkColor: Colors.white54,
                                  lightColor: Colors.black54)),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (pdfViewerController.zoomLevel > 0) {
                                  pdfViewerController.zoomLevel =
                                      pdfViewerController.zoomLevel - 0.5;
                                  levelZoom =
                                      ((pdfViewerController.zoomLevel * 100) /
                                              3)
                                          .round();
                                }
                              });
                            },
                            child: Tooltip(
                                message: 'Zoom Out',
                                child: Icon(
                                  CupertinoIcons.minus_circle,
                                  size: 17,
                                  color: ThemeController.getInstance().darkMode(
                                      darkColor: Colors.white54,
                                      lightColor: Colors.black54),
                                )),
                          ),
                          Expanded(
                            child: Container(
                              alignment: Alignment.center,
                              child: Text('${levelZoom.toString()}%'),
                            ),
                          ),
                          Tooltip(
                            message: 'Zoom In',
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  if (pdfViewerController.zoomLevel <= 3) {
                                    pdfViewerController.zoomLevel =
                                        pdfViewerController.zoomLevel + 0.5;
                                    levelZoom =
                                        ((pdfViewerController.zoomLevel * 100) /
                                                3)
                                            .round();
                                  }
                                });
                              },
                              child: Icon(
                                CupertinoIcons.add_circled,
                                size: 17,
                                color: ThemeController.getInstance().darkMode(
                                    darkColor: Colors.white54,
                                    lightColor: Colors.black54),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ///SELECTION MODE
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Tooltip(
                        message: 'Pan',
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              pan = !pan;
                            });
                          },
                          child: Icon(
                            pan
                                ? CupertinoIcons.hand_raised_fill
                                : CupertinoIcons.hand_raised_slash,
                            size: 17,
                            color: ThemeController.getInstance().darkMode(
                                darkColor: Colors.white54,
                                lightColor: Colors.black54),
                          ),
                        ),
                      ),
                    ),

                    ///PRINT
                    widget.documentBytes == null
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Tooltip(
                              message: 'Print',
                              child: InkWell(
                                onTap: () async {
                                  await Printing.layoutPdf(
                                      onLayout: (format) async =>
                                          Future.value(widget.documentBytes));
                                },
                                child: Icon(
                                  CupertinoIcons.printer,
                                  size: 17,
                                  color: ThemeController.getInstance().darkMode(
                                      darkColor: Colors.white54,
                                      lightColor: Colors.black54),
                                ),
                              ),
                            ),
                          ),
                    Tooltip(
                      message: 'Bookmarks',
                      child: InkWell(
                        onTap: () {
                          _pdfViewerKey.currentState?.openBookmarkView();
                        },
                        child: Icon(
                          CupertinoIcons.bookmark,
                          size: 17,
                          color: ThemeController.getInstance().darkMode(
                              darkColor: Colors.white54,
                              lightColor: Colors.black54),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: widget.showAvatar == true
                  ? Center(
                      child: SvgPicture.asset(
                        'assets/pdf-file-icon.svg',
                        package: 'shared_component',
                        width: 50,
                        colorFilter: ColorFilter.mode(
                          ThemeController.getInstance().darkMode(
                              darkColor: Colors.white24,
                              lightColor: Colors.black26),
                          BlendMode.srcATop,
                        ),
                      ),
                    )
                  : child ?? IndicateProgress.circular(),
            ),
          )
        ],
      ),
    );
  }
}
