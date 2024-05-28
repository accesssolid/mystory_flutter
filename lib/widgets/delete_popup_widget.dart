import 'package:flutter/material.dart';

class DeletePopupWidget extends StatefulWidget {
  final Function onItemClicked;

  DeletePopupWidget(this.onItemClicked);

  @override
  _DeletePopupWidgetState createState() => _DeletePopupWidgetState();
}

class _DeletePopupWidgetState extends State<DeletePopupWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 10.0),
      content: Container(
        height: 160,
        child: Column(
          children: [
            SizedBox(height: 20),
            Text(
              'Are you sure you want to delete!',
              style: TextStyle(fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 35),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onItemClicked();
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.w600),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.30,
                        MediaQuery.of(context).size.height * 0.060),
                    backgroundColor: Theme.of(context).backgroundColor,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(
                            width: 1,
                            color: Theme.of(context).backgroundColor)),
                  ),
                  child: Container(
                      padding: EdgeInsets.only(left: 5, right: 10),
                      child: new Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    textStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.03,
                        fontWeight: FontWeight.w600),
                    fixedSize: Size(MediaQuery.of(context).size.width * 0.30,
                        MediaQuery.of(context).size.height * 0.060),
                    backgroundColor: Colors.red,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(50.0),
                        side: BorderSide(width: 1, color: Colors.red)),
                  ),
                  child: Container(
                      padding: EdgeInsets.only(left: 5, right: 10),
                      child: new Text(
                        "No",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
