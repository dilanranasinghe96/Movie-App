import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/movies_model.dart';
import 'package:tmdb_movie_app/screens/movie_details.dart';
import 'package:tmdb_movie_app/services/api_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService service = ApiService();
  List<Movie> movies = [];
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey.shade400,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.black87,
            title: const Text(
              "Movie App",
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchPage(movies: movies),
                        ));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                    future: service.getMovies(page: page),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        movies = [...movies, ...snapshot.data!];
                        movies = movies.toSet().toList();
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: movies.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5,
                                  childAspectRatio: 0.59),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => MovieDetails(
                                              movie: movies[index],
                                            )));
                              },
                              child: Column(
                                children: [
                                  Flexible(
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                          image: DecorationImage(
                                              fit: BoxFit.fitHeight,
                                              image: NetworkImage(
                                                  "https://image.tmdb.org/t/p/w500${movies[index].posterPath}"))),
                                    ),
                                  ),
                                  Text(
                                    movies[index].title.toString(),
                                    style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }

                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        setState(() {
                          page = page + 1;
                          print(page);
                        });
                      },
                      child: const Text("Load More"))
                ],
              ),
            ),
          )),
    );
  }
}

class SearchPage extends StatefulWidget {
  final List<Movie> movies;

  const SearchPage({Key? key, required this.movies}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Movie> searchResults = [];
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (query) {
            performSearch(query);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
              searchResults.clear();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildMovieList(),
      ),
    );
  }

  Widget _buildMovieList() {
    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(
            "https://image.tmdb.org/t/p/w500${searchResults[index].posterPath}",
            width: 50,
            height: 50,
          ),
          title: Text(searchResults[index].title!),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => MovieDetails(
                  movie: searchResults[index],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        searchResults.clear();
      });
    } else {
      final List<Movie> matchingMovies = widget.movies
          .where((movie) =>
              movie.title!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      setState(() {
        searchResults = matchingMovies;
      });
    }
  }
}
