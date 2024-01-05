import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wscube_wallpaper_app/modules/wallpaper_data_model.dart';
import 'package:wscube_wallpaper_app/screens/categories_screen.dart';
import 'package:http/http.dart' as https;

import 'theme_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController searchWallpaper = TextEditingController();

  Future<WallpaperModel?>? wallpaperModel;

  @override
  void initState() {
    super.initState();
    wallpaperModel = getAllPhotos();
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [
      Colors.blue,
      Colors.orange,
      Colors.yellow,
      Colors.pink,
      Colors.red,
      Colors.indigo,
      Colors.grey,
      Colors.green,
      Colors.purple,
      Colors.teal
    ];

    return Scaffold(
      backgroundColor: const Color.fromRGBO(215, 236, 237, 1),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchWallpaper,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        focusColor: Colors.transparent,
                        border: InputBorder.none,
                        filled: true,
                        hintText: "Find Wallpaper...",
                        hintStyle: const TextStyle(color: Colors.grey),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      getAllPhotos(query: searchWallpaper.text.toString());
                    },
                    icon: const Icon(CupertinoIcons.search),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Best of the month",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: FutureBuilder<WallpaperModel?>(
                  future: wallpaperModel,
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child:
                            Text("Network error ${snapshot.error.toString()}"),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                        itemCount: snapshot.data!.photos!.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext ctx, index) {
                          var photo =
                              snapshot.data!.photos![index].src!.portrait!;
                          return Row(
                            children: [
                              SizedBox(
                                height: 200,
                                width: 150,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (ctx) => ThemeScreen(
                                                    imageUrl: photo,
                                                  )));
                                    },
                                    child: Image.network(
                                      photo,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15)
                            ],
                          );
                        },
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "The color tone",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  itemCount: colors.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext ctx, index) {
                    return Row(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colors[index],
                          ),
                        ),
                        const SizedBox(width: 15)
                      ],
                    );
                  },
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                "Categories",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  FutureBuilder<WallpaperModel?>(
                    future: wallpaperModel,
                    builder: (_, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                              "Network error ${snapshot.error.toString()}"),
                        );
                      } else if (snapshot.hasData) {
                        return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 11,
                              crossAxisSpacing: 11,
                              childAspectRatio: 6 / 4,
                            ),
                            itemCount: snapshot.data!.photos!.length,
                            itemBuilder: (_, catIndex) {
                              var catPhoto = snapshot
                                  .data!.photos![catIndex].src!.landscape!;
                              return InkWell(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) =>
                                          const CategoryScreen()));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, right: 5, bottom: 10),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          catPhoto,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Center(
                                        child: Text(
                                          snapshot.data!.photos![catIndex]
                                              .photographer!,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            });
                      }
                      return Container();
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<WallpaperModel?> getAllPhotos(
      {String query = "nature", String colorCode = ""}) async {
    var myApi = "sxkQNVewOd8AFlFs0P7xf1vpnVM7TdILxUROfB1h57qFspAhfFhx0evm";
    var uri = Uri.parse(
        "https://api.pexels.com/v1/search?query=$query&color=$colorCode");
    var response = await https.get(uri, headers: {
      "Authorization": myApi,
    });

    if (response.statusCode == 200) {
      var mData = jsonDecode(response.body);
      var data = WallpaperModel.fromJson(mData);
      return data;
    } else {
      return null;
    }
  }
}
