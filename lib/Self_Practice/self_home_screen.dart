import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:organized_sleep/Self_Practice/Controller/player_controller.dart';
import 'package:organized_sleep/Self_Practice/player.dart';

class AudioPlayerPage extends StatelessWidget {
  AudioPlayerPage({super.key});

  AudioPlayer audioPlayer = AudioPlayer();
  // audioPlayer.play(AssetSource('summer.mp3'));

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
        title: Text('Playing Audio'),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(child: Text('No Song Found'));
          } else {
            return Padding(
              padding: EdgeInsets.all(8),
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 4),
                      child: Obx(
                        () => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title:
                              Text("${snapshot.data![index].displayNameWOExt}"),
                          subtitle: Text("${snapshot.data![index].artist}"),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: Icon(Icons.music_note),
                          ),
                          trailing: controller.playIndex.value == index &&
                                  controller.isPlaying.value
                              ? Icon(Icons.play_arrow)
                              : null,
                          onTap: () {
                            // Get.to(() => const Player());
                            /*controller.playSong(
                                snapshot.data![index].uri, index);*/
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Player(
                                          data: snapshot.data![index],
                                        )
                                ));
                            controller.playSong(snapshot.data![index].uri, index);
                          },
                        ),
                      ),
                    );
                  }),
            );
          }
        },
      ),
    );
  }
}
