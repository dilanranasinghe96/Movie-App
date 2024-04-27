import 'package:flutter/material.dart';
import 'package:tmdb_movie_app/models/movie_details_model.dart';
import 'package:tmdb_movie_app/models/movies_model.dart';
import 'package:tmdb_movie_app/screens/homepage.dart';
import 'package:tmdb_movie_app/services/api_services.dart';

class MovieDetails extends StatefulWidget {
  Movie movie;
  MovieDetails({required this.movie, super.key});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  ApiService service = ApiService();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ));
              },
            ),
            backgroundColor: Colors.black87,
            title: const Text(
              "Movie App",
              style: TextStyle(color: Colors.white),
            ),
          ),
          body: FutureBuilder(
            future: service.getDetails(id: widget.movie.id.toString()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                MovieDetailsModel data = snapshot.data!;
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.movie.title.toString(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          data.tagline.toString(),
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: size.height * 0.25,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.darken),
                                image: NetworkImage(
                                    "https://image.tmdb.org/t/p/w500${widget.movie.backdropPath.toString()}"))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: size.width * 0.5,
                            height: size.width * 0.8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                    fit: BoxFit.fitHeight,
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/w500${widget.movie.posterPath.toString()}")))),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            widget.movie.overview.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400, fontSize: 16),
                          ),
                        ),
                      ),
                      data.company!.isNotEmpty
                          ? const Text(
                              "Production Companies",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w700),
                            )
                          : const SizedBox(),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(
                              data.company!.length,
                              (index) => data.company![index].logo.toString() ==
                                      ""
                                  ? const SizedBox()
                                  : Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Card(
                                        elevation: 5,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Image.network(
                                                  "https://image.tmdb.org/t/p/w500${data.company![index].logo.toString()}",
                                                  width: 100,
                                                  height: 100,
                                                  fit: BoxFit.fitHeight),
                                              Text(data.company![index].name
                                                  .toString())
                                            ],
                                          ),
                                        ),
                                      ),
                                    )),
                        ),
                      )
                    ],
                  ),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          )),
    );
  }
}
