import 'package:flutter/material.dart';

const double borderRadius = 25.0;

class CustomSwitchState extends StatefulWidget {
  const CustomSwitchState({Key? key,  this.size = 0.4, required this.widgets,this.onSelected}) : super(key: key);
  final double size;
  final List<CustomSwitchWidgets> widgets;
  final Function(String value)? onSelected;

  @override
  _CustomSwitchStateState createState() => _CustomSwitchStateState();
}

class _CustomSwitchStateState extends State<CustomSwitchState> with SingleTickerProviderStateMixin {

  late PageController _pageController;
  int activePageIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: SizedBox(
              height: MediaQuery.of(context).size.height * widget.size,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0,bottom: 10),
                    child: _menuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      padEnds: true,
                      onPageChanged: (int i) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        setState(() {
                          activePageIndex = i;
                        });
                      },
                      children: <Widget>[
                        ...widget.widgets.map((e) => e.page).toList()
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _menuBar(BuildContext context) {
    if(widget.onSelected != null){
      widget.onSelected!(widget.widgets.elementAt(activePageIndex).title);
    }
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: const BoxDecoration(
        color: Color(0XFFE0E0E0),
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ...List.generate(widget.widgets.length, (index) => Expanded(
            child: InkWell(
              borderRadius: const BorderRadius.all(Radius.circular(0)),
              onTap: (){
                _onPlaceBidButtonPress(index);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                decoration: (activePageIndex == index) ?  BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                ) : null,
                child: Text(
                  widget.widgets.elementAt(index).title,
                  style: (activePageIndex == index) ? const TextStyle(color: Colors.white) : const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),),
        ],
      ),
    );
  }

  void _onPlaceBidButtonPress(index) {
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }


}

class CustomSwitchWidgets{
  final String title;
  final Widget page;
  CustomSwitchWidgets( {required this.title,required this.page,});
}