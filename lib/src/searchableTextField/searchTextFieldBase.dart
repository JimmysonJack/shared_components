import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SuggestionState {
  /// always show suggestions
  enabled,

  /// hide the suggestions on initial focus
  hidden,

  /// show suggestions only on tap
  onTap,
}

// enum to define the Focus of the searchfield when a suggestion is tapped
enum SuggestionAction {
  /// shift to next focus
  next,

  /// close keyboard and unfocus
  unfocus,
}

// ignore: must_be_immutable
class SearchField<T> extends StatefulWidget {
  /// Data source to perform search.
  List<Map<String, dynamic>>? suggestions;

  /// Callback to return the selected suggestion.
  final Function(Map<String, dynamic>?) onTap;

  /// Hint for the [SearchField].
  final String? hint;

  /// Define a [TextInputAction] that is called when the field is submitted
  final TextInputAction? textInputAction;

  /// The initial value to be selected for [SearchField]. The value
  /// must be present in [suggestions].
  ///
  /// When not specified, [hint] is shown instead of `initialValue`.
  final Map<String, dynamic>? initialValue;

  /// Specifies [TextStyle] for search input.
  final TextStyle? searchStyle;

  /// Specifies [TextStyle] for suggestions.
  final TextStyle? suggestionStyle;

  /// Specifies [InputDecoration] for search input [TextField].
  ///
  /// When not specified, the default value is [InputDecoration] initialized
  /// with [hint].
  final InputDecoration? searchInputDecoration;

  /// defaults to SuggestionState.hidden
  final SuggestionState suggestionState;

  /// Specifies the [SuggestionAction] called on suggestion tap.
  final SuggestionAction? suggestionAction;

  /// Specifies [BoxDecoration] for suggestion list. The property can be used to add [BoxShadow],
  /// and much more. For more information, checkout [BoxDecoration].
  ///
  /// Default value,
  ///
  /// ```dart
  /// BoxDecoration(
  ///   color: Theme.of(context).colorScheme.surface,
  ///   boxShadow: [
  ///     BoxShadow(
  ///       color: onSurfaceColor.withOpacity(0.1),
  ///       blurRadius: 8.0, // soften the shadow
  ///       spreadRadius: 2.0, //extend the shadow
  ///       offset: Offset(
  ///         2.0,
  ///         5.0,
  ///       ),
  ///     ),
  ///   ],
  /// )
  /// ```
  final BoxDecoration? suggestionsDecoration;

  /// Specifies [BoxDecoration] for items in suggestion list. The property can be used to add [BoxShadow],
  /// and much more. For more information, checkout [BoxDecoration].
  ///
  /// Default value,
  ///
  /// ```dart
  /// BoxDecoration(
  ///   border: Border(
  ///     bottom: BorderSide(
  ///       color: widget.marginColor ??
  ///         onSurfaceColor.withOpacity(0.1),
  ///     ),
  ///   ),
  /// )
  final BoxDecoration? suggestionItemDecoration;

  /// Specifies height for item suggestion.
  ///
  /// When not specified, the default value is `35.0`.
  final double itemHeight;

  /// Specifies the color of margin between items in suggestions list.
  ///
  /// When not specified, the default value is `Theme.of(context).colorScheme.onSurface.withOpacity(0.1)`.
  final Color? marginColor;

  /// Specifies the number of suggestions that can be shown in viewport.
  ///
  /// When not specified, the default value is `5`.
  /// if the number of suggestions is less than 5, then [maxSuggestionsInViewPort]
  /// will be the length of [suggestions]
  final int maxSuggestionsInViewPort;

  /// Specifies the `TextEditingController` for [SearchField].
  final TextEditingController? controller;

  /// `validator` for the [SearchField]
  /// to make use of this validator, The
  /// SearchField widget needs to be wrapped in a Form
  /// and pass it a Global key
  /// and write your validation logic in the validator
  /// you can define a global key
  ///
  ///  ```
  ///  Form(
  ///   key: _formKey,
  ///   child: SearchField(
  ///     suggestions: _statesOfIndia,
  ///     validator: (state) {
  ///       if (!_statesOfIndia.contains(state) || state.isEmpty) {
  ///         return 'Please Enter a valid State';
  ///       }
  ///       return null;
  ///     },
  ///   )
  /// ```
  /// You can then validate the form by calling
  /// the validate function of the form
  ///
  /// `_formKey.currentState.validate();`
  ///
  ///
  ///
  final String? Function(String?) validator;

