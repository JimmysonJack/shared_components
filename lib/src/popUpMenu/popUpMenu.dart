// import 'package:flutter/material.dart';
//
// import 'custom_pop_up_menu.dart';
//
// class PopUpMenu extends StatefulWidget {
//   const PopUpMenu(
//       {Key? key,
//       required this.iconsAndLabels,
//       required this.icon,
//       required this.onPressed})
//       : super(key: key);
//   final List<Map<String, dynamic>> iconsAndLabels;
//   final IconData icon;
//   final Function(int) onPressed;
//
//   @override
//   _PopUpMenuState createState() => _PopUpMenuState();
// }
//
// class _PopUpMenuState extends State<PopUpMenu> {
//   CustomPopupMenuController _controller = CustomPopupMenuController();
//   @override
//   Widget build(BuildContext context) {
//     return CustomPopupMenu(
//       pressType: PressType.singleClick,
//       controller: _controller,
//       child: Material(
//         elevation: 10,
//         color: Colors.blueGrey,
//         type: MaterialType.circle,
//         child: Container(
//           alignment: Alignment.center,
//           height: 30,
//           width: 30,
//           child: Icon(
//             widget.icon,
//             size: 15,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       menuBuilder: () {
//         return ClipRRect(
//           borderRadius: BorderRadius.circular(10),
//           child: Container(
//             decoration: BoxDecoration(
//                 // color: PRIMARY_COLOR.withOpacity(1),
//                 gradient: LinearGradient(
//               colors: [Colors.blueGrey,Colors.black],
//               begin: Alignment.topRight,
//               end: Alignment.bottomLeft,
//               tileMode: TileMode.decal,
//             )),
//             child: IntrinsicWidth(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: List.generate(
//                     widget.iconsAndLabels.length,
//                     (index) => GestureDetector(
//                           behavior: HitTestBehavior.translucent,
//                           onTap: _controller.hideMenu,
//                           child: Material(
//                             color: Colors.transparent,
//                             child: InkWell(
//                               onTap: () {
//                                 widget.onPressed(index);
//                                 if (_controller.menuIsShowing) {
//                                   _controller.hideMenu();
//                                 }
//                               },
//                               child: Container(
//                                 height: 40,
//                                 padding: EdgeInsets.symmetric(horizontal: 20),
//                                 child: Row(
//                                   children: [
//                                     Icon(
//                                       widget.iconsAndLabels[index][widget
//                                           .iconsAndLabels[index].keys.first],
//                                       size: 15,
//                                       color: Colors.white,
//                                     ),
//                                     Expanded(
//                                         child: Container(
//                                       margin: EdgeInsets.only(left: 10),
//                                       padding:
//                                           EdgeInsets.symmetric(vertical: 10),
//                                       child: Text(
//                                         widget.iconsAndLabels[index][widget
//                                             .iconsAndLabels[index].keys
//                                             .toList()[1]],
//                                         style: TextStyle(
//                                             color: Colors.white, fontSize: 12),
//                                       ),
//                                     ))
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         )),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
