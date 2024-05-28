import 'package:flutter/material.dart';
import 'package:mystory_flutter/screens/categories_list_screen.dart';

class CategorySeacrhScreen extends StatefulWidget {
  const CategorySeacrhScreen({Key? key}) : super(key: key);

  @override
  _CategorySeacrhScreenState createState() => _CategorySeacrhScreenState();
}

class _CategorySeacrhScreenState extends State<CategorySeacrhScreen> {
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextFormField(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => CategoriesListScreen(
            //       routeName: "Category Seacrh Screen",
            //         // heightController: controller,
            //         ),
            //   ),
            // );
          },
          controller: controller,
          readOnly: true,
          autofocus: true,
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color.fromRGBO(
                    238,
                    238,
                    238,
                    1,
                  ),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2.0,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                vertical: 5.0,
                horizontal: 20,
              ),
              suffixIcon: Icon(
                Icons.search,
                color: Color.fromRGBO(
                  179,
                  179,
                  181,
                  1,
                ),
              ),
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
              filled: true,
              fillColor: Color.fromRGBO(
                251,
                251,
                251,
                1,
              )),
        ),
      ),
    );
  }
}
