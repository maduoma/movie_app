import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// import 'package:http/http.dart' as http; // @dart=2.9
void main() => runApp(const MoviesApp());

//REPLACE: Replace YOUR_API_KEY with your API key
const apiKey = "8eaf8205d69cf7f36ddd79ceba2ff248";

class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  //const MoviesApp({Key key}) : super(key: key); // @dart=2.9

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviesListing(),
    );
  }
}

class MoviesListing extends StatefulWidget {
  const MoviesListing({Key? key}) : super(key: key);

  //const MoviesListing({Key key}) : super(key: key); // @dart=2.9

  @override
  _MoviesListingState createState() => _MoviesListingState();
}

class _MoviesListingState extends State<MoviesListing> {
  //Variable to hold movies information
  dynamic movies; //change to dynamic instead of var

  //NOTE: Method to make http requests
  static dynamic getJson() async {
    //URL to fetch movies information
    const apiEndPoint =
        "http://api.themoviedb.org/3/discover/movie?api_key=$apiKey&sort_by=popularity.desc";
    final apiResponse = await http.get(Uri.parse(apiEndPoint));
    //final apiResponse = await http.get(apiEndPoint); //Deprecated, use //response = await http.get(Uri.parse("api path"));
    //'Instance of Response'
    return apiResponse;
  }

  //Method to fetch movies from network
  fetchMovies() async {
    //Getting json
    var data = await getJson();

    setState(() {
      movies = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Fetch movies
    fetchMovies();

    return Scaffold(
      //SingleChildScrollView to provide scrolling for flexible data rendering
      body: SingleChildScrollView(
        //Print API response on screen.
        //RESULT: At this point only text 'instance of Response' will be printed
        child: movies != null
            ? Text("TMDB Api response\n $movies")
            : const Text("Loading api response"),
      ),
    );
  }
}

// return with: flutter run --no-sound-null-safety in your Terminal of Android Studio.
