import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:record_mp3/record_mp3.dart';
import 'package:yallajeye/Services/record_audio.dart';
import 'package:yallajeye/constants/colors_textStyle.dart';
import 'package:yallajeye/providers/order.dart';
import 'package:yallajeye/screens/order/chat/widgets/player.dart';


import 'constants/color_constants.dart';
import 'constants/firestore_constants.dart';
import 'models/message.dart';

import 'pages/full_photo_page.dart';
import 'providers/chat_provider.dart';
import 'widgets/loading_view.dart';

class ChatPage extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPage({Key key,  this.peerId,  this.peerAvatar,  this.peerNickname}) : super(key: key);

  @override
  State createState() => ChatPageState(
    peerId: this.peerId,
    peerAvatar: this.peerAvatar,
    peerNickname: this.peerNickname,
  );
}

class ChatPageState extends State<ChatPage> {
  ChatPageState({Key key,  this.peerId,  this.peerAvatar,  this.peerNickname});

  String peerId;
  String peerAvatar;
  String peerNickname;
   String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];
  int _limit = 20;
  int _limitIncrement = 20;
  String groupChatId = "";

  File imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";
  bool isRecording=false;
  final record=SoundRecord();
  String path="";
  String audioUrl="";
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  bool loadingRecord=false;
  getPermission()async{
    final status = await Permission.microphone.request();
    if(status.isGranted){
      print("granted");
    }else{
      print("denied");
    }
  }

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

   ChatProvider chatProvider;
  // late AuthProvider authProvider;


  @override
  void initState() {
    super.initState();
    getPermission();
    record.init();
    chatProvider = context.read<ChatProvider>();
    // authProvider = context.read<AuthProvider>();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying=state==PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        setState(() {
          duration=newDuration;
        });
      });
    });
    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position=newPosition;
      });
    });

    focusNode.addListener(onFocusChange);
    listScrollController.addListener(_scrollListener);
    readLocal();
  }

  @override
  void dispose() {
    record.dispose();
    super.dispose();
  }


  _scrollListener() {
    if (listScrollController.offset >= listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange &&
        _limit <= listMessage.length) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  void readLocal() {
    // if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
    //   currentUserId = authProvider.getUserFirebaseId()!;
    // } else {
    //   Navigator.of(context).pushAndRemoveUntil(
    //     MaterialPageRoute(builder: (context) => LoginPage()),
    //         (Route<dynamic> route) => false,
    //   );
    // }
    // if (currentUserId.compareTo(peerId) > 0) {
    //   groupChatId = '$currentUserId-$peerId';
    // } else {
    //   groupChatId = '$peerId-$currentUserId';
    // }
final order=Provider.of<OrderProvider>(context,listen: false);
currentUserId=order.orderByIdModel.id.toString();

    groupChatId = '$peerId-$currentUserId';

    chatProvider.updateDataFirestore(
      FirestoreConstants.pathUserCollection,
      peerId,
      {FirestoreConstants.chattingWith: currentUserId},
    );
  }


  Future getImage() async {
    ImagePicker imagePicker = ImagePicker();
    PickedFile pickedFile;
    pickedFile = await imagePicker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        setState(() {
          isLoading = true;
        });
        uploadFile();
      }
    }
  }

  // void getSticker() {
  //   // Hide keyboard when sticker appear
  //   focusNode.unfocus();
  //   setState(() {
  //     isShowSticker = !isShowSticker;
  //   });
  // }
  int count=0;
  Future<String> getFilePath() async {
    count++;
    Directory storageDirectory = await getTemporaryDirectory();
    String sdPath = storageDirectory.path ;
    var d = Directory(sdPath);
    if (!d.existsSync()) {
      d.createSync(recursive: true);
    }
    return sdPath+"audio_${count}.mp3";
  }

  Future uploadAudioFile() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    print(path);
    // UploadTask uploadTask=chatProvider.uploadFile(File("/data/user/0/com.megabee.yallajeye/cache/"+path), fileName);
    UploadTask uploadTask=chatProvider.uploadFile(File(path), fileName);
    try{
      TaskSnapshot snapshot = await uploadTask;
      audioUrl = await snapshot.ref.getDownloadURL();
      onSendMessage(audioUrl, TypeMessage.audio);
    }on FirebaseException catch(e){
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  Future uploadFile() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    UploadTask uploadTask = chatProvider.uploadFile(imageFile, fileName);
    try {
      TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, TypeMessage.image);
      });
    } on FirebaseException catch (e) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: e.message ?? e.toString());
    }
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(content, type, groupChatId, currentUserId, peerId);
      listScrollController.animateTo(0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(msg: 'Nothing to send', backgroundColor: ColorConstants.greyColor);
    }
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // Right (my message)
        return Row(
          children: <Widget>[
            messageChat.type == TypeMessage.text
            // Text
                ? Container(
              child: Text(
                messageChat.content,
                // style: TextStyle(color: ColorConstants.primaryColor),
              ),
              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
              width: 200,
              decoration: BoxDecoration(color: ColorConstants.greyColor2, borderRadius: BorderRadius.circular(8)),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            )
                : messageChat.type == TypeMessage.image
            // Image
                ? Container(
              child: OutlinedButton(
                child: Material(
                  child: Image.network(
                    messageChat.content,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        decoration: BoxDecoration(
                          color: ColorConstants.greyColor2,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        width: 200,
                        height: 200,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: redColor,
                            value: loadingProgress.expectedTotalBytes != null &&
                                loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, object, stackTrace) {
                      return Material(
                        child: Image.asset(
                          'images/img_not_available.jpeg',
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        clipBehavior: Clip.hardEdge,
                      );
                    },
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullPhotoPage(
                        url: messageChat.content,
                      ),
                    ),
                  );
                },
                style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            )
            // Sticker
                :
            messageChat.type == TypeMessage.audio?
                Player(
                  islast:isLastMessageRight(index),
                  url: messageChat.content,
                  unique:messageChat.timestamp,
                )

            // Container(
            //
            //   padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
            //   width: 200,
            //   decoration: BoxDecoration(color: ColorConstants.greyColor2, borderRadius: BorderRadius.circular(8)),
            //   margin: EdgeInsets.only(bottom: isLastMessageRight(index)? 20 : 10, right: 10),
            //
            //   child: Row(
            //     children: [
            //
            //      loadingRecord?CircularProgressIndicator(): InkWell(
            //         onTap: ()async{
            //           await _loadFile(messageChat.content);
            //           await audioPlayer.play(recordFilePath,isLocal: true);
            //
            //         },
            //         child: Icon(isPlaying?Icons.pause:Icons.play_arrow),
            //       ),
            //       Expanded(child:
            //       SliderTheme(
            //         data: SliderThemeData(
            //             thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6)
            //         ),child: Slider(
            //         onChanged: (val){},
            //         activeColor: redColor,
            //         min: 0,
            //         max:duration.inSeconds.toDouble() ,
            //         value: position.inSeconds.toDouble(),
            //       ),)
            //
            //       )
            //     ],
            //   ),
            //
            // )

                : Container(
              child: Image.asset(
                'images/${messageChat.content}.gif',
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  isLastMessageLeft(index)
                      ? Material(
                    child: Image.asset(
                      "assets/images/logo.png",
                      // loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                      //   if (loadingProgress == null) return child;
                      //   return Center(
                      //     child: CircularProgressIndicator(
                      //       color: ColorConstants.themeColor,
                      //       value: loadingProgress.expectedTotalBytes != null &&
                      //           loadingProgress.expectedTotalBytes != null
                      //           ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                      //           : null,
                      //     ),
                      //   );
                      // },
                      errorBuilder: (context, object, stackTrace) {
                        return Icon(
                          Icons.account_circle,
                          size: 35,
                          color: ColorConstants.greyColor,
                        );
                      },
                      width: 35,
                      height: 35,
                      fit: BoxFit.fill,
                    ),
                    // borderRadius: BorderRadius.all(
                    //   Radius.circular(18),
                    // ),
                    clipBehavior: Clip.hardEdge,
                  )
                      : Container(width: 35),
                  messageChat.type == TypeMessage.text
                      ? Container(
                    child: Text(
                      messageChat.content,
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                    width: 200,
                    decoration:
                    BoxDecoration(color: ColorConstants.primaryColor, borderRadius: BorderRadius.circular(8)),
                    margin: EdgeInsets.only(left: 10),
                  )
                      : messageChat.type == TypeMessage.image
                      ? Container(
                    child: TextButton(
                      child: Material(
                        child: Image.network(
                          messageChat.content,
                          loadingBuilder:
                              (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                color: ColorConstants.greyColor2,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              width: 200,
                              height: 200,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: ColorConstants.themeColor,
                                  value: loadingProgress.expectedTotalBytes != null &&
                                      loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, object, stackTrace) => Material(
                            child: Image.asset(
                              'assets/images/img_not_available.jpeg',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            clipBehavior: Clip.hardEdge,
                          ),
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullPhotoPage(url: messageChat.content),
                          ),
                        );
                      },
                      style: ButtonStyle(padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0))),
                    ),
                    margin: EdgeInsets.only(left: 10),
                  ):messageChat.type == TypeMessage.audio?Container(
                    width: 200,
                    child: Text("this is audio"),
                  )
                      : Container(
                    child: Image.asset(
                      'images/${messageChat.content}.gif',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    margin: EdgeInsets.only(bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                  ),
                ],
              ),

              // Time
              isLastMessageLeft(index)
                  ? Container(
                child: Text(
                  DateFormat('dd MMM kk:mm')
                      .format(DateTime.fromMillisecondsSinceEpoch(int.parse(messageChat.timestamp))),
                  style: TextStyle(color: ColorConstants.greyColor, fontSize: 12, fontStyle: FontStyle.italic),
                ),
                margin: EdgeInsets.only(left: 50, top: 5, bottom: 5),
              )
                  : SizedBox.shrink()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get(FirestoreConstants.idFrom) == currentUserId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get(FirestoreConstants.idFrom) != currentUserId) || index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    // if (isShowSticker) {
    //   setState(() {
    //     isShowSticker = false;
    //   });
    // } else {
      chatProvider.updateDataFirestore(
        FirestoreConstants.pathUserCollection,
        currentUserId,
        {FirestoreConstants.chattingWith: null},
      );
      Navigator.pop(context);
    // }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                // List of messages
                buildListMessage(),

                // Sticker
                // isShowSticker ? buildSticker() : SizedBox.shrink(),

                // Input content
                buildInput(),
              ],
            ),

            // Loading
            buildLoading()
          ],
        ),
        onWillPop: onBackPress,
      ),
    );
  }

  // Widget buildSticker() {
  //   return Expanded(
  //     child: Container(
  //       child: Column(
  //         children: <Widget>[
  //           Row(
  //             children: <Widget>[
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi1', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi1.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi2', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi2.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi3', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi3.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //             ],
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           ),
  //           Row(
  //             children: <Widget>[
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi4', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi4.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi5', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi5.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi6', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi6.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //             ],
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           ),
  //           Row(
  //             children: <Widget>[
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi7', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi7.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi8', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi8.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //               TextButton(
  //                 onPressed: () => onSendMessage('mimi9', TypeMessage.sticker),
  //                 child: Image.asset(
  //                   'images/mimi9.gif',
  //                   width: 50,
  //                   height: 50,
  //                   fit: BoxFit.cover,
  //                 ),
  //               )
  //             ],
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           )
  //         ],
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       ),
  //       decoration: BoxDecoration(
  //           border: Border(top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)), color: Colors.white),
  //       padding: EdgeInsets.all(5),
  //       height: 180,
  //     ),
  //   );
  // }

  Widget buildLoading() {
    return Positioned(
      child: isLoading ? LoadingView() : SizedBox.shrink(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: Icon(Icons.image),
                onPressed: getImage,
                color: ColorConstants.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          // Material(
          //   child: Container(
          //     margin: EdgeInsets.symmetric(horizontal: 1),
          //     child: IconButton(
          //       icon: Icon(Icons.face),
          //       onPressed: getSticker,
          //       color: ColorConstants.primaryColor,
          //     ),
          //   ),
          //   color: Colors.white,
          // ),

          // Edit text
          Flexible(
            child: Container(
              child: Stack(
                children: [
                  AnimatedOpacity(

                    opacity: RecordMp3.instance.status==RecordStatus.RECORDING?0:1,
                    duration: Duration(milliseconds: 150),
                    child: TextField(
                      onSubmitted: (value) {
                        onSendMessage(textEditingController.text, TypeMessage.text);
                      },
                      style: TextStyle(color: ColorConstants.primaryColor, fontSize: 15),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: ColorConstants.greyColor),
                      ),
                      focusNode: focusNode,
                    ),
                  ),
                  AnimatedOpacity( opacity: RecordMp3.instance.status==RecordStatus.RECORDING?1:0,
                      duration: Duration(milliseconds: 150),
                  child: Text("Voice Recording"),)
                ],
              )
            ),
          ),

          // Button send message
          Material(
            child: Container(
              // margin: EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text, TypeMessage.text),
                color: ColorConstants.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              child: Container(
                  width: 50,
                  height: 50,
                  child: Card(
                    color: redColor,
                    shape:const CircleBorder(),
                      child: Icon(Icons.mic,color: !isRecording ? Colors.white:yellowColor,))),
              onLongPress: ()async{
                AudioPlayer.players.forEach((key, value) {
                  value.stop();
                });
                setState(() {
                  isRecording=true;
                });
                path=await getFilePath();
                // final status = await Permission.microphone.request();

                if(await Permission.microphone.isGranted){
                  RecordMp3.instance.start(path, (type){
                    return  setState(() {
                    });
                  });
                }else{
                  await Permission.microphone.request();
                }



                // record.startRecord(path);
              },
             onLongPressEnd: (val)async{
                setState(() {
                  isRecording=false;
                });
                RecordMp3.instance.stop();
               await uploadAudioFile();
             },
              onTap: (){},
            ),
          )
        ],
      ),
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
          border: Border(top: BorderSide(color: ColorConstants.greyColor2, width: 0.5)), color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
        stream: chatProvider.getChatStream(groupChatId, _limit),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            listMessage = snapshot.data.docs;
            if (listMessage.length > 0) {
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemBuilder: (context, index) => buildItem(index, snapshot.data?.docs[index]),
                itemCount: snapshot.data?.docs.length,
                reverse: true,
                controller: listScrollController,
              );
            } else {
              return Center(child: Text("No message here yet..."));
            }
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: redColor,
              ),
            );
          }
        },
      )
          : Center(
        child: CircularProgressIndicator(
          color: redColor,
        ),
      ),
    );
  }
}
