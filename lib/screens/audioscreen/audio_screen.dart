import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lcpl_academy/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:lcpl_academy/screens/mediaplayers/audio_player.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({super.key});

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final fireStore = FirebaseFirestore.instance.collection('audios').snapshots();

  CollectionReference urlRef = FirebaseFirestore.instance.collection('audios');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Audios',
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
                  Text('Some error occured',
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

          return SizedBox(
            child: Expanded(
              child: ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AudioPlayerScreen(
                              url: data['url'],
                              title: data['title'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            top: 20, bottom: 20, right: 5, left: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppTheme.accentColor),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 7),
                                  child: SizedBox(
                                      height: 22,
                                      child: Image.asset(
                                          Constants.audioLeadingIcon)),
                                ),
                                Text(
                                  data['title'],
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
