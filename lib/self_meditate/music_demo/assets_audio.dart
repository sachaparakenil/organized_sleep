import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:organized_sleep/self_meditate/meditation_home_screen.dart';


class AssetsAudio extends StatelessWidget {
  const AssetsAudio({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MUSIC MELODIES'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  //variable
  Color bgColor = Colors.blueGrey;
  //player
  final AudioPlayer _player = AudioPlayer();

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
            onPressed: () => Navigator.of(context).pop(Meditation()),
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
        title: Text(widget.title),
        centerTitle: true,
      ),
      body:  Container(
        padding: EdgeInsets.only(top: appBarHeight+topSpacing),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/icon/bg3.png"), fit: BoxFit.fill),
        ),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: FutureBuilder<String>(
            future: DefaultAssetBundle.of(context).loadString("AssetManifest.json"),
            // future: rootBundle.loadString("AssetManifest.json"),
            builder: (context, item){
              if(item.hasData){

                Map? jsonMap = json.decode(item.data!);
                List? songs = jsonMap?.keys.toList();
                // List? songs = jsonMap?.keys.where((element) => element.endsWith(".mp3")).toList();

                return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: songs?.length,
                  itemBuilder: (context, index){
                    var path = songs![index].toString();
                    var title = path.split("/").last.toString(); //get file name
                    title = title.replaceAll("%20", ""); //remove %20 characters
                    title = title.split(".").first;

                    return Container(
                      margin: const EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(color: Color(0xff7A8CA6), width: 1.0, style: BorderStyle.solid),
                      ),

                      child: ListTile(
                        textColor: Colors.black,
                        title: Text(title),
                        subtitle: Text("path: $path",
                          style: const TextStyle(color: Colors.black, fontSize: 12),),
                        leading: ClipOval(
                          child: Container(
                              padding: EdgeInsets.all(16),
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                color: Color(0xff173761),
                              ),
                              child: const Image(image: AssetImage('assets/icon/play.png'),color: Colors.white,height: 20, width: 20,)),
                        ),
                        onTap: () async{
                          toast(context, "Playing: $title");
                          //play this song
                          await _player.setAsset(path);
                          await _player.play();
                        },
                      ),
                    );
                  },
                );
              }else{
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

  //A toast method
  void toast(BuildContext context, String text){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text, textAlign: TextAlign.center,),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }
}