  /// if false the suggestions will be shown below
  /// the searchfield along the Y-axis.
  /// if true the suggestions will be shown floating like the
  /// along the Z-axis
  /// defaults to ```true```
  final bool hasOverlay;

  final String? subTitleKey;

  final String? titleKey;

  final String? objectTitleKey;

  final String? subObjectTitleKey;

  final Function(String) onChange;

  final bool isNetworkData;
  final bool enabled;

  final bool isChipInputs;

  final String? updateEntry;

  final List<Map<String, dynamic>> chipList;

  final Future<List<Map<String, dynamic>>> Function(String) findFn;

  SearchField({
    Key? key,
    this.suggestions,
    required this.chipList,
    this.updateEntry,
    this.isChipInputs = false,
    this.initialValue,
    this.hint,
    this.hasOverlay = true,
    this.searchStyle,
    this.marginColor,
    this.controller,
    required this.validator,
    this.suggestionState = SuggestionState.hidden,
    this.itemHeight = 35.0,
    this.suggestionsDecoration,
    this.suggestionStyle,
    this.searchInputDecoration,
    this.suggestionItemDecoration,
    this.maxSuggestionsInViewPort = 5,
    required this.onTap,
    this.textInputAction,
    this.suggestionAction,
    this.subTitleKey,
    this.titleKey,
    required this.onChange,
    this.isNetworkData = false,
    required this.findFn,
    this.enabled = true,
    this.objectTitleKey,
    this.subObjectTitleKey,
  }) : super(key: key);

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final StreamController<List<Map<String, dynamic>>?> sourceStream =
      StreamController<List<Map<String, dynamic>>?>.broadcast();
  final FocusNode _focus = FocusNode();

  bool sourceFocused = false;
  TextEditingController? sourceController;

  @override
  void dispose() {
    _focus.dispose();
    sourceStream.close();
    super.dispose();
  }

  void initialize() {
    widget.controller?.text = widget.updateEntry ?? '';
    _focus.addListener(() {
      setState(() {
        Future.delayed(Duration.zero, () async {
          if (widget.isNetworkData) {
            sourceStream.sink.add(await widget.findFn(widget.controller!.text));
          } else {
            widget.suggestions = await widget.findFn(widget.controller!.text);
            sourceStream.sink.add(widget.suggestions);
          }
        });

        sourceFocused = _focus.hasFocus;
      });
      if (widget.hasOverlay) {
        if (sourceFocused) {
          if (widget.initialValue == null) {
            if (widget.suggestionState == SuggestionState.enabled) {
              Future.delayed(const Duration(milliseconds: 100), () {
                if (widget.suggestions != []) {
                  sourceStream.sink.add(widget.suggestions);
                }
              });
            }
          }
          _overlayEntry = _createOverlay();
          Overlay.of(context).insert(_overlayEntry);
        } else {
          _overlayEntry.remove();
        }
      } else if (sourceFocused) {
        if (widget.initialValue == null) {
          if (widget.suggestionState == SuggestionState.enabled) {
            Future.delayed(const Duration(milliseconds: 100), () {
              if (widget.suggestions != []) {
                sourceStream.sink.add(widget.suggestions);
              }
            });
          }
        }
      }
    });
  }

  late OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    sourceController = widget.controller ?? TextEditingController();
    widget.validator(widget.updateEntry);

