import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';

class CustomizationOption extends StatefulWidget {

  @override
  _CustomizationOptionState createState() => _CustomizationOptionState();
}

class _CustomizationOptionState extends State<CustomizationOption> {
  List<Widget> data = [];
  int val = -1;
  bool isChecked = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Palette.green;
    }
    return Palette.green;
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      data.add(customizationItem(0));
    }
    return Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Container(
                height: 50,
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        "Title",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 16,
                            fontFamily: "ProximaBold"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        "Price",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 16,
                            fontFamily: "ProximaBold"),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      child: Text(
                        "",
                        style: TextStyle(
                            color: Palette.loginhead,
                            fontSize: 16,
                            fontFamily: "ProximaBold"),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child:
                ListView.builder(
                    itemCount: data.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return customizationItem(index);
                    }),
              ),
              InkWell(
                onTap: () {
                  data.add(customizationItem(data.length + 1));
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add,
                        color: Palette.green,
                      ),
                      Text(
                        " Add More",
                        style: TextStyle(
                            color: Palette.green,
                            fontFamily: "ProximaNova",
                            fontSize: 14),
                      )
                    ],
                  ),
                ),
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
                "Add Customization Option",
                style: TextStyle(
                    fontSize: 15,
                    color: Palette.white,
                    fontFamily: "ProximaNova"),
              ),
            ),
          ),
        )
    );
  }

  customizationItem(int index) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.white),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.45,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "ex. Souce",
                          hintStyle: TextStyle(
                              color: Palette.switchs,
                              fontSize: 15,
                              fontFamily: "ProximaNova")),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.white),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.25,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Center(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Price",
                          hintStyle: TextStyle(
                              color: Palette.switchs,
                              fontSize: 15,
                              fontFamily: "ProximaNova")),
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Palette.removeacct),
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.12,
                child: IconButton(
                  icon: Icon(
                    Icons.delete_rounded,
                    color: Palette.white,
                  ),
                  onPressed: () {
                    if (index != 0) {
                      data.removeAt(index);
                    }
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                children: [
                  Text(
                    "Default",
                      style: TextStyle(
                          color: Palette.loginhead,
                          fontSize: 16,
                          fontFamily: "ProximaBold"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Radio(
                      value: 1,
                      groupValue: val,
                      activeColor: Palette.green,
                      onChanged: (int? value1) {
                        setState(() {
                          val = value1!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Status",
                    style: TextStyle(
                        color: Palette.loginhead,
                        fontSize: 16,
                        fontFamily: "ProximaBold"),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        DottedLine(
          direction: Axis.horizontal,
          lineThickness: 1.0,
          dashColor: Palette.green,
        ),
      ],
    );
  }
}
