import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/resources/component/horizontal_image.dart';
import 'package:movie_app/model/pass_data.dart';
import 'package:movie_app/resources/shimmer.dart';
import 'package:movie_app/view_model/trending_movie_viewModel.dart';
import 'package:provider/provider.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:movie_app/view_model/trending_movie_viewModel.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../data/responses/Status.dart';
import '../model/popular_TV_model.dart';
import '../resources/app_color.dart';
import '../resources/component/simple_horizontal_image.dart';
import '../utils/Routes/Route_name.dart';
import '../view_model/popular_tv_viewModel.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, int> dataMap = {'n': 2, 'm': 3};

  List<PopularTvModel> populartvm = [];

  trendingMovieViewModel trendingMovieVM = trendingMovieViewModel();
  popularTvViewModel popularTvVM = popularTvViewModel();

  @override
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    trendingMovieVM.fetchTrendingMovieApi();
    popularTvVM.FetchPopularTvList();
    super.initState();

    Timer(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('This is Home Screen');
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.backgroundColor,
      extendBody: true,
      // body: SizedBox(
      // child: Column(
      //   children: [
      //     Expanded(
      // child: ListView.builder(
      //     shrinkWrap: true,
      //     scrollDirection: Axis.horizontal,
      //     itemCount: 5,
      //     itemBuilder: (context, index) {
      //       return Card();
      //     }),
      // )
      //   ],
      // ),
      // child: HorizontalScreen(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 45, left: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top 5 Movies',
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        color: AppColor.primaryTextColor,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                      ),
                      // textAlign: TextAlign.start,
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 30),
                        child: InkWell(
                          splashColor: Colors.transparent.withOpacity(0),
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteName.searchScreen);
                          },
                          child: Container(
                              height: 27,
                              child: Image.asset(
                                'lib/icons/find.png',
                                color: AppColor.primaryTextColor,
                              )),
                        )),
                  ],
                )),
            ChangeNotifierProvider<trendingMovieViewModel>(
              create: (BuildContext context) => trendingMovieVM,
              child: Consumer<trendingMovieViewModel>(
                  builder: (context, value, _) {
                switch (value.movieList.status) {
                  case Status.LOADING:
                    return HorizontalCardShimmer();
                  case Status.ERROR:
                    return Text(value.movieList.message.toString());
                  case Status.COMPLETED:
                    return Container(
                      height: screenHeight * 0.31,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return HorizontalScreen(
                              ImageUrl: value
                                  .movieList.data!.results![index].backdropPath
                                  .toString(),
                              onPress: () {
                                Navigator.pushNamed(
                                    context, RouteName.infoScreen,
                                    arguments: PassData(
                                      value.movieList.data!.results![index]
                                          .posterPath
                                          .toString(),
                                      value
                                          .movieList.data!.results![index].title
                                          .toString(),
                                      value.movieList.data!.results![index]
                                          .releaseDate
                                          .toString(),
                                      value.movieList.data!.results![index]
                                          .originalLanguage
                                          .toString(),
                                      value.movieList.data!.results![index]
                                          .voteAverage!
                                          .toDouble(),
                                      value.movieList.data!.results![index]
                                          .overview
                                          .toString(),
                                    ));
                              },
                            );
                          }),
                    );
                }
                return Container(
                  width: 0,
                  height: 0,
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, bottom: 24),
              child: Text(
                'Popular TV shows',
                style: GoogleFonts.dmSans(
                  fontSize: 18,
                  color: AppColor.primaryTextColor,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                ),
                // textAlign: TextAlign.start,
              ),
            ),
            ChangeNotifierProvider<popularTvViewModel>(
              create: (BuildContext context) => popularTvVM,
              child: Consumer<popularTvViewModel>(builder: (context, value, _) {
                switch (value.TvList.status) {
                  case Status.LOADING:
                    return CircularProgressIndicator();
                  case Status.ERROR:
                    return Text(value.TvList.message.toString());
                  case Status.COMPLETED:
                    return Container(
                      height: screenHeight * 0.31,
                      child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: 15,
                          itemBuilder: (context, index) {
                            // print(value.TvList.data?.results?.length);

                            return SimpleHorizontalScreen(
                                ImageUrl: value
                                    .TvList.data!.results![index].posterPath
                                    .toString(),
                                onPress: () {
                                  Navigator.pushNamed(
                                      context, RouteName.infoScreen,
                                      arguments: PassData(
                                        value.TvList.data!.results![index]
                                            .backdropPath
                                            .toString(),
                                        value.TvList.data!.results![index].name
                                            .toString(),
                                        value.TvList.data!.results![index]
                                            .firstAirDate
                                            .toString(),
                                        value.TvList.data!.results![index]
                                            .originalLanguage
                                            .toString(),
                                        value.TvList.data!.results![index]
                                            .voteAverage!
                                            .toDouble(),
                                        value.TvList.data!.results![index]
                                            .overview
                                            .toString(),
                                      ));
                                });

                            return Container();
                          }),
                    );
                }
                return Container();
              }),
            ),
            // FutureBuilder(
            //     future: getData(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //             itemCount: 5,
            //             itemBuilder: (context, index) {
            //               return SimpleHorizontalScreen(
            //                 ImageUrl: populartvm[index]
            //                     .results![index]
            //                     .posterPath
            //                     .toString(),
            //               );
            //             });
            //       } else {
            //         return CircularProgressIndicator();
            //       }
            //     })
          ],
        ),
      ),
    );
  }

  // Future<List<PopularTvModel>> getData() async {
  //   final response = await http.get(Uri.parse(
  //       'https://api.themoviedb.org/3/tv/popular?api_key=74e83e30dbb2f3b125c2132c5cebb053'));
  //   var data = jsonDecode(response.body.toString());
  //   if (response.statusCode == 200) {
  //     for (Map<String, dynamic> index in data) {
  //       populartvm.add(PopularTvModel.fromJson(index));
  //     }
  //     return populartvm;
  //   } else {
  //     return populartvm;
  //   }
  // }
}
