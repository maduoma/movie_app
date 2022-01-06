import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Displaying API response in ListView
void main() => runApp(const MoviesApp());

//App level widget
class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      //movie listing stateful widget
      home: MoviesListing(),
    );
  }
}

// A class for anything related to movies
class MoviesProvider {
  static const String imagePathPrefix = 'https://image.tmdb.org/t/p/w500/';

  //REPLACE: Don't forget to replace with your own API key
  static const apiKey = "8eaf8205d69cf7f36ddd79ceba2ff248";

  //Returns JSON formatted response as Map
  static Future<Map> getJson() async {
    const apiEndPoint =
        "http://api.themoviedb.org/3/discover/movie?api_key=$apiKey&sort_by=popularity.desc";
    final apiResponse = await http.get(Uri.parse(apiEndPoint));
    return json.decode(apiResponse.body);
  }
}

// This class has to be stateful, because the content changes as movies are fetched.
class MoviesListing extends StatefulWidget {
  const MoviesListing({Key? key}) : super(key: key);

  @override
  _MoviesListingState createState() => _MoviesListingState();
}

class _MoviesListingState extends State<MoviesListing> {
  dynamic movies;

  fetchMovies() async {
    var data = await MoviesProvider.getJson();

    //Updating data and requesting to rebuild widget
    setState(() {
      //storing movie list in `movies` variable
      movies = data['results'];
    });
  }

  @override
  Widget build(BuildContext context) {

    //Request to fetch movies
    fetchMovies();

    return Scaffold(
      //Rendering movies in ListView
      body: ListView.builder(
        // Calculating number of items using `movies` variable
        itemCount: movies == null ? 0 : movies.length,
        // Passing widget handle as `context`, and `index` to process one item at a time
        itemBuilder: (context, index) {

          return Padding(
            //Adding padding around the list row
            padding: const EdgeInsets.all(8.0),

            //Displaying title of the movie only for now
            child: Text(movies[index]["title"]),
          );
        },
      ),
      //ENDS
    );
  }
}