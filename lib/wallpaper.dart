import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/fullscreen.dart';

class Wallpaper extends StatefulWidget {
  const Wallpaper({super.key});

  @override
  State<Wallpaper> createState() => _WallpaperState();
}

class _WallpaperState extends State<Wallpaper> {
  List images = [];
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchapi();
  }



  fetchapi() async {
    final response = await http.get(
      Uri.parse(
          'https://api.pexels.com/v1/curated?per_page=80'), // Ensure there are no spaces around `=`
      headers: {
        'Authorization':
            '2rtp1PDMQXjN7bz2Yl31LkqRSvvG2QfG3Pqe3zk0N31alAasNxn8HVXG', // Ensure this is your valid API key
      },
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response, parse the JSON.
      Map result = jsonDecode(response.body);
      setState(() {
        images = result['photos'];
      });
      print(images[0]);
    } else {
      // If the server did not return a 200 OK response, throw an exception.
      print('Failed to load images');
    }
  }

  loadmore() async {
    setState(() {
      page = page + 1;
    });
    String url =
        'https://api.pexels.com/v1/curated?per_page=80&page=' + page.toString();
    await http.get(Uri.parse(url), // Ensure there are no spaces around `=`
        headers: {
          'Authorization':
              '2rtp1PDMQXjN7bz2Yl31LkqRSvvG2QfG3Pqe3zk0N31alAasNxn8HVXG', // Ensure this is your valid API key
        }).then((value) {
      Map result = jsonDecode(value.body);
      setState(() {
        images.addAll(result['photos']);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 3,
                crossAxisCount: 3,
                childAspectRatio: 2 / 3,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreen(
                                  imageurl :  images[index]['src']['large2x'],
                                )));
                  },
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      images[index]['src']['tiny'],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
          InkWell(
            onTap: () {
              loadmore();
            },
            child: Container(
              height: 60,
              width: double.infinity,
              child: const Center(
                child: Text(
                  'Load More',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
