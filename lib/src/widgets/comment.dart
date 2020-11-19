import 'package:flutter/material.dart';
import '../models/item_model.dart';
import 'dart:async';
import 'loading_container.dart';
import 'package:html_unescape/html_unescape.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  final int depth;

  Comment({this.itemId, this.itemMap, this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        final data = snapshot.data;
        final children = <Widget>[
          ListTile(
            title: buildText(data),
            subtitle: data.by != "" ? Text(data.by) : Text("deleted Comment"),
            contentPadding: EdgeInsets.only(
              right: 16.0,
              left: (depth + 1) * 16.0,
            ),
          ),
          Divider(
            color: Colors.black45,
          ),
        ];
        snapshot.data.kids.forEach((kidId) {
          children.add(Comment(
            itemId: kidId,
            itemMap: itemMap,
            depth: depth + 1,
          ));
        });

        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildText(ItemModel item) {
    final text = item.text;
    final unescape = HtmlUnescape();
    return Text(unescape.convert(text));
  }
}
