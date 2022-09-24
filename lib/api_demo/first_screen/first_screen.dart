import 'dart:convert';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:demo_fire/common/method/shred_preferences.dart';
import 'package:demo_fire/reset_api/audiobook_api.dart';
import 'package:demo_fire/reset_api/categories_api.dart';
import 'package:demo_fire/reset_api/reset_api.dart';
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
  List a = [];
  Map<String, dynamic> m = {};
  bool staus = false;
  int pageindex = 0;

  Categoriesapi? categoriesapi;

  @override
  void initState() {
    super.initState();
    LoadData();
    CategoryLoadData();
    AudioLoadData();
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
    var url = Uri.parse(
        'https://audio-kumbh.herokuapp.com/api/v2/category/audiobook');
    var response = await http.get(url, headers: {
      "x-guest-token":
          "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    logs("=============>${response}");
    a = jsonDecode("${response.body}");

    setState(() {
      staus = true;
    });
  }

  AudioLoadData() async {
    var url =
        Uri.parse('https://audio-kumbh.herokuapp.com/api/v2/homepage/category');
    var response = await http.post(url, headers: {
      "x-guest-token":
          "U2FsdGVkX1+WVxNvXEwxTQsjLZAqcCKK9qqQQ5sUlx8aPkMZ/FyEyAleosfe07phhf0gFMgxsUh2uDnDSkhDaAfn1aw6jYHBwdZ43zdLiTcZedlS9zvVfxYG67fwnb4U454oAiMV0ImECW1DZg/w3aYZGXZIiQ+fiO4XNa1y1lc0rHvjKnPkgrYkgbTdOgAfnxnxaNHiniWClKWmVne/0vO0s6Vh7HpC0lRjs0LKTwM="
    }, body: {
      "sectionfor": "audiobook"
    });
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    logs("=+=+=+=+=+=+=>${response}");
    categoriesapi = categoriesapiFromJson(response.body);

    setState(() {
      staus = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: staus
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
                    height: 35,
                    width: double.infinity,
                    child: Text(
                      "Categories",
                      style: GoogleFonts.alice(
                          textStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                      height: 150,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: a.length,
                        itemBuilder: (context, index) {
                          AudioApi audioapi = AudioApi.fromJson(a[index]);
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 150,
                                  width: 200,
                                  child: Image.network("${audioapi.photoUrl}"),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 30, top: 35),
                                child: SizedBox(
                                  height: 30,
                                  width: 150,
                                  child: Text(
                                    "${audioapi.name}",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )),
                  SizedBox(
                    height: 35,
                    width: double.infinity,
                    child: Text(
                      "AudioBooks",
                      style: GoogleFonts.alice(
                          textStyle: TextStyle(
                              fontSize: 30,
                              color: Colors.brown,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Container(
                      height: 200,
                      width: double.infinity,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: categoriesapi!
                            .data!.homeCategoryList!.first.idList!.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 170,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            "${categoriesapi!.data!.homeCategoryList!.first.idList![index].audioBookDpUrl}"),
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              // Padding(
                              //   padding:
                              //       const EdgeInsets.only(left: 30, top: 35),
                              //   child: SizedBox(
                              //     height: 30,
                              //     width: 150,
                              //     child: Text(
                              //       "${categoriesapi!.data!.homeCategoryList!.first.idList!.first.name}",
                              //       style: TextStyle(
                              //           fontSize: 30),
                              //     ),
                              //   ),
                              // ),
                            ],
                          );
                        },
                      )),
                ],
              ),
            )
          : CircularProgressIndicator(),
    ));
  }
}
