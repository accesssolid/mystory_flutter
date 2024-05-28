import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mystory_flutter/services/navigation_service.dart';
import 'package:mystory_flutter/utils/routes.dart';
import 'package:mystory_flutter/utils/service_locator.dart';

class SearchItemWidget extends StatefulWidget {
  final data;
  ValueChanged<dynamic>? action;
  String? tag;
  final active;
  SearchItemWidget({
    this.action,
    this.active,
    this.data,
    this.tag,
  });

  @override
  _SearchItemWidgetState createState() => _SearchItemWidgetState();
}

class _SearchItemWidgetState extends State<SearchItemWidget> {
  var navigationService = locator<NavigationService>();

  void handletap() {
    widget.action!(widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: handletap,
      child: InkWell(
        onTap: () {
          navigationService.navigateTo(SearchStoryBookScreenRoute);
        },
        child: Container(
          margin: EdgeInsets.only(top: 12),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(221, 214, 249, 1),
                        spreadRadius: -8,
                        blurRadius: 5,
                        offset: Offset(0, 12)),
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image(
                      image: NetworkImage(widget.data['profilePicture'].toString()),
                      fit: BoxFit.cover,
                      height: 45,
                      width: 45,
                    ),
                  )),
              SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data['fullName'],
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  // Text(
                  //   widget.data['subtitle'],
                  //   style: TextStyle(color: Colors.grey.shade700, fontSize: 10),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
