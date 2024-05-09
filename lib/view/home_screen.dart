import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news/enums/enum.dart';
import 'package:news/model/category_model.dart';
import 'package:news/model/news_channelhealine_model.dart';
import 'package:news/view/category_screen.dart';
import 'package:news/view/newsdDetail_screen.dart';
import '../model_view/news_view_model.dart';

  class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override

    NewsViewModel newsView = NewsViewModel();
    final format = DateFormat('MMM dd, yyyy');
    FilterList? selectedMenu;
    String name = 'bbc-news';
  Widget build(BuildContext context){
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen()));
            },
            child: const Icon(Icons.list,)
        ),
        centerTitle: true,
        title: Text("News", style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),),
        actions: [
          PopupMenuButton<FilterList>(
              initialValue: selectedMenu,
              icon: const Icon(Icons.more_vert, color: Colors.black,),
              onSelected: (FilterList item){
                if(FilterList.bbcNews.name == item.name){
                  name = 'bbc-news';
                }
                if(FilterList.aryNews.name == item.name){
                  name = 'ary-news';
                }
                if(FilterList.alJazeera.name == item.name){
                  name = 'al-jazeera-english';
                }
                if(FilterList.cnn.name == item.name){
                  name = 'cnn';
                }

                setState(() {
                  selectedMenu = item;
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<FilterList>>[
                const PopupMenuItem<FilterList>(
                        value: FilterList.bbcNews,
                        child: Text("BBC News"),
                    ),

                const PopupMenuItem<FilterList>(
                  value: FilterList.alJazeera,
                  child: Text("Al Jazeera"),
                ),

                 const PopupMenuItem<FilterList>(
                  value: FilterList.aryNews,
                  child: Text("ARY News"),
                ),

                 const PopupMenuItem<FilterList>(
                  value: FilterList.cnn,
                  child: Text("CNN"),
                ),
              ]
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelHeadlineModel>(
                future: newsView.FetchNewsHeadlineApi(name),
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
                      scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index){
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
                          )));
                        },
                        child: SizedBox(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  height: height * 0.6,
                                  width: width * 0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(15)
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data!.articles![index].urlToImage.toString(),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const SpinKitCircle(size: 50, color: Colors.blue,),
                                      errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.redAccent,),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(15),
                                    alignment: Alignment.bottomCenter,
                                    height: height * 0.12,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                          SizedBox(
                                            width: width * 0.7,
                                            child: Text(snapshot.data!.articles![index].title.toString(),
                                            maxLines: 2, overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.bold),),
                                          ),
                                        const Spacer(),
                                        SizedBox(
                                          width: width * 0.7,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(snapshot.data!.articles![index].source!.name.toString(),
                                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold),),
                                              Text(format.format(datetime),
                                                maxLines: 2, overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.poppins(fontSize: 8, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    );
                  }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<CategoryNews>(
              future: newsView.FetchCategoriesNews('General'),
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
                    shrinkWrap: true,
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
          )
        ],
      ),
    );
  }
}
