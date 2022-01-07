import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(const MoviesApp());

class MoviesApp extends StatelessWidget {
  const MoviesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MoviesListing(),
    );
  }
}

class MoviesProvider {
  static const String imagePathPrefix = 'https://image.tmdb.org/t/p/w500/';

  //Replace YOUR_API_KEY with your API key
  static const apiKey = "YOUR_API_KEY";

  static Future<Map> getJson() async {
    const apiEndPoint =
        "http://api.themoviedb.org/3/discover/movie?api_key=$apiKey&sort_by=popularity.desc";
    final apiResponse = await http.get(Uri.parse(apiEndPoint));
    return json.decode(apiResponse.body);
  }
}

class MoviesListing extends StatefulWidget {
  const MoviesListing({Key? key}) : super(key: key);

  @override
  _MoviesListingState createState() => _MoviesListingState();
}

class _MoviesListingState extends State<MoviesListing> {
  List<MovieModel>? movies = <MovieModel>[];

  fetchMovies() async {
    var data = await MoviesProvider.getJson();

    setState(() {
      List<dynamic> results = data['results'];
      // results.forEach((element) - Avoid using `forEach` with a function literal.
      for (var element in results) {
        movies?.add(MovieModel.fromJson(element));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    fetchMovies();

    return Scaffold(
      body: ListView.builder(
        itemCount: movies == null ? 0 : movies?.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),

            //NEW CODE: New way to display title
            //Title is being accessed as below rather than using`movies[index]["title"]`
            child: Text(movies![index].title),
          );
        },
      ),
    );
  }
}

//JSON response is converted into MovieModel object
class MovieModel {
  final int id;
  final num popularity;
  final int voteCount;
  final bool video;
  final String posterPath;
  final String backdropPath;
  final bool adult;
  final String originalLanguage;
  final String originalTitle;
  final List<dynamic> genreIds;
  final String title;
  final num voteAverage;
  final String overview;
  final String releaseDate;

  MovieModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        popularity = json['popularity'],
        voteCount = json['vote_count'],
        video = json['video'],
        posterPath = json['poster_path'],
        adult = json['adult'],
        originalLanguage = json['original_language'],
        originalTitle = json['original_title'],
        genreIds = json['genre_ids'],
        title = json['title'],
        voteAverage = json['vote_average'],
        overview = json['overview'],
        releaseDate = json['release_date'],
        backdropPath = json['backdrop_path'];
}