    initialize();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialValue == null || widget.initialValue!.isEmpty) {
        sourceStream.sink.add(null);
      } else {
        sourceController!.text = widget.initialValue?[widget.titleKey]!;
        sourceStream.sink.add([widget.initialValue!]);
      }
    });
  }

  @override
  void didUpdateWidget(covariant SearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      sourceController = widget.controller ?? TextEditingController();
    }
    if (oldWidget.hasOverlay != widget.hasOverlay) {
      if (widget.hasOverlay) {
        initialize();
      } else {
        if (_overlayEntry.mounted) {
          _overlayEntry.remove();
        }
      }
      setState(() {});
    }
  }

  Widget _suggestionsBuilder({Size? size}) {
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return StreamBuilder<List<Map<String, dynamic>?>?>(
      stream: sourceStream.stream,
      builder: (BuildContext context,
          AsyncSnapshot<List<Map<String, dynamic>?>?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Material(
            color: Colors.white,
            elevation: 3,
            child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: const Center(
                    child: SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                          strokeWidth: 1,
                          backgroundColor: Colors.black12,
                        )))),
          );
        } else if (snapshot.data == null ||
            snapshot.data!.isEmpty ||
            !sourceFocused) {
          return Material(
            color: Colors.white,
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No records found!',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          );
        } else {
          if (snapshot.data!.length > widget.maxSuggestionsInViewPort) {
            height = size!.height * widget.maxSuggestionsInViewPort;
          } else if (snapshot.data!.length == 1) {
            height = size!.height;
          } else {
            height = snapshot.data!.length * size!.height;
          }
          return AnimatedContainer(
            duration: isUp ? Duration.zero : const Duration(milliseconds: 300),
            height: height,
            // alignment: Alignment.centerLeft,
            decoration: widget.suggestionsDecoration ??
                BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: onSurfaceColor.withOpacity(0.1),
                      blurRadius: 8.0, // soften the shadow
                      spreadRadius: 2.0, // extend the shadow
                      offset: widget.hasOverlay
                          ? const Offset(
                              2.0,
                              5.0,
                            )
                          : const Offset(1.0, 0.5),
                    ),
                  ],
                ),
            child: ListView.builder(
              controller: ScrollController(),
              reverse: isUp,
              padding: EdgeInsets.zero,
              itemCount: snapshot.data!.length,
              physics: snapshot.data!.length == 1
                  ? const NeverScrollableScrollPhysics()
                  : const ScrollPhysics(),
              itemBuilder: (context, index) => Material(
                elevation: 4,
                child: InkWell(
                  onTap: () {
                    // snapshot.data?.elementAt(index)?.map((key, value) {
                    //   widget.chipList.add({key:value});
                    //   return MapEntry(key, value);
                    // });
                    sourceController!.text = widget.isChipInputs
                        ? ''
                        : snapshot.data![index]?[widget.titleKey]!;
                    sourceController!.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: sourceController!.text.length,
                      ),
                    );

                    // suggestion action
                    if (widget.suggestionAction != null) {
                      if (widget.suggestionAction == SuggestionAction.next) {
                        _focus.nextFocus();
                      } else if (widget.suggestionAction ==
                          SuggestionAction.unfocus) {
                        _focus.unfocus();
                      }
                    }

                    // hide the suggestions
                    sourceStream.sink.add(null);
                    widget.onTap(snapshot.data![index]);
                    widget.validator(widget.updateEntry);
                  },
                  child: Container(
                    height: size.height,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.objectTitleKey != null
                              ? snapshot.data![index]![widget.titleKey]
                                  [widget.objectTitleKey]
                              : snapshot.data![index]?[widget.titleKey],
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleSmall!.color,
                              fontSize: 12,
                              fontWeight: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontWeight,
                              fontStyle: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .fontStyle),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        widget.subTitleKey == null
                            ? Container()
                            : Text(
                                widget.subObjectTitleKey != null
                                    ? snapshot.data![index]![widget.subTitleKey]
                                        [widget.subObjectTitleKey]
                                    : snapshot.data![index]
                                        ?[widget.subTitleKey],
                                style: Theme.of(context).textTheme.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Offset getYOffset(Offset widgetOffset, int resultCount) {
    final size = MediaQuery.of(context).size;
    final position = widgetOffset.dy;
    if ((position + height) < (size.height - widget.itemHeight * 2)) {
      return Offset(0, widget.itemHeight + 10.0);
    } else {
      if (resultCount > widget.maxSuggestionsInViewPort) {
        isUp = false;
        return Offset(
            0, -(widget.itemHeight * widget.maxSuggestionsInViewPort));
      } else {
        isUp = true;
        return Offset(0, -(widget.itemHeight * resultCount));
      }
    }
  }

  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScopeNode scopeNode = FocusScope.of(context);
                if (sourceFocused) {
                  widget.controller?.clear();
                  sourceController?.clear();
                }

                if (scopeNode.hasFocus) scopeNode.unfocus();
              },
              child: StreamBuilder<List<Map<String, dynamic>?>?>(
                  stream: sourceStream.stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>?>?> snapshot) {
                    late var count = widget.maxSuggestionsInViewPort;
                    if (snapshot.data != null) {
                      count = snapshot.data!.length;
                    }
                    return Stack(
                      children: [
                        Positioned(
                          left: offset.dx,
                          width: size.width,
                          child: CompositedTransformFollower(
                              offset: getYOffset(offset, count),
                              link: _layerLink,
                              child: Material(
                                  child: _suggestionsBuilder(size: size))),
                        ),
                      ],
                    );
                  }),
            ));
  }

  final LayerLink _layerLink = LayerLink();
  late double height;
  bool isUp = false;
  @override
  Widget build(BuildContext context) {
    if (widget.suggestions != []) {
      if (widget.suggestions!.length > widget.maxSuggestionsInViewPort) {
        height = widget.itemHeight * widget.maxSuggestionsInViewPort;
      } else {
        height = widget.suggestions!.length * widget.itemHeight;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CompositedTransformTarget(
          link: _layerLink,
          child: Container(
            padding: EdgeInsets.only(
                top: widget.isChipInputs && widget.chipList.isNotEmpty ? 4 : 0),
            color: widget.isChipInputs && widget.chipList.isNotEmpty
                ? Theme.of(context).cardColor
                : Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.isChipInputs && widget.chipList.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: SizedBox(
                      child: Wrap(
                        runSpacing: 5,
                        spacing: 5,
                        children: List.generate(
                            widget.chipList.length,
                            (index) => Chip(
                                  deleteButtonTooltipMessage: 'Remove',
                                  deleteIcon: const Icon(Icons.clear),
                                  onDeleted: () {
                                    setState(() {
                                      widget.chipList.removeWhere((element) {
                                        widget.validator(widget.chipList
                                            .elementAt(index)['uid']);
                                        return element ==
                                            widget.chipList.elementAt(index);
                                      });
                                    });
                                  },
                                  label: Text(widget.chipList
                                      .elementAt(index)[widget.titleKey]),
                                )),
                      ),
                    ),
                  ),
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  enabled: widget.enabled,
                  onTap: () {
                    /// only call that if [SuggestionState.onTap] is selected
                    if (!sourceFocused &&
                        widget.suggestionState == SuggestionState.onTap) {
                      setState(() {
                        sourceFocused = true;
                      });
                      Future.delayed(const Duration(milliseconds: 100), () {
                        if (widget.suggestions != []) {
                          sourceStream.sink.add(widget.suggestions);
                        }
                      });
                    }
                  },
                  controller: widget.controller ?? sourceController,
                  focusNode: _focus,
                  validator: widget.validator,
                  style: widget.searchStyle,
                  textInputAction: widget.textInputAction,
                  decoration: InputDecoration(
                      labelText: widget.hint,
                      filled: true,
                      fillColor: Theme.of(context).cardColor,
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.controller!.text.isNotEmpty
                              ? InkWell(
                                  hoverColor: Colors.transparent,
                                  onTap: () {
                                    widget.onTap({});
                                    widget.controller?.clear();
                                    sourceController?.clear();
                                    widget.validator(widget.updateEntry);
                                  },
                                  child: Icon(
                                    CupertinoIcons.clear_circled_solid,
                                    color: Theme.of(context).disabledColor,
                                  ))
                              : Container(),
                          Container(
                            width: 5,
                          ),
                          const Icon(Icons.arrow_drop_down)
                        ],
                      )),
                  onChanged: (item) async {
                    setState(() {});
                    final searchResult = <Map<String, dynamic>>[];
                    if (widget.isNetworkData) {
                      var obtainedData = await widget.findFn(item);
                      sourceStream.sink.add(obtainedData);
                      widget.onChange(item);
                    } else {
                      if (item.isEmpty) {
                        if (widget.suggestions != []) {
                          sourceStream.sink.add(widget.suggestions);
                        }
                        return;
                      }
                      if (widget.suggestions != []) {
                        for (final suggestion in widget.suggestions!) {
                          if (widget.objectTitleKey == null) {
                            if (suggestion[widget.titleKey]
                                .toLowerCase()
                                .contains(item.toLowerCase())) {
                              searchResult.add(suggestion);
                            }
                          } else {
                            if (suggestion[widget.titleKey]
                                    [widget.objectTitleKey]
                                .toLowerCase()
                                .contains(item.toLowerCase())) {
                              searchResult.add(suggestion);
                            }
                          }
                        }
                      }

                      sourceStream.sink.add(searchResult);
                      widget.onChange(item);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        if (!widget.hasOverlay)
          const SizedBox(
            height: 2,
          ),
        if (!widget.hasOverlay) _suggestionsBuilder()
      ],
    );
  }
}
