import 'dart:convert';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:demo_fire/reset_api/reset_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class FirstScrren extends StatefulWidget {
  const FirstScrren({Key? key}) : super(key: key);

  @override
  State<FirstScrren> createState() => _FirstScrrenState();
}

class _FirstScrrenState extends State<FirstScrren> {
  List l = [];
  bool staus = false;
  int pageindex = 0;

  @override
  void initState() {
    super.initState();
    LoadData();
    CategoryLoadData();
  }

  LoadData() async {
    var url = Uri.parse('https://audio-kumbh.herokuapp.com/api/v1/banner');
    var response = await http.get(url);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    setState(() {
      staus = true;
    });

    l = jsonDecode(response.body);
  }

  CategoryLoadData() async {
    var response=  await Dio().get(
      "https://audio-kumbh.herokuapp.com/api/v2/category/audiobook",
      options: Options(
        headers: {
          "x-guest-token":
              """U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM=""",
        },
      ),
    );

    logs("=============>${response}");



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Books"),
          centerTitle: true,
        ),
        body: staus
            ? SingleChildScrollView(
                child: Column(
                  children: [
                    CarouselSlider.builder(
                      itemCount: l.length,
                      itemBuilder: (context, index, realIndex) {
                        Resetapi resetapi = Resetapi.fromJson(l[index]);
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.red,
                              image: DecorationImage(
                                  image: NetworkImage("${resetapi.photoUrl}"),
                                  fit: BoxFit.fill),
                              borderRadius: BorderRadius.circular(10)),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            pageindex = index;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      child: CarouselIndicator(
                        count: l.length,
                        index: pageindex,
                        color: Colors.grey,
                        activeColor: Colors.brown,
                        cornerRadius: 40,
                      ),
                    ),
                    SizedBox(
                      height: 100,
                      width: double.infinity,
                      child: Text(
                        "Categories",
                        style: GoogleFonts.alice(
                            textStyle: TextStyle(
                                fontSize: 40,
                                color: Colors.brown,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.grey,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            child: Image.network(""),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            : CircularProgressIndicator());
  }
}
