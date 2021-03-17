import 'package:flutter/material.dart';

import 'multi_select_delete.dart';

class GridItem extends StatefulWidget {
  final Item item;
  final ValueChanged<bool> isSelected;

  const GridItem({Key key, this.item, this.isSelected}) : super(key: key);

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
            fit: BoxFit.fill, //Determines the size ratio of the gridimage
            width: 320,
            height: 320,
          ),
          if (isSelected)
            const Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.black,
                ),
              ),
            )
          else
            Container()
        ],
      ),
    );
  }
}
