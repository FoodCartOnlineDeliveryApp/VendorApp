import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mealup_restaurant_side/config/Palette.dart';
import 'package:mealup_restaurant_side/widgets/ProductSearch.dart';

class ProductSearchScreen extends StatefulWidget {
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
}

class _ProductSearchScreenState extends State<ProductSearchScreen> {
  final TextEditingController _textController = TextEditingController();
  late ScrollController _scrollController;

  static const Duration _duration = Duration(seconds: 1);
  Timer _timer = Timer(_duration, () {});
  String _lastSearchTerm = '';

  void _search() {
    if (this._timer.isActive) this._timer.cancel();
    this._timer = Timer(_duration, () {
      if (this._lastSearchTerm != this._textController.text) {
        setState(() {
          this._scrollController.jumpTo(0);
          this._lastSearchTerm = this._textController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height*0.09,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Padding(
            padding: const EdgeInsets.fromLTRB(0,20,0,0),
            child: Icon(
              Icons.keyboard_backspace_outlined,
              color: Palette.loginhead,
              size: 35.0,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                style: TextStyle(height: 1, color: Colors.black, fontSize: 18),
                controller: this._textController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),

                  fillColor: Palette.divider,
                  filled: true,
                  hintText: 'Search something...',
                  hintStyle: TextStyle(color: Palette.bonjour, fontSize: 14,fontFamily: "ProximaNova"),
                  suffixIcon: Icon(Icons.search, color: Palette.bonjour),
                ),
                onChanged: (_) => this._search(),
              ),
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: ProductSearch(),
      ),
    );
  }
}
