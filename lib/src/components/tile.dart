import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_component/shared_component.dart';

typedef HoverCallBack = void Function(String);

class Tile extends StatefulWidget {
  Tile({Key? key, required this.url, required this.title, required this.icon}) : super(key: key);
  String title;
  String icon;
  String url;
  @override
  _TileState createState() => _TileState();

  static String? libraryName;
}

class _TileState extends State<Tile> {
  bool hovering = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 7;
    width = width < 300 ? 300 : width;

    return SizedBox(
      width:  width ,
      height: width * 0.6,
      child: Center(
        child: InkWell(
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onHover: (value) {
            setState(() {
              hovering = value;
            });
          },
          onTap: () => Modular.to.navigate(widget.url),

          child: AnimatedContainer(
            width: hovering ? width * 0.9 : width ,
            height: hovering ? width * 0.5 :width * 0.6,
            duration: const Duration(milliseconds: 200),
            child: Card(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: SvgPicture.asset(
                        'assets/images/svg/${widget.icon}.svg',
                        width: width,
                        color: Theme.of(context).backgroundColor,
                        package: Tile.libraryName,
                      ),
                    ),
                  ),
                  Container(
                    width: width,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                        color: Color(0x30000000),
                        borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(3))),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                          fontSize: 20, color: Theme.of(context).backgroundColor),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
