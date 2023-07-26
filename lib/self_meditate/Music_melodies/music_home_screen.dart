import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:organized_sleep/self_meditate/Music_melodies/player.dart';
import 'Controller/player_controller.dart';

//ignore: must_be_immutable
class AudioPlayerPage extends StatelessWidget {
  AudioPlayerPage({super.key});

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Playing Audio'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
            uriType: UriType.EXTERNAL),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text('No Song Found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 4),
                      child: Obx(
                        () => ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          title:
                              Text(snapshot.data![index].displayNameWOExt),
                          subtitle: Text("${snapshot.data![index].artist}"),
                          leading: QueryArtworkWidget(
                            id: snapshot.data![index].id,
                            type: ArtworkType.AUDIO,
                            nullArtworkWidget: const Icon(Icons.music_note),
                          ),
                          trailing: controller.playIndex.value == index &&
                                  controller.isPlaying.value
                              ? const Icon(Icons.play_arrow)
                              : null,
                          onTap: () {
                            // Get.to(() => const Player());
                            /*controller.playSong(
                                snapshot.data![index].uri, index);*/
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Player(
                                          data: snapshot.data!,
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
