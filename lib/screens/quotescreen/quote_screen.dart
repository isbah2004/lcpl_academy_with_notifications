import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcpl_academy/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  final fireStore = FirebaseFirestore.instance
      .collection('quotes')
      .orderBy('timestamp', descending: true)
      .snapshots();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
     
        centerTitle: true,
        title: Text(
          'Quotes',
          style: GoogleFonts.ubuntu(),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fireStore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.errorLogo,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('Some error occurred',
                      style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600))),
                ],
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: MulticolorProgressIndicator());
          } else if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    Constants.emptyLogo,
                    height: 100,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text('No data available',
                      style: GoogleFonts.ubuntu(
                          textStyle: const TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w600))),
                ],
              ),
            );
          }

          
          return PageView.builder(
            itemCount: snapshot.data!.docs.length,
            onPageChanged: (index) {
           
            },
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: AppTheme.accentColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(child: Image.network(data['url'])),
                          const SizedBox(height: 15),
                          buildDetailField(data['title'], data['quote']),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    
    );
  }

  Widget buildDetailField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.ubuntu(fontSize: 25),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.ubuntu(fontSize: 18),
          overflow: TextOverflow.visible,
        ),
      ],
    );
  }
}
