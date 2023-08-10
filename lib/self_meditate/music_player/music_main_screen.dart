import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:organized_sleep/self_meditate/meditation_home_screen.dart';
import 'music_sub_screen.dart';

class AssetsAudio extends StatefulWidget {
  const AssetsAudio({Key? key}) : super(key: key);

  @override
  State<AssetsAudio> createState() => _AssetsAudioState();
}

class _AssetsAudioState extends State<AssetsAudio> {
  @override
  Widget build(BuildContext context) {
    final double appBarHeight = AppBar().preferredSize.height;
    const double topSpacing = 50.0;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Material(
          color: Colors.transparent,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(const Meditation()),
            icon: Container(
              padding: const EdgeInsets.all(5),
              child: Image.asset(
                'assets/icon/back.png',
                width: 20,
                height: 20,
              ),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('MUSIC MELODIES'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.only(top: appBarHeight + topSpacing),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: FutureBuilder<String>(
            future:
                DefaultAssetBundle.of(context).loadString("AssetManifest.json"),
            builder: (context, item) {
              if (item.hasData) {
                Map? jsonMap = json.decode(item.data!);
                List? songs = jsonMap?.keys.toList();

                List? mp3Songs = songs
                    ?.where((path) =>
                        path.endsWith(".mp3") &&
                        path.startsWith("assets/Sounds/"))
                    .cast<
                        String>() // Explicitly cast the filtered list to List<String>
                    .toList();

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: mp3Songs?.length,
                  itemBuilder: (context, index) {
                    var path = mp3Songs![index].toString();
                    var title = path.split("/").last.toString(); //get file name
                    title = title.replaceAll("%20", ""); //remove %20 characters
                    title = title.split(".").first;

                    return Container(
                      margin: const EdgeInsets.only(
                          top: 20.0, left: 15.0, right: 15.0),
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: const Color(0xff7A8CA6),
                            width: 1.0,
                            style: BorderStyle.solid),
                      ),
                      child: ListTile(
                        textColor: Colors.black,
                        title: Text(title),
                        subtitle: Text(
                          "path: $path",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                        ),
                        leading: ClipOval(
                          child: Container(
                              padding: const EdgeInsets.all(16),
                              width: 60.0,
                              height: 60.0,
                              decoration: const BoxDecoration(
                                color: Color(0xff173761),
                              ),
                              child: const Image(
                                image: AssetImage('assets/icon/play.png'),
                                color: Colors.white,
                                height: 20,
                                width: 20,
                              )),
                        ),
                        onTap: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AudioPlayerScreen(
                                songIndex: index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text("No Songs in the Assets"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
