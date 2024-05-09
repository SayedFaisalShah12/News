import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/model/category_model.dart';
import '../enums/enum.dart';
import '../model_view/news_view_model.dart';
import 'newsdDetail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override

  NewsViewModel newsView = NewsViewModel();
  final format = DateFormat('MMM dd, yyyy');
  FilterList? selectedMenu;
  String categoryName = 'general';

  List<String> btnCategories = ['General', 'Entertainment', 'Health', 'Sports', 'Business', 'Technology'];

  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
                height: height * 0.1,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: btnCategories.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap:(){
                        categoryName = btnCategories[index];
                        setState(() {});
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: categoryName == btnCategories[index] ? Colors.blueAccent : Colors.grey,
                              borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Center(child: Text(btnCategories[index].toString(), style: GoogleFonts.poppins(color: Colors.white),)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
             ),
            Expanded(
              child: FutureBuilder<CategoryNews>(
                future: newsView.FetchCategoriesNews(categoryName),
                builder: (BuildContext context, snapshot){
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const Center(
                      child: SpinKitCircle(
                        size: 50,
                        color: Colors.blue,
                      ),
                    );
                  }
                  else{
                    return ListView.builder(
                        itemCount: snapshot.data!.articles?.length,
                        scrollDirection: Axis.vertical,
                        itemBuilder:   (context, index){
                          DateTime datetime = DateTime.parse(snapshot.data!.articles![index].publishedAt.toString());
                          return  InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetailsScreen(
                                newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                newsTitle: snapshot.data!.articles![index].title.toString(),
                                newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                description: snapshot.data!.articles![index].description.toString(),
                                content: snapshot.data!.articles![index].content.toString(),
                                source: snapshot.data!.articles![index].source!.name.toString(),
                              )
                              )
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 5),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      height: height * 0.2,
                                      width: width * 0.3  ,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const SpinKitCircle(size: 50, color: Colors.blue,),
                                      errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.redAccent,),
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                        height: height * 0.18,
                                        padding: EdgeInsets.only(left: 15),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(snapshot.data!.articles![index].title.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight:FontWeight.bold,
                                            ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(snapshot.data!.articles![index].source!.name.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 9,
                                                    fontWeight:FontWeight.bold,
                                                  ),
                                                ),
                                                Text(format.format(datetime),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 9,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            ],
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  }
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
