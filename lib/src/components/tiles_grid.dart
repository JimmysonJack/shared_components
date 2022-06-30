
import 'package:flutter/material.dart';

import '../languages/intl.dart';
import '../models/tile_model.dart';
import 'tile.dart';

class TilesGrid extends StatefulWidget {
  const TilesGrid({Key? key, required this.tiles}): super(key: key);

  final List<TileModel> tiles;
  @override
  _TilesGridState createState() => _TilesGridState();
}

class _TilesGridState extends State<TilesGrid> {
  List<TileModel> visibleTiles = [];
  TextEditingController searchController = TextEditingController();
  String? lang;

  @override
  Widget build(BuildContext context) {
    lang = '';
    double w = MediaQuery.of(context).size.width;
    w = w > 800 ? 0.7 * w : 0.5 * w;
    List<TileModel> t =
        searchController.text.isNotEmpty ? visibleTiles : widget.tiles;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: w > 800 ? 0.15 * w : 0.05 * w, vertical: 16),
      alignment: Alignment.center,
      child: Column(children: [
        Container(
            width: 0.6 * w,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: Intl.trans('search tile', lang!)),
              onChanged: (title) => search(title),
            )),
        Expanded(
          child: ListView(
            children: [
              Wrap(
                alignment: WrapAlignment.center,
                children: t
                    .map((tile) => Tile(
                        url: tile.url,
                        title: Intl.trans(tile.title, lang!),
                        icon: tile.icon))
                    .cast<Widget>().toList(),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void search(String tile) async {
    if (tile.isNotEmpty) {
      List<TileModel> t = [];
      for (var i = 0; i < widget.tiles.length; i++) {
        if (Intl.trans(widget.tiles[i].title, lang!)
            .toLowerCase()
            .contains(tile.toLowerCase())) t.add(widget.tiles[i]);
      }
      setState(() {
        visibleTiles = t;
      });
    } else {
      setState(() {
        visibleTiles = widget.tiles;
      });
    }
  }
}
