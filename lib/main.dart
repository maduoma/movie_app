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

  //REPLACE: Replace YOUR_API_KEY with your API key
  static const apiKey = "8eaf8205d69cf7f36ddd79ceba2ff248";

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
  //List<MovieModel> movies = List<MovieModel>();
  List<MovieModel> movies = <MovieModel>[];

  //Keeping a counter to track network requests
  int counter = 0;

  fetchMovies() async {
    var data = await MoviesProvider.getJson();

    setState(() {
      //Increasing counter to track number of times method is called.
      counter++;
      List<dynamic> results = data['results'];

      //Creating list of MovieModel objects
      for (var element in results) {
        movies.add(
          MovieModel.fromJson(element),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //movies are fetched only once at app’s start-up
    fetchMovies();
  }

  @override
  Widget build(BuildContext context) {
    //CHALLENGE: `fetchMovies()` is called more than once.
    //Make it to be called only once. Uncomment it and called index initState()
    //fetchMovies();

    return Scaffold(
      body: ListView.builder(
        //Calculating list size
        itemCount: movies == null ? 0 : movies.length,
        //Building list view entries
        itemBuilder: (context, index) {
          return Padding(
            //Padding around the list item
            padding: const EdgeInsets.all(8.0),
            //Using MovieTile object to render movie's title, description and image
            //child: MovieTile(movies, index),
            child: Column(
              children: [
                MovieTile(movies, index),
                //Widget added to print number of requests made to fetch movies
                Text("Movies fetched: $counter"),
              ],
            ),
          );
        },
      ),
    );
  }
}

//NEW CODE: MovieTile object to render visually appealing movie information
class MovieTile extends StatelessWidget {
  final List<MovieModel> movies;
  final index;

  const MovieTile(this.movies, this.index);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          //Resizing image poster based on the screen size whenever image's path is not null.
          //Resizing image poster based on the screen size whenever the image's path is not null.
          movies[index].posterPath != null
              ? Container(
            //Making image's width to half of the given screen size
            width: MediaQuery.of(context).size.width / 2,

            //Making image's height to one fourth of the given screen size
            height: MediaQuery.of(context).size.height / 4,

            //Making image box visually appealing by dropping shadow
            decoration: BoxDecoration(
              //Making image box slightly curved
              borderRadius: BorderRadius.circular(10.0),
              //Setting box's color to grey
              color: Colors.grey,

              //Decorating image
              image: DecorationImage(
                  image: NetworkImage(MoviesProvider.imagePathPrefix +
                      movies[index].posterPath),
                  //Image getting all the available space
                  fit: BoxFit.cover),

              //Dropping shadow
              boxShadow: const [
                BoxShadow(
                  //grey colored shadow
                    color: Colors.grey,
                    //Applying softening effect
                    blurRadius: 3.0,
                    //move 1.0 to right (horizontal), and 3.0 to down (vertical)
                    offset: Offset(1.0, 3.0)),
              ],
            ),
          )
              : Container(), //Empty container when image is not available
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movies[index].title,
              style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
          ),
          //Styling movie's description text
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              movies[index].overview,
              style: const TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          Divider(color: Colors.grey.shade500),
        ],
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
