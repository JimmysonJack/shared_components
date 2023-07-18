import 'package:flutter/material.dart';

/// Create a grid.
class GGrid extends StatelessWidget {
  const GGrid({
    Key? key,
    this.columnCount = 2,
    this.gap,
    this.padding,
    required this.children,
  }) : super(key: key);

  /// Number of column.
  final int columnCount;

  /// Gap to separate each cell.
  final double? gap;

  /// An empty space.
  final EdgeInsets? padding;

  /// The widgets below this widget in the tree.
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(children: _createRows()),
    );
  }

  List<Widget> _createRows() {
    final List<Widget> rows = [];
    final childrenLength = children.length;
    final rowCount = (childrenLength / columnCount).ceil();

    for (int rowIndex = 0; rowIndex < rowCount; rowIndex++) {
      final List<Widget> columns = _createRowCells(rowIndex);
      rows.add(Row(children: columns));
      if (rowIndex != rowCount - 1) rows.add(SizedBox(height: gap));
    }

    return rows;
  }

  List<Widget> _createRowCells(int rowIndex) {
    final List<Widget> columns = [];
    final childrenLength = children.length;

    for (int columnIndex = 0; columnIndex < columnCount; columnIndex++) {
      final cellIndex = rowIndex * columnCount + columnIndex;
      if (cellIndex <= childrenLength - 1) {
        columns.add(Expanded(child: children[cellIndex]));
      } else {
        columns.add(Expanded(child: Container()));
      }

      if (columnIndex != columnCount - 1) columns.add(SizedBox(width: gap));
    }

    return columns;
  }
}
