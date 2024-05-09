import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NewsDetailsScreen extends StatefulWidget {
  final String newsImage, newsTitle, newsDate, description, content, source;
  const NewsDetailsScreen
      ({super.key,
          required this.newsImage,
          required this.newsTitle,
          required this.newsDate,
          required this.description,
          required this.content,
          required this.source, });
  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}


class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  @override

  final format = DateFormat('MMM dd, yyyy');
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    DateTime dateTime =DateTime.parse(widget.newsDate);
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.transparent,
       centerTitle: true,
       elevation: 0,
       title: Text(widget.source),
     ),

    body: SingleChildScrollView(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              height: height * 0.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: CachedNetworkImage(
                  imageUrl: widget.newsImage,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const SpinKitCircle(size: 50, color: Colors.blue,),
                  errorWidget: (context, url, error) => const Icon(Icons.error_outline, color: Colors.redAccent,),
                ),
              ),
            ),
          ),
          Container(
              height: height * 0.6,
              margin: EdgeInsets.only(top: height * 0.4),
              padding: const EdgeInsets.all(15),
              decoration:  const BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                children: [
                  Text(widget.newsTitle, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: height * 0.02,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.source, style: GoogleFonts.poppins(fontSize: 15,)),
                      Text(format.format(dateTime) , style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: height * 0.02,),
                  Text(widget.description, style: GoogleFonts.poppins(fontSize: 15,)),

                  SizedBox(height: height * 0.02,),
                  Text(widget.content, style: GoogleFonts.poppins(fontSize: 15)),
                ],
              ),
          ),
        ],
      ),
    ),
    );
  }
}

