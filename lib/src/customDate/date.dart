
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_component/shared_component.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../components/toast.dart';

class CustomDate extends StatefulWidget {
   CustomDate({
    Key? key,
    this.textController,
    this.onTap,
    this.onChanged,
    this.validator,
    this.enabled,
    this.readyOnly,
    this.hintText,
    this.labelText,
    this.borderRadius,
    this.focusBorder,
    this.textTypeInput,
    this.formatInputs,
    this.textArea = false,
    this.autoFillHints,
    this.maxLength,
     this.autoValidate = false,
    this.showDateIcon = false,
    this.filled = false,
     this.flowTop = false,
     this.isDateRange = false,
     required this.onSelected,
     this.disableFuture = false,
     this.disablePast = false,
   }) : super(key: key);
  final TextEditingController? textController;
  bool? obscure;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? enabled;
  final bool? readyOnly;
  final String? hintText;
  final String? labelText;
  final double? borderRadius;
  final double? focusBorder;
  final TextInputType? textTypeInput;
  final List<TextInputFormatter>? formatInputs;
  final bool? textArea;
  final List<String>? autoFillHints;
  final int? maxLength;
  final bool autoValidate;
  final bool showDateIcon;
  final bool filled;
  final bool flowTop;
  final bool isDateRange;
  final bool disableFuture;
  final bool disablePast;
  final Function(String) onSelected;


  @override
  _CustomDateState createState() => _CustomDateState();
}

class _CustomDateState extends State<CustomDate> {
  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';
  late OverlayEntry _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool sourceFocused = false;
  final FocusNode _focus = FocusNode();
  late double height;
  DateRangePickerController controller = DateRangePickerController();
  @override
  void initState() {
    _focus.addListener(() {
      setState(() {
        sourceFocused = _focus.hasFocus;
      });
      if(sourceFocused){
        _overlayEntry = _createOverlay();
        Overlay.of(context)!.insert(_overlayEntry);
      }else{
        _overlayEntry.remove();
      }
    });

    super.initState();
  }
  OverlayEntry _createOverlay() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    final FocusScopeNode scopeNode = FocusScope.of(context);
    return OverlayEntry(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: (){
            FocusScopeNode scopeNode = FocusScope.of(context);

            if(scopeNode.hasFocus) scopeNode.unfocus();
          },
          child: Stack(
            children: [
              Positioned(
                left: offset.dx,
                width: size.width,
                height: 300,
                child: CompositedTransformFollower(
                    offset: Offset(0,size.height),
                    showWhenUnlinked: true,
                    followerAnchor: widget.flowTop ? Alignment.bottomLeft : Alignment.topLeft,
                    // targetAnchor: Alignment.topCenter,
                    link: _layerLink,
                    child: Card(
                      elevation: 5,
                      color: Theme.of(context).cardColor,
                      child: SfDateRangePicker(
                        // showActionButtons: true,
                        showNavigationArrow: true,
                        onCancel: (){
                          setState(() {
                            _range = '';
                            _selectedDate = '';
                            _rangeCount = '';
                            _dateCount = '';
                          });
                          scopeNode.unfocus();
                        },
                        onSubmit: (data){
                          if(widget.isDateRange){
                            if(_range.isEmpty){
                              Toast.error('Date ${widget.isDateRange ? 'Range' : ''} is not Selected');
                            }else{
                              scopeNode.unfocus();
                            }
                          }else{
                            if(_selectedDate.isEmpty){
                              Toast.error('Date ${widget.isDateRange ? 'Range' : ''} is not Selected');
                            }else{
                              scopeNode.unfocus();
                            }
                          }

                        },
                        // cancelText: 'Cancel',
                        // confirmText: 'Ok',
                        // enablePastDates: false,
                        maxDate: widget.disableFuture ? DateTime.now() : null,
                        minDate: widget.disablePast ? DateTime.now(): null,
                        controller: controller,
                        onSelectionChanged: onSelectionChanged,
                        selectionMode: widget.isDateRange ? DateRangePickerSelectionMode.range : DateRangePickerSelectionMode.single,
                        initialSelectedRange: PickerDateRange(
                          DateTime.now(),
                          DateTime.now(),
                        ),
                      ),
                    ))),
              
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height/ 2.5;
    return CompositedTransformTarget(
      link: _layerLink,
      child: CustomTextField(
        isDate: true,
        hintText: widget.hintText ?? '',
        focusNode: _focus,
        // autovalidateMode: widget.autoValidate ?  AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        // autofillHints: widget.autoFillHints ?? null,
        // maxLength: widget.maxLength ?? null,
        controller: widget.textController ?? TextEditingController(),
        inputFormatters: widget.formatInputs ?? <TextInputFormatter>[
          FilteringTextInputFormatter.singleLineFormatter
        ],
        // obscureText: widget.obscure == null ? false : widget.obscure!,
        onTap: widget.onTap ?? () {
          setState(() {
            sourceFocused = true;
          });
        },
        onChanged: widget.onChanged ?? (value) {},
        // textInputAction: TextInputAction.next,
        enabled: widget.enabled ?? true,
        // readOnly: widget.readyOnly == null ? false : widget.readyOnly!,
        validator: widget.validator ?? (value) {},
        keyboardType: widget.textTypeInput ?? TextInputType.text,
        // minLines: 1,
        // maxLines: widget.textArea! ? 5 : 1,
      ),
    );
  }

  onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final FocusScopeNode scopeNode = FocusScope.of(context);
    setState(() {
      if (args.value is PickerDateRange) {
        _range =
            '${DateFormat('yyy-MM-dd').format(args.value.startDate)} -- ${DateFormat('yyy-MM-dd')
                    .format(args.value.endDate ?? args.value.startDate)}';
        widget.onSelected(_range);
        widget.textController!.text = _range;
      } else if (args.value is DateTime) {
        _selectedDate = DateFormat('yyy-MM-dd').format(args.value).toString();
        widget.onSelected(_selectedDate);
        widget.textController!.text = _selectedDate;
        if(sourceFocused) scopeNode.unfocus();
      } else if (args.value is List<DateTime>) {
        _dateCount = args.value.lenght.toString();
        widget.onSelected(_dateCount);
        widget.textController!.text = _dateCount;
      } else {
        _rangeCount = args.value.length.toString();
        widget.onSelected(_rangeCount);
        widget.textController!.text = _rangeCount;
      }
    });
  }
}
