import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lcpl_academy/provider/auth_provider.dart';
import 'package:lcpl_academy/provider/notification_provider.dart';
import 'package:lcpl_academy/reusablewidgets/has_error.dart';
import 'package:lcpl_academy/reusablewidgets/multicolor_progress_indicator.dart';
import 'package:lcpl_academy/reusablewidgets/no_data_available.dart';
import 'package:lcpl_academy/screens/audioscreen/audio_screen.dart';
import 'package:lcpl_academy/screens/docscreen/doc_screen.dart';
import 'package:lcpl_academy/screens/mediaplayers/audio_player.dart';
import 'package:lcpl_academy/screens/mediaplayers/doc_viewer.dart';
import 'package:lcpl_academy/screens/mediaplayers/video_player.dart';
import 'package:lcpl_academy/screens/quotescreen/quote_screen.dart';
import 'package:lcpl_academy/screens/videoscreen/video_screen.dart';
import 'package:lcpl_academy/theme/theme.dart';
import 'package:lcpl_academy/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  void initState() {
    super.initState();
      PushNotification.init();
   PushNotification.localNotiInit();
  }
  Stream<List<Map<String, dynamic>>> combinedDataStream() {
    var audioStream =
        FirebaseFirestore.instance.collection('audios').snapshots();
    var docStream = FirebaseFirestore.instance.collection('books').snapshots();
    var videoStream =
        FirebaseFirestore.instance.collection('videos').snapshots();

    return CombineLatestStream.list([audioStream, docStream, videoStream]).map(
      (snapshotList) {
        List<Map<String, dynamic>> combinedList = [];

        for (var snapshot in snapshotList) {
          combinedList.addAll(snapshot.docs.map((doc) => doc.data()).toList());
        }

        combinedList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));

        return combinedList;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<VoidCallback> navigatorList = [
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const DocScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const VideoScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AudioScreen(),
          ),
        );
      },
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuoteScreen(),
          ),
        );
      },
    ];

    return PopScope(
      onPopInvoked: (value) {
        SystemNavigator.pop();
      },
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Column(
          children: [
            Align(
                alignment: Alignment.centerRight,
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 5),
                      child: GestureDetector(
                        onTap: () {
                          value.signOut(context);
                        },
                        child: value.loading
                            ? const CircularProgressIndicator(
                                color: AppTheme.whiteColor,
                              )
                            : const Icon(
                                Icons.logout,
                                color: AppTheme.whiteColor,
                                size: 30,
                              ),
                      ),
                    );
                  },
                )),
            Expanded(
              flex: 3,
              child: GridView.builder(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: 10,
                ),
                itemCount: 4,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisExtent: 90,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: navigatorList[index],
                    child: Card(
                      elevation: 10,
                      child: Column(
                        children: [
                          Image(
                            height: 80,
                            image: AssetImage(
                              Constants.iconList[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTheme.whiteColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.only(top: 5),
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: combinedDataStream(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: MulticolorProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const HasError();
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const NoDataAvailable();
                    }

                    var combinedList = snapshot.data!;

                    return ListView.builder(
                      itemCount: combinedList.length,
                      itemBuilder: (context, index) {
                        var item = combinedList[index];
                        String fileType = item['fileName'].split('.').last;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              if (fileType == 'pdf') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        PdfViewer(url: item['url']),
                                  ),
                                );
                              } else if (fileType == 'mp3') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AudioPlayerScreen(
                                      url: item['url'],
                                      title: item['title'],
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                      url: item['url'],
                                      title: item['title'],
                                    ),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, right: 5, left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: AppTheme.accentColor),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 7),
                                        child: SizedBox(
                                            height: 22,
                                            child: Image.asset(
                                              fileType == 'pdf'
                                                  ? Constants
                                                      .documentLeadingIcon
                                                  : fileType == 'mp3'
                                                      ? Constants
                                                          .audioLeadingIcon
                                                      : Constants
                                                          .videoLeadingIcon,
                                            )),
                                      ),
                                      Text(
                                        item['title'],
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
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
