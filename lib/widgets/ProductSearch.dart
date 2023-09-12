import 'package:flutter/material.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';

class ProductSearch extends StatefulWidget {
  @override
  _ProductSearchState createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image:
                DecorationImage(image: AssetImage('assets/images/loginn.png'))),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recently Searches",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 18,
                            fontFamily: "ProximaBold"),
                      ),
                      Text(
                        "Clear",
                        style: TextStyle(
                            color: Palette.green,
                            fontSize: 14,
                            fontFamily: "ProximaNova"),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Palette.loginhead,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "Pizza",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 14,
                                  fontFamily: "ProximaNova"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Palette.loginhead,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "Desserts",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 14,
                                  fontFamily: "ProximaNova"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Palette.loginhead,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "Beverages",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 14,
                                  fontFamily: "ProximaNova"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Palette.loginhead,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "Hot Chocolate With Ice Cream",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 14,
                                  fontFamily: "ProximaNova"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Palette.loginhead,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "Green Chili With Cheese",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 14,
                                  fontFamily: "ProximaNova"),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.015,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.history,
                            color: Palette.loginhead,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              "Black Burger",
                              style: TextStyle(
                                  color: Palette.loginhead,
                                  fontSize: 14,
                                  fontFamily: "ProximaNova"),
                            ),
                          )
                        ],
                      ),

                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
