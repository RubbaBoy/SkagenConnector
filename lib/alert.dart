// user defined function
import 'package:flutter/material.dart';

void loading(BuildContext context, String content, {String title = 'Please wait...'}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text(title),
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(30, 10, 0, 10),
                child: CircularProgressIndicator(),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                child: Text(
                  content,
                    textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}

void alert(BuildContext context, String title, {String content = null}) {
  content ??= title;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text(title, softWrap: true,),
        content: new Text(content),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new FlatButton(
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}