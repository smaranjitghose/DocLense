import 'package:flutter/material.dart';
import 'multi_select_delete.dart';

class GridItem extends StatefulWidget {
  final Key key;
  final Item item;
  final ValueChanged<bool> isSelected;

  GridItem({this.item, this.isSelected, this.key});

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          widget.isSelected(isSelected);
        });
      },
      child: Stack(
        children: <Widget>[
          Image.file(
            widget.item.imageUrl,
            color: Colors.black.withOpacity(isSelected ? 0.9 : 0),
            colorBlendMode: BlendMode.color,
            fit: BoxFit.cover,
          ),
          isSelected
              ? Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.check_circle,
                color: Colors.black,
              ),
            ),
          )
              : Container()
        ],
      ),
    );
  }
}
