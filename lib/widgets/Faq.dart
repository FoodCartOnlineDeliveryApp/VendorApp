import 'package:flutter/material.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';

class Faq extends StatefulWidget {
  @override
  _FaqState createState() => _FaqState();
}

class _FaqState extends State<Faq> {
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "1. ",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "2. ",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "3. ",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Text(
                          "4. ",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,0),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:0),
                          child: Text(
                            "5. ",
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:0),
                          child: Text(
                            "6. ",
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:0),
                          child: Text(
                            "7. ",
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:0),
                          child: Text(
                            "8. ",
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1,thickness: 1,indent: 15,endIndent: 25,color: Palette.profliedivider,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,0,5,0),
                  child: ExpansionTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom:0),
                          child: Text(
                            "9. ",
                            style: TextStyle(
                                color: Palette.loginhead,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          "Lorem ipsum dolor sit amet, consetetur ?",
                          style: TextStyle(
                              color: Palette.loginhead,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30,0,30,10),
                        child: Text(
                            "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum"),
                      ),
                    ],
                  ),
                ),

              ],
            )
          ],
        ),
      ),
    );
  }
}
