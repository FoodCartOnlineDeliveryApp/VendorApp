import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';

class ProfileEdit extends StatefulWidget {
  @override
  _ProfileEditState createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/images/loginn.png'))),
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
                    children: [
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.black),
                          height: MediaQuery.of(context).size.height * 0.1,
                          width: MediaQuery.of(context).size.width * 0.23),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Icon(
                                  Icons.camera_alt_outlined,
                                  color: Palette.green,
                                  size: 25,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Text(
                                  "Change Picture",
                                  style: TextStyle(
                                      color: Palette.green,
                                      fontSize: 15,
                                      fontFamily: "ProximaNova"),
                                )
                              ],
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height*0.01,
                              width: MediaQuery.of(context).size.width*0.6,
                              child: Divider(
                                color: Palette.profliedivider,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                              ),
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * 0.01,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.035,
                                ),
                                Icon(
                                  Icons.remove,
                                  color: Palette.removeacct,
                                  size: 30,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.04,
                                ),
                                Text(
                                  "Remove Picture",
                                  style: TextStyle(
                                      color: Palette.removeacct,
                                      fontSize: 15,
                                      fontFamily: "ProximaNova"),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: Text(
                    "Restaurant Name",
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: "ProximaBold"),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.white),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Alex's Kitchen",
                              hintStyle: TextStyle(
                                  color: Palette.switchs,
                                  fontSize: 13,
                                  fontFamily: "ProximaNova")),
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 20, 0),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 16,
                            fontFamily: "ProximaBold"),
                      ),
                      Row(
                        children: [
                          Icon(Icons.info,color: Palette.removeacct,size: 20,),
                          Text(
                            " Not Verified",
                            style: TextStyle(
                                color: Palette.removeacct,
                                fontSize: 12,
                                fontFamily: "ProximaNova"),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.015,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Palette.white),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Center(
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "alexskitchen1990@gmail.com",
                              hintStyle: TextStyle(
                                  color: Palette.switchs,
                                  fontSize: 13,
                                  fontFamily: "ProximaNova")),
                          style: TextStyle(color: Colors.black, fontSize: 13),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * 0.04,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: Text(
                    "Contact Number",
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: "ProximaBold"),
                  ),
                ),
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height * 0.015,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Palette.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.26,
                        child: Padding(
                          padding:
                          const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: CircleAvatar(
                                  backgroundColor: Palette.loginhead,
                                  radius: 17,
                                  child: CircleAvatar(
                                    radius: 15,
                                    backgroundImage: NetworkImage(
                                        'https://cdn.britannica.com/79/4479-050-6EF87027/flag-Stars-and-Stripes-May-1-1795.jpg'),
                                  ),
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_down_outlined,color: Palette.loginhead,size: 25,)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Palette.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        height: MediaQuery.of(context).size.height * 0.08,
                        width: MediaQuery.of(context).size.width * 0.60,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '+1',
                              style: TextStyle(
                                  color: Palette.switchs, fontSize: 14),
                            ),
                            VerticalDivider(
                              width: 1,
                              thickness: 2,
                              indent: 10,
                              endIndent: 10,
                              color: Palette.switchs,
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height *
                                  0.05,
                              width:
                              MediaQuery.of(context).size.width * 0.3,
                              child: TextField(
                                decoration: InputDecoration(
                                    hintText: "000 000 0000",
                                    hintStyle: TextStyle(
                                        color: Palette.switchs,
                                        fontSize: 14),
                                    border: InputBorder.none),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 14),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: GestureDetector(
        onTap: () {

        },
        child: Container(
          color: Palette.green,
          height: MediaQuery.of(context).size.height * 0.07,
          child: Center(
            child: Text(
              "Change Information",
              style: TextStyle(
                  fontSize: 15,
                  color: Palette.white,
                  fontFamily: "ProximaNova"),
            ),
          ),
        ),
      ),
    );
  }
}
