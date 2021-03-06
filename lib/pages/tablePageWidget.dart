import 'package:flutter/material.dart';
import 'package:mult_tables/model/enumLevel.dart';
import 'package:mult_tables/pages/cellWidget.dart';
import 'package:mult_tables/pages/quizPageWidget.dart';

class TablePageWidget extends StatelessWidget {
  final int multBy;

  const TablePageWidget(
    this.multBy, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            buildAppBar(context, 'Multi Tables for $multBy', QuizPageWidget()),
        body: Center(
          child: TableBodyWidget(multBy),
        ),
      ),
    );
  }
}

class TableBodyWidget extends StatelessWidget {
  final int multBy;

  const TableBodyWidget(
    this.multBy, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      child: GridWidget(multBy),
    );
  }
}

class GridWidget extends StatelessWidget {
  const GridWidget(
    this.multBy, {
    Key key,
  }) : super(key: key);
  final int multBy;
  @override
  Widget build(BuildContext context) {
    return GridView.extent(
        maxCrossAxisExtent: 120,
        padding: const EdgeInsets.all(4),
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: _buildGridTileList(28, multBy, context));
  }

  List<Widget> _buildGridTileList(
          int count, int multBy, BuildContext context) =>
      generateCells(count, multBy, context);

  List<Widget> generateCells(int count, int multBy, BuildContext context) {
    return List.generate(count, (i) => generateCell(i, multBy, context));
  }

  InkWell generateCell(int i, int multBy, BuildContext context) {
    var cellText = getCellText(i, multBy);
    var container = CellWidget(cellText: cellText);
    return InkWell(
      child: container,
      onTap: () => tapAction(i, multBy, cellText, context),
    );
  }

  String getCellText(int i, int multBy) =>
      ' * ${i + 2} = ${((i + 2) * multBy).toString()}';

  void tapAction(int count, int multBy, String cellText, BuildContext context) {
    print(
        "Container pressed count: $count , multBy: $multBy, cellText: $cellText");
    print(context.widget);
  }
}
