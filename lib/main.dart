import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Printing API response
void main() => runApp(const MoviesApp());

//MovieApp stateless widget at app level
class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      //Adding movie listing widget as app's home screen
      home: MoviesListing(),
    );
  }
}

class MoviesProvider {
  static const String imagePathPrefix = 'https://image.tmdb.org/t/p/w500/';

  //REPLACE: Replace YOUR_API_KEY with your API key
  static const apiKey = "8eaf8205d69cf7f36ddd79ceba2ff248";

  //Returning JSON data as Map
  static Future<Map> getJson() async {
    const apiEndPoint =
        "http://api.themoviedb.org/3/discover/movie?api_key=$apiKey&sort_by=popularity.desc";
    final apiResponse = await http.get(Uri.parse(apiEndPoint));
    return json.decode(apiResponse.body);
  }
}

//Movie listing widget
class MoviesListing extends StatefulWidget {
  const MoviesListing({Key? key}) : super(key: key);

  @override
  _MoviesListingState createState() => _MoviesListingState();
}

//State object
class _MoviesListingState extends State<MoviesListing> {
  dynamic movies;

  fetchMovies() async {
    var data = await MoviesProvider.getJson();

    //Updating movies variable with fresh data
    setState(() {
      movies = data['results'];
    });
  }

  //Building main screen
  @override
  Widget build(BuildContext context) {
    //Calling method to fetch movies
    fetchMovies();

    return Scaffold(
      body: SingleChildScrollView(
        //Displaying JSON response data in plain text on main screen
        child: movies != null
            ? Text("TMDB Api response\n $movies")
            : const Text("Loading api response"),
      ),
    );
  }
}
