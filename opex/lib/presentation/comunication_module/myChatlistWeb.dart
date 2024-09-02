

// import 'dart:html';
import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'dart:html' as html;
import 'package:linkify/linkify.dart';
import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cluster/common_widgets/gradient_button.dart';
import 'package:cluster/common_widgets/loading.dart';
import 'package:cluster/common_widgets/string_extensions.dart';
import 'package:cluster/common_widgets/switch.dart';
import 'package:cluster/core/color_palatte.dart';
import 'package:cluster/core/common_snackBar.dart';
import 'package:cluster/core/utils/platform_check.dart';
import 'package:cluster/presentation/comunication_module/chat_screen/image_details_screen.dart';
import 'package:cluster/presentation/comunication_module/chat_type_model.dart';
import 'package:cluster/presentation/comunication_module/com_svg.dart';
import 'package:cluster/presentation/comunication_module/dummy_design_forTesting/dummy_user_list_model.dart';
import 'package:cluster/presentation/comunication_module/models/communicationuser_model.dart';
import 'package:cluster/presentation/comunication_module/videoplayerscreen.dart';
import 'package:cluster/presentation/comunication_module/web_chat_screen.dart';
import 'package:cluster/presentation/comunication_module/widgets/mousregion_widget.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voice_message_package/voice_message_package.dart';
import 'package:flutter/services.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class WebMyChatList extends StatefulWidget {
  final ChatModel messageList;
  final String? msgdate;
  final String? loginUserId;
  final bool isGroup;
  final String? formattedTime;
  final int? activeUsersLength;
  final ScrollController controller;
  final int? index;
  final String grpchatid;
  final String? roomid;
  final bool? seentick;
  final List<GroupUserList> grpmember;
  final Function( String) ontap;
  final Function? selectionChange;
  final Function replayFun;
  const WebMyChatList({super.key,
    required this.messageList,
    this.msgdate,
    this.loginUserId,
    this.isGroup=false,
    this.formattedTime,
    this.activeUsersLength,
    this.index,
    this.grpchatid="",
    this.roomid,
    required this.grpmember,
    this.seentick,
    required this.ontap, this.selectionChange, required this.replayFun, required this.controller
  });

  @override
  State<WebMyChatList> createState() => _WebMyChatListState();
}

class _WebMyChatListState extends State<WebMyChatList> {
  late String _localPath;
  Map<String, bool> _downloadStatus = {};
  Map<String, bool> _downloadloading = {};
  bool isHover=false;
  String flutterWebOrigin = html.window.location.origin;
  final GlobalKey<CustomSelectableLinkifyState> _customSelectableLinkfyState = GlobalKey<CustomSelectableLinkifyState>();

  @override
  void initState() {
    print("activelength chat page ${widget.activeUsersLength}");
    if(widget.messageList!.type=="image"){
      _downloadStatus[widget.messageList!.message??""] = false;
        _downloadloading[widget.messageList!.message??""] = false;
      // _checkDownloaded(widget.messageList!.message??"");
    }


    // TODO: implement initState
    super.initState();
  }

  List<customPopupmenuButton>item=[
    customPopupmenuButton(label: "Reply",value: "1"),
    // customPopupmenuButton(label: "Channel",value: "2"),

  ];

 bool isSelecting = false;
  String selectedText="";
  void _updateSelection(Offset localPosition,String url) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: url, style: TextStyle(color: Colors.blue)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final Offset globalPosition = (context.findRenderObject() as RenderBox).localToGlobal(localPosition);
    final TextPosition textPosition = textPainter.getPositionForOffset(globalPosition);

    final int startIndex = textPosition.offset - 1;
    final int endIndex = textPosition.offset;
    if (startIndex >= 0 && endIndex <= url.length) {
      setState(() {
        selectedText =url.substring(startIndex, endIndex);
      });
      print('Selected Text: $selectedText');
    }
  }

  // void setTrueAtIndex(List<bool> list, int index) {
  //   for (int i = 0; i <widge.length; i++) {
  //     if (i == index) {
  //       list[i] = true;
  //     } else {
  //       list[i] = false;
  //     }
  //   }
  // }
  // Future<void> _checkDownloaded(String imageUrl) async {
  //   _downloadStatus[imageUrl] = false;
  //   _downloadloading[imageUrl] = false;
  //   final directory = await getApplicationDocumentsDirectory();
  //   _localPath = directory.path;
  //   final filePath = '$_localPath/${imageUrl.split('/').last}';
  //   final file = File(filePath);
  //   //  bool exists = await _isImageInGallery(imageUrl);
  //   setState(() {
  //     _downloadStatus[imageUrl] = file.existsSync();
  //     _downloadloading[imageUrl] = file.existsSync();
  //   });
  // }
// Future<bool> _isImageInGallery(String imageUrl) async {
//   try {
//     // Request permission to read external storage
//     if (!(await Permission.storage.request().isGranted)) {
//       throw PlatformException(code: 'PERMISSION_DENIED', message: 'Storage permission not granted');
//     }

//     // Get the pictures directory
//     String picturesDirectory = await getPicturesDirectory( imageUrl);

//     // Check if the image exists in the pictures directory
//     String filePath = '$picturesDirectory/${imageUrl.split('/').last}';
//     bool exists = await File(filePath).exists();

//     return exists;
//   } catch (e) {
//     print('Error checking image existence: $e');
//     return false;
//   }
// }
// Future<String> getPicturesDirectory(String imageUrl) async {
//   try {
//     // Get the external storage directory
//     Directory? externalDir = await getExternalStorageDirectory();
//     if (externalDir == null) {
//       throw Exception('External storage directory not found');
//     }
//      String name=" ${imageUrl.split('?').first.split('/').last}";
//     // Navigate to the pictures directory (assuming it's named "Pictures")
//     String picturesPath = '${externalDir.path}/$name';
//     Directory picturesDir = Directory(picturesPath);
//     if (!await picturesDir.exists()) {
//       throw Exception('Pictures directory not found');
//     }

//     return picturesPath;
//   } catch (e) {
//     print('Error getting pictures directory: $e');
//     rethrow; // Re-throw the error for handling in the caller
//   }
// }


  // Future<void> _downloadImage(String imageUrl) async {
  //  print("download");
  //  _downloadloading[imageUrl] = true;
  //    final response = await http.get(Uri.parse(imageUrl));
  //    final directory = await getApplicationDocumentsDirectory();
  //    _localPath = directory.path;
  //    final filePath = '$_localPath/${imageUrl.split('/').last}';
  //    final file = File(filePath);
  //    await file.writeAsBytes(response.bodyBytes);
  //    _downloadStatus[imageUrl] = true;
  //    await ImageGallerySaver.saveFile(file.path);
  //    // await GallerySaver.saveImage(file.path);
  //    setState(() {});
  //  }




  Future<void> _downloadImage(String imageUrl) async {
    print("download $imageUrl");
    try {
      final response = await html.HttpRequest.request(imageUrl, responseType: 'blob');
      final blob = response.response as html.Blob;
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", imageUrl.split('/').last)
        ..click();
      html.Url.revokeObjectUrl(url);

      // Update your state accordingly
      setState(() {
        _downloadStatus[widget.messageList!.message ?? ""] = true;
        _downloadloading[widget.messageList!.message ?? ""] = true;
      });
    } catch (e) {
      // Handle any errors that occur during the download process
      print("Error downloading image: $e");
    }
  }






  Future<void> _downloadImage1(String imageUrl) async {
    print("download$imageUrl");



    final response = await http.get(Uri.parse(imageUrl),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
        // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET,POST, OPTIONS"
      },


    ); // Use suitable HTTP package for web
    final imageData = response.bodyBytes;

    // Simulating saving the image to a file (not possible in web directly)
    final blob = html.Blob([imageData]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", imageUrl.split('/').last)
      ..click();
    html.Url.revokeObjectUrl(url);

    // Update your state accordingly
    setState(() {
      // Update your state here
    });

    // final response = await http.get(Uri.parse(imageUrl));
    // final directory = await getApplicationDocumentsDirectory();
    // _localPath = directory.path;
    // final filePath = '$_localPath/${imageUrl.split('/').last}';
    // final file = File(filePath);
    // await file.writeAsBytes(response.bodyBytes);
    _downloadStatus[imageUrl] = true;
    // await ImageGallerySaver.saveFile(file.path);
    // await GallerySaver.saveImage(file.path);
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1 > 700
        ? 400
        : w1;
    print("String flutterWebOrigin = html.window.location.origin;${ widget.messageList.reply}${widget.messageList}${widget.messageList.chatSpace}");
    var h = MediaQuery.of(context).size.height;

        return Column(
          crossAxisAlignment:
          widget.messageList.fromuserid !=
              widget.loginUserId
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            widget.messageList.firstMessageOfDay == true ?
            Padding(
              padding: const EdgeInsets.only(top:5,left: 25,right: 25,bottom: 10),
              child: Center(
                child: Container(
                  padding: EdgeInsets.only(top:5,bottom:5,right: 10,left: 10),

                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Color.fromARGB(236, 233, 232, 232)
                  ),
                  child: Column(
                      children:[

                        Text(
                          "${widget.msgdate}",
                          textAlign: TextAlign.center,
                          softWrap: true,
                          style: const TextStyle(
                            color: Color(0xff151522),
                            fontSize: 12,
                          ),
                        )
                        ,]
                  ),
                ),
              ),
            ):Container(),

            if (widget.messageList!.fromuserid !=
                widget.loginUserId) ...{
              if (widget.isGroup == false ) ...{
                if (widget.messageList!.type == "image")...{
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        CustomImage(
                          loginid: widget.loginUserId??"",
                          replydata:widget.messageList.reply ,
                          onEvets: (val){
                            print("aaaaaaaaaaaa$val");
                            if(val=="1"){

                              _downloadImage(widget.messageList.message??"");

                            }
                            if(val=="2"){
                              widget.replayFun(1);

                            }
                            if(val=="3"){
                              widget.replayFun(3);
                            }

                          },

                          onTap: () {



                          },

                          keyValue:       "image ${widget.roomid}${widget.messageList.message}",
                          message:  widget.messageList
                              .message ??
                              "",
                          time: widget.formattedTime??"",






                        )
                      ],
                  )


                } else if (widget.messageList!.type ==
                    "audio") ...{
                  Column(
                    children: [
                      widget.messageList.reply!=null ?
                      Container(
                        width: w,
                        padding: EdgeInsets.only(top:5,right:5,bottom:5,left:7),
                        decoration: BoxDecoration(
                          // border: Border.all(color: ColorPalette.primary),
                            borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                            color: Color.fromARGB(209, 199, 219, 235)

                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.messageList.reply!.userid==widget.loginUserId?"you":"${widget.messageList.reply!.name.toString().toTitleCase()}",
                                style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                            Container(
                                child:
                                Stack(
                                  children: [
                                    Positioned(
                                        left:-1,
                                        top: 2,
                                        child: widget.messageList.reply!.type=="image"?Icon(Icons.image,size: 16,):widget.messageList.reply!.type=="video"?Icon(Icons.video_library,size: 16,):widget.messageList.reply!.type=="audio"?Icon(Icons.mic,size:16):widget.messageList.reply!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                    widget.messageList.reply!.type=="text"||widget.messageList.reply!.type=="mention"?
                                    Text("${widget.messageList.reply!.message}",
                                      softWrap: true,
                                      textScaler: TextScaler.linear(1),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,)
                                        :Padding(
                                      padding: const EdgeInsets.only(left:15),
                                      child: Text("${widget.messageList.reply!.message}",
                                        softWrap: true,
                                        textScaler: TextScaler.linear(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ):SizedBox(),
                    ],
                  ),
                  Stack(
                      children:[

                        Container(

                          key: new PageStorageKey(
                            "audio ${widget.roomid}${widget.messageList!.message}",),
                          // child: VoiceMessageView(controller: VoiceController(
                          //   audioSrc:  widget.messageList.message ?? "",
                          //   maxDuration: const Duration(hours:5),
                          //   isFile: false,
                          //   onComplete: () {},
                          //   onPause: () {},
                          //   onPlaying: () {},
                          // ),
                          //   me: false, audioSrc:  widget.messageList.message ?? "",
                          // )
                        ),
                        Positioned(
                          right: 6,
                          bottom: 5,
                          child: Text(
                            widget.formattedTime??"",
                            style: const TextStyle(
                              fontSize: 8,
                              color: Color(0xFF6D6D6D),
                            ),                                                           ),
                        ),
                      ]
                  )

                } else if (widget.messageList!.type ==
                    "video") ...{
                  Container(
                    key: new PageStorageKey(
                      "vedio ${widget.roomid}${widget.messageList!.message}",
                    ),
                    constraints:  BoxConstraints(
                      maxWidth: 277,
                      maxHeight:
                      MediaQuery.of(context)
                          .size
                          .height /
                          2.5,
                    ),
                    decoration: BoxDecoration(

                      // RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(10),
                        bottomLeft:
                        Radius.circular(10),
                        bottomRight:
                        Radius.circular(10),

                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                      // ),
                      color: Colors.white,
                    ),

                    child:
                    Column(
                      children: [
                        widget.messageList.reply!=null ?
                        Container(
                          width: w,
                          padding: EdgeInsets.only(top:5,right:5,bottom:5,left:7),
                          decoration: BoxDecoration(
                            // border: Border.all(color: ColorPalette.primary),
                              borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                              color: Color.fromARGB(209, 199, 219, 235)

                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.messageList.reply!.userid==widget.loginUserId?"you":"${widget.messageList.reply!.name.toString().toTitleCase()}",
                                  style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                              Container(
                                  child:
                                  Stack(
                                    children: [
                                      Positioned(
                                          left:-1,
                                          top: 2,
                                          child: widget.messageList.reply!.type=="image"?Icon(Icons.image,size: 16,):widget.messageList.reply!.type=="video"?Icon(Icons.video_library,size: 16,):widget.messageList.reply!.type=="audio"?Icon(Icons.mic,size:16):widget.messageList.reply!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                      widget.messageList.reply!.type=="text"||widget.messageList.reply!.type=="mention"?
                                      Text("${widget.messageList.reply!.message}",
                                        softWrap: true,
                                        textScaler: TextScaler.linear(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,)
                                          :Padding(
                                        padding: const EdgeInsets.only(left:15),
                                        child: Text("${widget.messageList.reply!.message}",
                                          softWrap: true,
                                          textScaler: TextScaler.linear(1),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ):SizedBox(),
                        Stack(
                            children:[
                              VideoPlayerScreen(
                                autoplay: false,
                                looping: true,
                                me: false,
                                videoUrl:widget.messageList!.message ?? "",
                                alignmentGeometry: Alignment.topLeft,
                                // videoPlayerController:
                                //     VideoPlayerController.network(
                                //   messageList[index].message ?? "",
                                // ),
                              ),
                              Positioned(
                                right: 6,
                                bottom: 0,
                                child: Text(
                                  widget.formattedTime??"",
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF6D6D6D),
                                  ),                                                           ),
                              ),
                            ]
                        ),
                      ],
                    ),
                  )


                } else if (widget.messageList!.type ==
                    "file") ...{
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.start,
                    children: [
                      Container(
                        width: w / 1.63,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(0),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(11),
                            bottomRight:
                            Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          8),
                                      color: Colors.white),
                                  child: SvgPicture.string(
                                      CommunicationSvg().docIcon2),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  width: w / 2.2,
                                  height: 45,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(
                                        10),
                                    boxShadow: [
                                      const BoxShadow(
                                        color:
                                        Color(0x05000000),
                                        blurRadius: 8,
                                        offset: Offset(1, 1),
                                      ),
                                    ],
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets
                                      .symmetric(horizontal: 8),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Container(
        // width: 100,
                                        child: Text(
                                          // messageList[index].message ??
                                            "${ widget.messageList!.message!.split('?').first.split('/').last}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.roboto(textStyle:TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                            ),)
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      // Text(
                                      //   "21.54 Mb",
                                      //   style: TextStyle(
                                      //     color: Color(0xff333333),
                                      //     fontSize: 12,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 3,
                              bottom: -4,
                              child: Text(
                                widget.formattedTime??"",
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Color(0xFF6D6D6D),
                                ),                                                           ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                          onTap: () async {
                            final url = widget.messageList!
                                .message ??
                                "";
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              throw 'Could not launch $url';
                            }
                          },
                          child: SvgPicture.string(
                              CommunicationSvg().dwnldIcon)),
                    ],
                  ),
                } else ...{
                  Align(
                    alignment: Alignment.bottomLeft,
                    child:  GestureDetector(
    // onTapDown: (val){
    //   _customSelectableLinkfyState.currentState?.handleTapDown(val);
    // },
                      onLongPress: (){
                        widget.ontap( widget.messageList
                            .message??"");
                      },
                      onPanStart: (details) {
                        setState(() {
                          isSelecting = true;
                        });
                        _updateSelection(details.localPosition,widget.messageList.message??"");
                      },
                      onPanUpdate: (details) {
                        _updateSelection(details.localPosition,widget.messageList.message??"");



                      },
                      child: Container(
                        // padding: EdgeInsets.all(10),
                                      constraints: BoxConstraints(
                      minWidth:
                      70,
                      maxWidth:
                      MediaQuery.of(context)
                          .size
                          .width/3,),
                        child: CustomMouseRegion(
                          onExist: (){
                            isHover=true;
                          },
                          onEnter: (){
                            isHover=false;
                          },
                          child: Container(
                            // elevation: 1,
                            decoration: BoxDecoration(
                              // RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(3),
                                bottomLeft:
                                Radius.circular(10),
                                bottomRight:
                                Radius.circular(10),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  offset: Offset(0, 1), // changes position of shadow
                                ),
                              ],
                              // ),
                              color: Colors.white,
                            ),
                            // shape:

                            // margin: const EdgeInsets.symmetric(
                            //     horizontal: 15, vertical: 5),
                            child: Stack(
                              // mainAxisSize: MainAxisSize.min,
                              children: [

                                Padding(
                                  padding:
                                  const EdgeInsets.only(
                                    left: 10,
                                    right:10,
                                    top:20,
                                    bottom: 17,
                                  ),
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      widget.messageList.reply!=null ?
                                      Container(
                                        width: w,
                                        padding: EdgeInsets.only(top:5,right:25,bottom:5,left:7),
                                        decoration: BoxDecoration(
                                          // border: Border.all(color: ColorPalette.primary),
                                            borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                                            color: Color.fromARGB(209, 199, 219, 235)

                                        ),
                                        child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(widget.messageList.reply!.userid==widget.loginUserId?"you":"${widget.messageList.reply!.name.toString().toTitleCase()}",
                                                style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                                            Container(
                                                child:
                                                Stack(
                                                  children: [
                                                    Positioned(
                                                        left:-1,
                                                        top: 2,
                                                        child: widget.messageList.reply!.type=="image"?Icon(Icons.image,size: 16,):widget.messageList.reply!.type=="video"?Icon(Icons.video_library,size: 16,):widget.messageList.reply!.type=="audio"?Icon(Icons.mic,size:16):widget.messageList.reply!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                                    widget.messageList.reply!.type=="text"||widget.messageList.reply!.type=="mention"?
                                                    Text("${widget.messageList.reply!.message}",
                                                      softWrap: true,
                                                      textScaler: TextScaler.linear(1),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,)
                                                        :Padding(
                                                      padding: const EdgeInsets.only(left:15),
                                                      child: Text("${widget.messageList.reply!.message}",
                                                        softWrap: true,
                                                        textScaler: TextScaler.linear(1),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,),
                                                    ),
                                                  ],
                                                )
                                            )
                                          ],
                                        ),
                                      ):SizedBox(),
                                CustomSelectableLinkify(text: widget.messageList.message??"",   key: _customSelectableLinkfyState,linkStyle: TextStyle(
                                    color: Colors.blue,
                                    decorationColor: Colors.blue

                                    // decoration: TextDecoration.underline,
                                    ),


                                    selectionChange:(index,{bool? val=false}){
                                  if(widget.selectionChange!=null)
                                      widget.selectionChange!(index,val:val??false);
                                    } ,
                                    linkifiers: [
                                    EmailLinkifier(),
                                    UrlLinkifier()
                                    ], onOpen: _openLink, index: widget.index, selectionChange1:(){
                                  if(widget.selectionChange!=null){
                                    widget.selectionChange!;
                                  }
                                  }, isSelected: widget.messageList.isSelectable==true?true:false, messageList: widget.messageList,),
                                    // GestureDetector(
                                    //
                                    //   onPanStart: (details) {
                                    //
                                    //     _updateSelection(details.localPosition,widget.messageList.message??"");
                                    //   },
                                    //   onPanUpdate: (details) {
                                    //     print("selection startttt1");
                                    //     _updateSelection(details.localPosition,widget.messageList.message??"");
                                    //
                                    //
                                    //   },
                                    //   child:
                                    //   SelectableLinkify(
                                    //     onOpen: (link) => _openLink(link),
                                    //     text: widget.messageList.message??"",
                                    //
                                    //     linkStyle: TextStyle(
                                    //         color: Colors.blue,
                                    //         decorationColor: Colors.blue
                                    //       // decoration: TextDecoration.underline,
                                    //     ),
                                    //     linkifiers: [
                                    //       EmailLinkifier(),
                                    //       UrlLinkifier()
                                    //     ],
                                    //     //
                                    //     onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
                                    //       if (selection.baseOffset != selection.extentOffset) {
                                    //         print("selection startttt$selection");
                                    //         isSelecting = true;
                                    //         if(widget.selectionChange!=null){
                                    //           widget.selectionChange!(widget.index);
                                    //         }
                                    //         // Text is selected
                                    //
                                    //       } else {
                                    //         // Text is not selected
                                    //
                                    //       }
                                    //     },
                                    //
                                    //     selectionControls: isSelecting ? CustomTextSelectionControls() : null,
                                    //
                                    //
                                    //   ),
                                    // ),



                                      // Theme(data: Theme.of(context).copyWith(
                                      //     textSelectionTheme: TextSelectionThemeData(
                                      //         selectionColor:widget.messageList.isSelectable==true? Colors.grey.withOpacity(.2):Colors.transparent)),
                                      //   child: SelectableLinkify(
                                      //     onTap: (){
                                      //       Clipboard.setData(ClipboardData(text: widget.messageList.message ?? ""));
                                      //       // Fluttertoast.showToast(
                                      //       //   msg: 'URL copied to clipboard',
                                      //       //   toastLength: Toast.LENGTH_SHORT,
                                      //       //   gravity: ToastGravity.BOTTOM,
                                      //       //   timeInSecForIosWeb: 1,
                                      //       //   backgroundColor: Colors.grey,
                                      //       //   textColor: Colors.white,
                                      //       //   fontSize: 16.0,
                                      //       // );
                                      //       print("Akshay selectable");
                                      //     },
                                      //     linkifiers:  [
                                      //
                                      //       EmailLinkifier(),
                                      //       UrlLinkifier(),
                                      //
                                      //     ],
                                      //
                                      //
                                      //     onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
                                      //       if (selection.baseOffset != selection.extentOffset) {
                                      //         if(widget.selectionChange!=null){
                                      //           widget.selectionChange!(widget.index);
                                      //         }
                                      //         // Text is selected
                                      //
                                      //       } else {
                                      //         // Text is not selected
                                      //         setState(() {
                                      //           print("testing case in false");
                                      //         });
                                      //       }
                                      //     },
                                      //     linkStyle: TextStyle(decorationColor: Colors.blue,color: Colors.red),
                                      //     onOpen: (link) async {
                                      //       if (!await launchUrl(Uri.parse(link.url))) {
                                      //         throw Exception('Could not launch ${link.url}');
                                      //       }
                                      //     },
                                      //     text: widget.messageList
                                      //         .message ??
                                      //         "",
                                      //
                                      //     textAlign: TextAlign.left,
                                      //
                                      //
                                      //
                                      //
                                      //
                                      //     style:  TextStyle(
                                      //         fontSize:isMobile?w/29:w/27,
                                      //         color: Colors.black),
                                      //   ),
                                      // ),

                                      // Text(
                                      // widget.messageList!
                                      //         .message ??
                                      //     "",
                                      //     textAlign: TextAlign.left,
                                      // style: const TextStyle(
                                      //     fontSize: 16,
                                      //     color: Colors.black),
                                      // ),
                                      SizedBox(height: 2,),

                                    ],
                                  ),
                                ),
                                Positioned(
                                  right: 5,
                                  bottom: 5,
                                  child: Text(
                                    widget.formattedTime??"",
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Color(0xFF6D6D6D),
                                    ),                                                           ),
                                ),
                                Positioned(
                                    right: 0,
                                    top:-1,
                                    child:Container(
                                      width: 30,
                                      height:30,
                                      margin: EdgeInsets.only(right:0),
                                      child: AdminTableDotIcon(
                                        height: 25,
                                        clr: Colors.transparent,
                                        iconClr: Colors.black,
                                        icons: Icons.expand_more,
                                        iconSize:20,

                                        mouseHoverFunc: (val){

                                        },
                                        valueList: item,
                                        onTap: (val){
                                          if(val=="1"){
                                            widget.replayFun(1); // widget.r
                                          }
                                          // if(widget.onEvets!=null){widget.onEvets!(val);}



                                        },),
                                    )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                }
              }
              else ...{
                if(widget.messageList.type=="notify")...{
                  Padding(
                    padding: const EdgeInsets.only(top:10,left: 25,right: 25,bottom: 10),
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(top:5,bottom:5,left:5,right:5),
                        constraints: const BoxConstraints(
                          maxWidth: 250,
                        ),

                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color.fromARGB(236, 233, 232, 232)
                        ),
                        child: Text(
                          "${widget.messageList
                              .message.toString()}"
                          ,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 5,
                          style: const TextStyle(
                            color: Color(0xff151522),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  )

                } else...{
                  Row(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                 if(widget.messageList.chatSpace==true)     GestureDetector(
                        onTap: ()async{
                          await showDialog(
                              context: context,
                              builder: (_) => imageDialog(widget.messageList!
                                  .fromUser
                                  ?.name,widget.messageList!.fromUser!.photo??"",context)
                          );
                        },
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:widget.messageList!.fromUser!.photo ==null ||widget.messageList!.fromUser!.photo!.isEmpty? CircleAvatar(
                                backgroundColor: Colors.white,
                                radius:18,
                                child: TextAvatar(
                                  shape: Shape.Circular,
                                  size: 14,
                                  numberLetters: 2,
                                  fontSize: w/23,
                                  textColor: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  text:"${widget.messageList!.fromUser?.name.toString().toTitleCase()}" ,
                                )
                            ):CircleAvatar(
                              backgroundColor: Colors.white,
                              radius:18,
                              backgroundImage: NetworkImage(widget.messageList!.fromUser!.photo??""),
                            )
                        ),
                      ),
                      SizedBox(width:widget.messageList.chatSpace==true? 5:35),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5,),
                          if(widget.messageList.chatSpace==true)             Text(
                            widget.messageList!
                                .fromUser
                                ?.name.toString().toTitleCase() ??
                                "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color(0xff151522),
                              fontSize: 12,
                            ),
                          ),

                          if (widget.messageList!.type ==
                              "image") ...{
                            CustomImage(
                              loginid: widget.loginUserId??"",
                              replydata:widget.messageList.reply ,
                              onEvets: (val){
                                print("aaaaaaaaaaaa$val");
                                if(val=="1"){

                                  _downloadImage(widget.messageList.message??"");

                                }
                                if(val=="2"){
                                  widget.replayFun(1);

                                }
                                if(val=="3"){
                                  widget.replayFun(3);
                                }

                              },

                              onTap: () {



                              },

                              keyValue:       "image ${widget.roomid}${widget.messageList.message}",
                              message:  widget.messageList
                                  .message ??
                                  "",
                              time: widget.formattedTime??"",






                            )
                            // InkWell(
                            //     onTap: () {
                            //       _downloadStatus[widget.messageList?.message??""] ==false?null:
                            //       Navigator.push(context,
                            //           MaterialPageRoute(
                            //               builder: (_) {
                            //                 return DetailScreen(
                            //                   image:
                            //                   widget.messageList!
                            //                       .message ??
                            //                       "",
                            //                 );
                            //               }));
                            //     },
                            //     child: Container(
                            //       margin: EdgeInsets.symmetric(vertical: 5),
                            //         key:new PageStorageKey(widget.messageList!.message??"") ,
                            //         width: w / 1.5,
                            //         padding:
                            //         const EdgeInsets.all(
                            //             4),
                            //         decoration:
                            //         const BoxDecoration(
                            //             borderRadius:
                            //             BorderRadius.only(
                            //               topLeft:
                            //               Radius.circular(
                            //                   0),
                            //               topRight:
                            //               Radius.circular(
                            //                   10),
                            //               bottomLeft:
                            //               Radius.circular(
                            //                   10),
                            //               bottomRight:
                            //               Radius.circular(
                            //                   10),
                            //             ),
                            //             color: Colors.white
                            //         ),
                            //         alignment:
                            //         Alignment.topLeft,
                            //         child: Column(
                            //           children: [
                            //             // Row(children: [CupertinoContextMenu(child: Icon(Icons.arrow_drop_down,size: 30,),actions: [
                            //             //   CupertinoContextMenuAction(
                            //             //     child: Text("Download"),
                            //             //     onPressed: (){
                            //             //       _downloadImage(widget.messageList.message??"");
                            //             //     },
                            //             //     isDestructiveAction: true,
                            //             //   ), CupertinoContextMenuAction(
                            //             //     child: Text("Download"),
                            //             //     onPressed: (){
                            //             //       _downloadImage(widget.messageList.message??"");
                            //             //     },
                            //             //     isDestructiveAction: true,
                            //             //   ),
                            //             // ],)],),
                            //             Container(
                            //                 width: w / 1.5,
                            //                 padding: const EdgeInsets.all(4),
                            //                 decoration: const BoxDecoration(
                            //                   borderRadius: BorderRadius.only(
                            //                     topLeft: Radius.circular(0),
                            //                     topRight: Radius.circular(10),
                            //                     bottomLeft: Radius.circular(10),
                            //                     bottomRight: Radius.circular(10),
                            //                   ),
                            //
                            //                 ),
                            //                 alignment: Alignment.topRight,
                            //                 child: Stack(
                            //                   children: [
                            //                     // Positioned(
                            //                     //   top: 130,
                            //                     //   child:
                            //                     //   Row(children: [CupertinoContextMenu(child: Icon(Icons.arrow_drop_down,size: 30,),actions: [
                            //                     //     CupertinoContextMenuAction(
                            //                     //       child: Text("Download"),
                            //                     //       onPressed: (){
                            //                     //         _downloadImage(widget.messageList.message??"");
                            //                     //       },
                            //                     //       isDestructiveAction: true,
                            //                     //     ), CupertinoContextMenuAction(
                            //                     //       child: Text("Download"),
                            //                     //       onPressed: (){
                            //                     //         _downloadImage(widget.messageList.message??"");
                            //                     //       },
                            //                     //       isDestructiveAction: true,
                            //                     //     ),
                            //                     //   ],)],),
                            //                     // ),
                            //                     Container(
                            //                       key: new PageStorageKey(
                            //                         "image ${widget.roomid}${widget.messageList.message}",
                            //                       ),
                            //                       constraints: BoxConstraints(
                            //                         maxHeight:
                            //                         MediaQuery.of(context)
                            //                             .size
                            //                             .height /
                            //                             2.5,
                            //                       ),
                            //                       decoration: BoxDecoration(
                            //                         borderRadius: BorderRadius.only(
                            //                             topLeft:
                            //                             Radius.circular(
                            //                                 6),
                            //                             topRight:
                            //                             Radius.circular(
                            //                                 6),
                            //                             bottomLeft:
                            //                             Radius.circular(
                            //                                 6),
                            //                             bottomRight:
                            //                             Radius.circular(
                            //                                 0)),
                            //                       ),
                            //                       width: w,
                            //                       child: Stack(
                            //                         fit: StackFit.expand,
                            //                         children: [
                            //
                            //                           Image(
                            //                               loadingBuilder:
                            //                                   (context,
                            //                                   child,
                            //                                   loadingProgress) {
                            //                                 if (loadingProgress ==
                            //                                     null)
                            //                                   return child;
                            //                                 return const SizedBox(
                            //                                   child: Center(
                            //                                       child: CircularProgressIndicator(
                            //                                         color: Color.fromRGBO(255, 255, 255, 1),
                            //                                       )),
                            //                                 );
                            //                               },
                            //                               fit: BoxFit.cover,
                            //                               image: ResizeImage(policy:ResizeImagePolicy.fit,
                            //                                   NetworkImage(
                            //                                       widget.messageList
                            //                                           .message ??
                            //                                           ""),width:700,height:800,allowUpscaling: true)),
                            //                           Positioned(child: Container(
                            //                             height: 40,
                            //                             width: 40,
                            //                             child: CupertinoContextMenu(
                            //                                 child: Icon(Icons.arrow_drop_down_rounded),
                            //                               actions: [
                            //                                 CupertinoContextMenuAction(
                            //                                   child:Text("Save to device"),
                            //                                   onPressed: (){
                            //                                     Navigator.of(context).pop();
                            //                                   },
                            //                                 ),
                            //                                 CupertinoContextMenuAction(
                            //                                   child: Text("Delete"),
                            //                                   onPressed: (){
                            //                                     Navigator.of(context).pop();
                            //                                   },
                            //                                   isDestructiveAction: true,
                            //                                 )
                            //                               ],
                            //                             ),
                            //                           )),
                            //                           Positioned(child:_downloadStatus[widget.messageList.message??""]==false?
                            //                           InkWell(
                            //                               onTap: () {
                            //                                 _downloadloading[widget.messageList.message??""]=true;
                            //                                 _downloadImage(widget.messageList.message??"");
                            //                                 setState(() {
                            //
                            //                                 });
                            //                               },
                            //                               child:_downloadloading[widget.messageList.message??""]==false?  Padding(
                            //                                 padding:  EdgeInsets.only(right:w/6,left:w/6,top:h/6.1,bottom:h/6.1),
                            //                                 child: Container(
                            //                                     padding: EdgeInsets.all(10),
                            //                                     decoration: ShapeDecoration(
                            //                                       color: Colors.white.withOpacity(0.7900000214576721),
                            //                                       shape: RoundedRectangleBorder(
                            //                                         borderRadius: BorderRadius.circular(36),
                            //                                       ),
                            //                                     ),
                            //
                            //                                     child: SvgPicture.string(CommunicationSvg().imageIcon)),
                            //                               )
                            //                                   :Padding(
                            //                                 padding:  EdgeInsets.only(right:w/4,left:w/4,top:h/6.1,bottom:h/6.1),
                            //                                 child: InkWell(
                            //                                   onTap: () {
                            //                                     _downloadImage(widget.messageList.message??"");
                            //                                   },
                            //                                   child: Container(
                            //                                       width: 50,
                            //                                       height: 40,
                            //                                       padding: EdgeInsets.all(10),
                            //                                       decoration: ShapeDecoration(
                            //                                         color: Colors.white.withOpacity(0.7900000214576721),
                            //                                         shape: RoundedRectangleBorder(
                            //                                           borderRadius: BorderRadius.circular(36),
                            //                                         ),
                            //                                       ),
                            //
                            //                                       child:customCupertinoLoading()),
                            //                                 ),
                            //                               )):SizedBox()),
                            //                         ],
                            //                       ),
                            //                     ),
                            //                     const SizedBox(
                            //                       height: 3,
                            //                     ),
                            //                     Row(
                            //                       mainAxisAlignment:
                            //                       MainAxisAlignment.end,
                            //                       children: [
                            //                         Text(
                            //                           widget.formattedTime??"",
                            //                           style: const TextStyle(
                            //                             fontSize: 8,
                            //                             color: Colors.black,
                            //                           ),
                            //                         ),
                            //
                            //                       ],
                            //                     ),
                            //                   ],
                            //                 )),
                            //             const SizedBox(
                            //               height: 3,
                            //             ),
                            //             Row(
                            //               mainAxisAlignment:
                            //               MainAxisAlignment
                            //                   .end,
                            //               children: [
                            //                 Text(
                            //                   widget.formattedTime??"",
                            //                   style: const TextStyle(
                            //                     fontSize: 8,
                            //                     color: Color(0xFF6D6D6D),
                            //                   ),
                            //                 ),
                            //
                            //               ],
                            //             ),
                            //           ],
                            //         )))
                          } else if (widget.messageList!
                              .type ==
                              "audio") ...{

                            Stack(
                                children:[
                                  Container(

                                    key: new PageStorageKey(
                                      "image ${widget.roomid}${widget.messageList!.message}",),
                                    // child: 
                                    // VoiceMessageView(controller: VoiceController(
                                    //   audioSrc:  widget.messageList.message ?? "",
                                    //   maxDuration: const Duration(hours:5),
                                    //   isFile: false,
                                    //   onComplete: () {},
                                    //   onPause: () {},
                                    //   onPlaying: () {},
                                    // ),
                                    //   me: false, audioSrc:  widget.messageList.message ?? "",
                                    // )
                                  ),
                                  Positioned(
                                    right: 6,
                                    bottom: 5,
                                    child: Text(
                                      widget.formattedTime??"",
                                      //   messageList[index]
                                      //     .createdAt ??
                                      // "",
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color(0xFF6D6D6D),
                                      ),
                                    ),
                                  ),
                                ]
                            )

                          } else if (widget.messageList!
                              .type ==
                              "file") ...{
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: w / 1.6,
                                  padding: const EdgeInsets
                                      .symmetric(
                                      vertical: 10,
                                      horizontal: 8),
                                  decoration:
                                  const BoxDecoration(
                                    borderRadius:
                                    BorderRadius.only(
                                      topLeft:
                                      Radius.circular(0),
                                      topRight:
                                      Radius.circular(10),
                                      bottomLeft:
                                      Radius.circular(10),
                                      bottomRight:
                                      Radius.circular(10),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 45,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(
                                                    8),
                                                color:
                                                Colors.white),
                                            child:
                                            SvgPicture.string(
                                                CommunicationSvg()
                                                    .docIcon2),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Container(
                                            width: w / 2,
                                            height: 45,
                                            decoration:
                                            BoxDecoration(
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  10),
                                              boxShadow: [
                                                const BoxShadow(
                                                  color: Color(
                                                      0x05000000),
                                                  blurRadius: 8,
                                                  offset: Offset(
                                                      1, 1),
                                                ),
                                              ],
                                              color: Colors.white,
                                            ),
                                            padding:
                                            const EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                8),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                Text(
                                                  // messageList[index]
                                                  //         .message ??
                                                  "${ widget.messageList!.message!.split('?').first.split('/').last}",
                                                  overflow: TextOverflow.ellipsis,
                                                  style:
                                                  GoogleFonts.roboto(textStyle: TextStyle(
                                                    color: Colors
                                                        .black,
                                                    fontSize:13,
                                                  ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                    height: 4),
                                                // Text(
                                                //   "21.54 Mb",
                                                //   style: TextStyle(
                                                //     color: Color(0xff333333),
                                                //     fontSize: 12,
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 3,
                                        bottom: -4,
                                        child: Text(
                                          widget.formattedTime??"",
                                          //   messageList[index]
                                          //     .createdAt ??
                                          // "",
                                          style: const TextStyle(
                                            fontSize: 8,
                                            color: Color(0xFF6D6D6D),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                InkWell(
                                    onTap: () async {
                                      final url =
                                          widget.messageList!
                                              .message ??
                                              "";
                                      if (await canLaunch(
                                          url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: SvgPicture.string(
                                      CommunicationSvg().dwnldIcon,)),
                              ],
                            ),
                          } else if (widget.messageList!
                              .type ==
                              "video") ...{
                            Container(
                              constraints:  BoxConstraints(
                                maxWidth: 277,
                                maxHeight:
                                MediaQuery.of(context)
                                    .size
                                    .height /
                                    2.5,
                              ),
                              decoration: BoxDecoration(

                                // RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(10),
                                  bottomLeft:
                                  Radius.circular(10),
                                  bottomRight:
                                  Radius.circular(10),

                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    offset: Offset(0, 1), // changes position of shadow
                                  ),
                                ],
                                // ),
                                color: Colors.white,
                              ),
                              key: new PageStorageKey(
                                "vedio ${widget.roomid}${widget.messageList!.message}",
                              ),
                              child:Stack(
                                  children:[
                                    VideoPlayerScreen(
                                      autoplay: false,
                                      looping: true,
                                      me: false,
                                      videoUrl: widget.messageList!.message ?? "",
                                      alignmentGeometry: Alignment.topLeft,
                                      // videoPlayerController:
                                      //     VideoPlayerController.network(
                                      //   messageList[index].message ?? "",
                                      // ),
                                    ),
                                    Positioned(
                                      right: 6,
                                      bottom: 0,
                                      child: Text(
                                        widget.formattedTime??"",
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Color(0xFF6D6D6D),
                                        ),                                                           ),
                                    ),
                                  ]
                              ),
                            )

                          } else if(widget.messageList!
                              .type ==
                              "mention")...{
                            Column(crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    constraints: BoxConstraints(
                                      minWidth:
                                      25,
                                      maxWidth:
                                      MediaQuery.of(context)
                                          .size
                                          .width/3,),
                                    child: GestureDetector(
                                      onLongPress: (){ widget.ontap( widget.messageList
                                          .message??"");},
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(0),
                                            topRight: Radius.circular(10),
                                            bottomLeft:
                                            Radius.circular(10),
                                            bottomRight:
                                            Radius.circular(10),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey.withOpacity(0.5),
                                              offset: Offset(0, 1), // changes position of shadow
                                            ),
                                          ],
                                          // ),
                                          color: Colors.white,
                                        ),
                                        // margin: const EdgeInsets
                                        //         .symmetric(
                                        //     horizontal: 15,
                                        //     vertical: 5),
                                        child:  Stack(
                                          // mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding:
                                              const EdgeInsets.only(
                                                left: 10,
                                                right:20,
                                                top:7,
                                                bottom: 17,
                                              ),
                                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  MentionText(
                                                    text: widget.messageList! .message ??"",
                                                    grpmember: widget.grpmember,
                                                    mentionStyle: TextStyle(color: getRandomColor(),fontSize:PlatformUtils.isMobile? w/29:w/27),),
                                                  // Text(
                                                  // widget.messageList!
                                                  //         .message ??
                                                  //     "",
                                                  //     softWrap: true,
                                                  //     textAlign: TextAlign.left,
                                                  // style: const TextStyle(
                                                  //     fontSize: 16,
                                                  //     color: Colors.black),
                                                  // ),
                                                  SizedBox(height: 5,),

                                                ],
                                              ),
                                            ),
                                            Positioned(
                                              right: 6,
                                              bottom: 5,
                                              child: Text(
                                                widget.formattedTime??"",
                                                //   messageList[index]
                                                //     .createdAt ??
                                                // "",
                                                style: const TextStyle(
                                                  fontSize: 8,
                                                  color: Color(0xFF6D6D6D),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Row(
                                  //   mainAxisAlignment:
                                  //       MainAxisAlignment.start,
                                  //   children: [
                                  //     Text(
                                  //       messageList[index]
                                  //               .createdAt ??
                                  //           "",
                                  //       style: const TextStyle(
                                  //           fontSize: 13,
                                  //           color: Color(
                                  //               0xFF6D6D6D)),
                                  //     ),
                                  //   ],
                                  // ),
                                ])
                          }
                          else ...{

                              Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      // padding: EdgeInsets.all(10),
                                      constraints: BoxConstraints(
                                        minWidth:
                                        70,
                                        maxWidth:
                                        MediaQuery.of(context)
                                            .size
                                            .width/3,
                                      ),
                                      child: GestureDetector(
                                        onLongPress: (){
                                          widget.ontap( widget.messageList
                                              .message??"");
                                        },
        onPanStart: (details) {
        setState(() {
        isSelecting = true;
        });
        _updateSelection(details.localPosition,widget.messageList.message??"");
        },
        onPanUpdate: (details) {
        _updateSelection(details.localPosition,widget.messageList.message??"");



                                      },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            // RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(0),
                                              topRight: Radius.circular(10),
                                              bottomLeft:
                                              Radius.circular(10),
                                              bottomRight:
                                              Radius.circular(10),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey.withOpacity(0.5),
                                                offset: Offset(0, 1), // changes position of shadow
                                              ),
                                            ],
                                            // ),
                                            color: Colors.white,
                                          ),
                                          // margin: const EdgeInsets
                                          //         .symmetric(
                                          //     horizontal: 15,
                                          //     vertical: 5),
                                          child:  Stack(
                                            // mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(
                                                  left: 10,
                                                  right:10,
                                                  top:20,
                                                  bottom: 17,
                                                ),
                                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    widget.messageList.reply!=null ?
                                                    Container(
                                                      width: w,
                                                      padding: EdgeInsets.only(top:5,right:25,bottom:5,left:7),
                                                      decoration: BoxDecoration(
                                                        // border: Border.all(color: ColorPalette.primary),
                                                          borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                                                          color: Color.fromARGB(209, 199, 219, 235)

                                                      ),
                                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(widget.messageList.reply!.userid==widget.loginUserId?"you":"${widget.messageList.reply!.name.toString().toTitleCase()}",
                                                              style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                                                          Container(
                                                              child:
                                                              Stack(
                                                                children: [
                                                                  Positioned(
                                                                      left:-1,
                                                                      top: 2,
                                                                      child: widget.messageList.reply!.type=="image"?Icon(Icons.image,size: 16,):widget.messageList.reply!.type=="video"?Icon(Icons.video_library,size: 16,):widget.messageList.reply!.type=="audio"?Icon(Icons.mic,size:16):widget.messageList.reply!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                                                  widget.messageList.reply!.type=="text"||widget.messageList.reply!.type=="mention"?
                                                                  Text("${widget.messageList.reply!.message}",
                                                                    softWrap: true,
                                                                    textScaler: TextScaler.linear(1),
                                                                    maxLines: 1,
                                                                    overflow: TextOverflow.ellipsis,)
                                                                      :Padding(
                                                                    padding: const EdgeInsets.only(left:15),
                                                                    child: Text("${widget.messageList.reply!.message}",
                                                                      softWrap: true,
                                                                      textScaler: TextScaler.linear(1),
                                                                      maxLines: 1,
                                                                      overflow: TextOverflow.ellipsis,),
                                                                  ),
                                                                ],
                                                              )
                                                          )
                                                        ],
                                                      ),
                                                    ):SizedBox(),
                                                    Container(
                                                      constraints: BoxConstraints(
                                                        minWidth:
                                                        70,
                                                        minHeight:
                                                        25,
                                                        maxHeight:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height/3,
                                                      ),
                                                      child:                        CustomSelectableLinkify(text: widget.messageList.message??"",   linkStyle: TextStyle(
                                                          color: Colors.blue,
                                                          decorationColor: Colors.blue

                                                        // decoration: TextDecoration.underline,
                                                      ),


                                                        selectionChange:(index,{bool? val=false}){
                                                          if(widget.selectionChange!=null)
                                                            widget.selectionChange!(index,val:val??false);
                                                        } ,
                                                        linkifiers: [
                                                          EmailLinkifier(),
                                                          UrlLinkifier()
                                                        ], onOpen: _openLink, index: widget.index, selectionChange1:(){
                                                          if(widget.selectionChange!=null){
                                                            widget.selectionChange!;
                                                          }
                                                        }, isSelected: widget.messageList.isSelectable==true?true:false, messageList: widget.messageList,),

                                                      //     selectionAreaColorChange(context,
                                                      //   isSected:widget.messageList.isSelectable==true? true:false ,
                                                      //   child: GestureDetector(
                                                      //     onPanStart: (details) {
                                                      //       setState(() {
                                                      //         isSelecting = true;
                                                      //       });
                                                      //       _updateSelection(details.localPosition,widget.messageList.message??"");
                                                      //     },
                                                      //     onPanUpdate: (details) {
                                                      //       _updateSelection(details.localPosition,widget.messageList.message??"");
                                                      //
                                                      //     },
                                                      //     child:
                                                      //       SelectableLinkify(
                                                      //         onOpen: (link) => _openLink(link),
                                                      //         text: widget.messageList.message??"",
                                                      //         linkStyle: TextStyle(
                                                      //           color: Colors.blue,
                                                      //           // decoration: TextDecoration.underline,
                                                      //         ),
                                                      //         onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
                                                      //           if (selection.baseOffset != selection.extentOffset) {
                                                      //             print("selection startttt");
                                                      //             if(widget.selectionChange!=null){
                                                      //               widget.selectionChange!(widget.index);
                                                      //             }
                                                      //             // Text is selected
                                                      //
                                                      //           } else {
                                                      //             // Text is not selected
                                                      //             setState(() {
                                                      //               print("testing case in false");
                                                      //             });
                                                      //           }
                                                      //         },
                                                      //         linkifiers: [
                                                      //           EmailLinkifier(),
                                                      //           UrlLinkifier()
                                                      //         ],
                                                      //
                                                      //         selectionControls: isSelecting ? CustomTextSelectionControls() : null,
                                                      //
                                                      //       ),
                                                      //   ),
                                                      // ),
                                                    ),
                                                   // Theme(data: Theme.of(context).copyWith(
                                                   //      textSelectionTheme: TextSelectionThemeData(
                                                   //        selectionHandleColor: Colors.orange,
                                                   //          selectionColor:widget.messageList.isSelectable==true? Colors.grey.withOpacity(.2):Colors.transparent)),
                                                   //    child: SelectableLinkify(
                                                   //      onTap: (){
                                                   //        print("String flutterWebOrigin = html.window.location.origin;$flutterWebOrigin");
                                                   //        Clipboard.setData(ClipboardData(text: widget.messageList.message ?? ""));
                                                   //        // Fluttertoast.showToast(
                                                   //        //   msg: 'URL copied to clipboard',
                                                   //        //   toastLength: Toast.LENGTH_SHORT,
                                                   //        //   gravity: ToastGravity.BOTTOM,
                                                   //        //   timeInSecForIosWeb: 1,
                                                   //        //   backgroundColor: Colors.grey,
                                                   //        //   textColor: Colors.white,
                                                   //        //   fontSize: 16.0,
                                                   //        // );
                                                   //        print("Akshay selectable");
                                                   //      },
                                                   //
                                                   //      linkifiers:  [
                                                   //
                                                   //        EmailLinkifier(),
                                                   //        UrlLinkifier(),
                                                   //
                                                   //      ],
                                                   //      selectionControls: isSelecting ? MaterialTextSelectionControls() : null ,
                                                   //      onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
                                                   //        if (selection.baseOffset != selection.extentOffset) {
                                                   //          // Text is selected
                                                   //          if(widget.selectionChange!=null){
                                                   //            widget.selectionChange!(widget.index);
                                                   //          }
                                                   //        } else {
                                                   //          // Text is not selected
                                                   //          setState(() {
                                                   //            print("testing case in false");
                                                   //          });
                                                   //        }
                                                   //      },
                                                   //      linkStyle: TextStyle(decorationColor: Colors.blue,color: Colors.blue,),
                                                   //      onOpen: (link) async {
                                                   //        final modifiedLink = link.url.replaceAll(
                                                   //            "https://teams.sidrateams.com", // Replace this with your origin
                                                   //            flutterWebOrigin);
                                                   //        if (!await launchUrl(Uri.parse(modifiedLink))) {
                                                   //          throw Exception('Could not launch ${link.url}');
                                                   //        }
                                                   //      },
                                                   //      text: widget.messageList
                                                   //          .message ??
                                                   //          "",
                                                   //
                                                   //      textAlign: TextAlign.left,
                                                   //      style:  TextStyle(
                                                   //          fontSize: PlatformUtils.isMobile?w/29:w/27,
                                                   //          color: Colors.black),),
                                                   //  ),
                                                    // Text(
                                                    // widget.messageList!
                                                    //         .message ??
                                                    //     "",
                                                    //     softWrap: true,
                                                    //     textAlign: TextAlign.left,
                                                    // style: const TextStyle(
                                                    //     fontSize: 16,
                                                    //     color: Colors.black),
                                                    // ),
                                                    SizedBox(height: 5,),

                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                  right: 0,
                                                  top:-1,
                                                  child:Container(
                                                    width: 30,
                                                    height:30,
                                                    margin: EdgeInsets.only(right:0),
                                                    child: AdminTableDotIcon(
                                                      height: 25,
                                                      clr: Colors.transparent,
                                                      iconClr: Colors.black,
                                                      icons: Icons.expand_more,
                                                      iconSize:20,

                                                      mouseHoverFunc: (val){

                                                      },
                                                      valueList: item,
                                                      onTap: (val){
                                                        if(val=="1"){
                                                          widget.replayFun(1); // widget.r
                                                        }
                                                        // if(widget.onEvets!=null){widget.onEvets!(val);}



                                                      },),
                                                  )
                                              ),
                                              Positioned(
                                                right: 6,
                                                bottom: 5,
                                                child: Text(
                                                  widget.formattedTime??"",
                                                  //   messageList[index]
                                                  //     .createdAt ??
                                                  // "",
                                                  style: const TextStyle(
                                                    fontSize: 8,
                                                    color: Color(0xFF6D6D6D),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.start,
                                    //   children: [
                                    //     Text(
                                    //       messageList[index]
                                    //               .createdAt ??
                                    //           "",
                                    //       style: const TextStyle(
                                    //           fontSize: 13,
                                    //           color: Color(
                                    //               0xFF6D6D6D)),
                                    //     ),
                                    //   ],
                                    // ),
                                  ])
                            }
                        ],
                      ),
                    ],
                  )


                }
              }
            }

            else ...{
              if(widget.messageList!.type=="notify")...{
                Padding(
                  padding:  EdgeInsets.only(top:10,left: 25,right: 25,bottom:10),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.only(top:5,bottom:5,right: 10,left: 10),
                      constraints: const BoxConstraints(
                        maxWidth: 250,
                      ),

                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color.fromARGB(236, 233, 232, 232)
                      ),
                      child: Center(
                        child: Text(
                          "${widget.messageList!
                              .message.toString()}"

                          ,
                          textAlign: TextAlign.center,
                          softWrap: true,
                          maxLines: 5,
                          style: const TextStyle(
                            color: Color(0xff151522),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              }
              else if (widget.messageList!.type == "image") ...{
                CustomImage(
                  loginid: widget.loginUserId??"",
                  replydata:widget.messageList.reply ,
                  me: true,
                  activelength: widget.activeUsersLength,
                  grpid: widget.grpchatid,

                  seenBy: widget.messageList.seenBy,
                  onEvets: (val){

                    if(val=="1"){
                      _downloadImage(widget.messageList.message??"");
                    }
                    if(val=="2"){
                      widget.replayFun(1);
                    }
                    if(val=="3"){
                      widget.replayFun(3);
                    }

                  },

                  onTap: () {



                  },

                  keyValue:       "image ${widget.roomid}${widget.messageList.message}",
                  message:  widget.messageList
                      .message ??
                      "",
                  time: widget.formattedTime??"",






                )

                // InkWell(
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (_) {
                //             return DetailScreen(
                //               image:
                //               widget.messageList!.message ??
                //                   "",
                //             );
                //           }));
                //     },
                //     child: Container(
                //         width: w / 1.5,
                //         padding: const EdgeInsets.all(4),
                //         decoration: const BoxDecoration(
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(10),
                //             topRight: Radius.circular(10),
                //             bottomLeft: Radius.circular(10),
                //             bottomRight: Radius.circular(0),
                //           ),
                //           color: ColorPalette.primary,
                //         ),
                //         alignment: Alignment.topRight,
                //         child: Column(
                //           children: [
                //             Container(
                //               key: new PageStorageKey(
                //                 "image ${widget.roomid}${widget.messageList!.message}",
                //               ),
                //               constraints: BoxConstraints(
                //                 maxHeight:
                //                 MediaQuery.of(context)
                //                     .size
                //                     .height /
                //                     2.5,
                //               ),
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.only(
                //                     topLeft:
                //                     Radius.circular(
                //                         6),
                //                     topRight:
                //                     Radius.circular(
                //                         6),
                //                     bottomLeft:
                //                     Radius.circular(
                //                         6),
                //                     bottomRight:
                //                     Radius.circular(
                //                         0)),
                //               ),
                //               width: w,
                //               child: Image(
                //                   loadingBuilder:
                //                       (context,
                //                       child,
                //                       loadingProgress) {
                //                     if (loadingProgress ==
                //                         null)
                //                       return child;
                //                     return const SizedBox(
                //                       child: Center(
                //                           child: CircularProgressIndicator(
                //                             color: Color.fromRGBO(255, 255, 255, 1),
                //                           )),
                //                     );
                //                   },
                //                   fit: BoxFit.cover,
                //                   image: ResizeImage(policy:ResizeImagePolicy.fit,
                //                       NetworkImage(
                //                           widget.messageList!
                //                               .message ??
                //                               ""),width:500,height:500,allowUpscaling: true)),
                //             ),
                //             const SizedBox(
                //               height: 3,
                //             ),
                //             Row(
                //               mainAxisAlignment:
                //               MainAxisAlignment.end,
                //               children: [
                //                 Text(
                //                   widget.formattedTime??"",
                //                   style: const TextStyle(
                //                     fontSize: 8,
                //                     color: Color.fromARGB(255, 211, 209, 209),
                //                   ),
                //                 ),
                //                 SizedBox(width: 5,),
                //                 if(widget.grpchatid=="")...{
                //                   if(widget.activeUsersLength! >=2)...{
                //                     Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                //                   }
                //                   else if(widget.activeUsersLength! == 1 && widget.messageList!.seenBy == null )...{
                //                     SizedBox()
                //                   }
                //                   else...{
                //                       widget.messageList!.seenBy!.isEmpty?
                //                       SizedBox():
                //                       Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                //
                //                     }
                //                 } else...{
                //                   SizedBox()
                //                 }
                //               ],
                //             ),
                //           ],
                //         )))
                // InkWell(
                //     onTap: () {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (_) {
                //             return DetailScreen(
                //               image:
                //               widget.messageList!.message ??
                //                   "",
                //             );
                //           }));
                //     },
                //     child: Container(
                //         width: w / 1.5,
                //         padding: const EdgeInsets.all(4),
                //         decoration: const BoxDecoration(
                //           borderRadius: BorderRadius.only(
                //             topLeft: Radius.circular(10),
                //             topRight: Radius.circular(10),
                //             bottomLeft: Radius.circular(10),
                //             bottomRight: Radius.circular(0),
                //           ),
                //           color: ColorPalette.primary,
                //         ),
                //         alignment: Alignment.topRight,
                //         child: Column(
                //           children: [
                //             Container(
                //               key: new PageStorageKey(
                //                 "image ${widget.roomid}${widget.messageList!.message}",
                //               ),
                //               constraints: BoxConstraints(
                //                 maxHeight:
                //                 MediaQuery.of(context)
                //                     .size
                //                     .height /
                //                     2.5,
                //               ),
                //               decoration: BoxDecoration(
                //                 borderRadius: BorderRadius.only(
                //                     topLeft:
                //                     Radius.circular(
                //                         6),
                //                     topRight:
                //                     Radius.circular(
                //                         6),
                //                     bottomLeft:
                //                     Radius.circular(
                //                         6),
                //                     bottomRight:
                //                     Radius.circular(
                //                         0)),
                //               ),
                //               width: w,
                //               child: Image(
                //                   loadingBuilder:
                //                       (context,
                //                       child,
                //                       loadingProgress) {
                //                     if (loadingProgress ==
                //                         null)
                //                       return child;
                //                     return const SizedBox(
                //                       child: Center(
                //                           child: CircularProgressIndicator(
                //                             color: Color.fromRGBO(255, 255, 255, 1),
                //                           )),
                //                     );
                //                   },
                //                   fit: BoxFit.cover,
                //                   image: ResizeImage(policy:ResizeImagePolicy.fit,
                //                       NetworkImage(
                //                           widget.messageList!
                //                               .message ??
                //                               ""),width:500,height:500,allowUpscaling: true)),
                //             ),
                //             const SizedBox(
                //               height: 3,
                //             ),
                //             Row(
                //               mainAxisAlignment:
                //               MainAxisAlignment.end,
                //               children: [
                //                 Text(
                //                   widget.formattedTime??"",
                //                   style: const TextStyle(
                //                     fontSize: 8,
                //                     color: Color.fromARGB(255, 211, 209, 209),
                //                   ),
                //                 ),
                //                 SizedBox(width: 5,),
                //                 if(widget.grpchatid=="")...{
                //                   if(widget.activeUsersLength! >=2)...{
                //                     Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                //                   }
                //                   else if(widget.activeUsersLength! == 1 && widget.messageList!.seenBy == null )...{
                //                     SizedBox()
                //                   }
                //                   else...{
                //                       widget.messageList!.seenBy!.isEmpty?
                //                       SizedBox():
                //                       Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                //
                //                     }
                //                 } else...{
                //                   SizedBox()
                //                 }
                //               ],
                //             ),
                //           ],
                //         )))
              } else if (widget.messageList!.type ==
                  "audio") ...{
                Stack(
                    children:[
                      Container(

                        key: new PageStorageKey(
                          "image ${widget.roomid}${widget.messageList!.message}",),
                        // child: VoiceMessageView(controller: VoiceController(
                        //   audioSrc:  widget.messageList.message ?? "",
                        //   maxDuration: const Duration(hours:5),
                        //   isFile: false,
                        //   onComplete: () {},
                        //   onPause: () {},
                        //   onPlaying: () {},
                        // ),
                        //   me: true, audioSrc:  widget.messageList.message ?? "",
                        // )
                      ),
                      Positioned(
                        right: 5,
                        bottom: 5,
                        child: Row(
                          children: [
                            Text(
                              widget.formattedTime??"",
                              style: const TextStyle(
                                fontSize: 8,
                                color: Color.fromARGB(255, 211, 209, 209),
                              ),
                            ),
                            SizedBox(width: 5,),
                            if(widget.grpchatid=="")...{
                              if(widget.activeUsersLength! >=2)...{
                                Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                              }
                              else if(widget.activeUsersLength! == 1&& widget.messageList!.seenBy == null )...{
                                SizedBox()
                              }
                              else...{
                                  widget.messageList!.seenBy!.isEmpty?
                                  SizedBox():
                                  Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)

                                }
                            } else...{
                              SizedBox()
                            }


                          ],
                        ),
                      ),
                    ]
                )

              } else if (widget.messageList!.type ==
                  "file") ...{
                Column(
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () async {
                                final url =
                                widget.messageList!.message.toString();
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: SvgPicture.string(
                                CommunicationSvg().dwnldIcon,)),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(0),
                                ),
                                color: ColorPalette.primary),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 8,),
                                    SizedBox(
                                      width: 34,
                                      height: 36,
                                      child: SvgPicture.string(
                                        CommunicationSvg().docIcon2,color: Colors.white,),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      width: w / 1.8,
                                      height: 52,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(10),
                                        boxShadow: [
                                          const BoxShadow(
                                            color: Color(0x05000000),
                                            blurRadius: 8,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                        color: ColorPalette.primary,
                                      ),
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 15,),
                                          Text(
                                            // messageList[index]
                                            //         .message ??
                                              "${ widget.messageList!.message!.split('?').first.split('/').last}",
                                              overflow:TextOverflow.ellipsis ,
                                              // textScaler:TextScaler.linear(textScaleFactor) ,
                                              style:GoogleFonts.roboto (textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize:13,
                                              ),)
                                          ),
                                          Text(
                                            "${ widget.messageList!.message!.split('?').first.split('.').last.toString().toUpperCase()}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize:8,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 5,
                                  bottom: 5,
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.formattedTime??"",
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Color.fromARGB(255, 211, 209, 209),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      if(widget.grpchatid=="")...{
                                        if(widget.activeUsersLength! >= 2)...{
                                          Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                                        }
                                        else if(widget.activeUsersLength! ==1 && widget.messageList!.seenBy == null )...{
                                          SizedBox()
                                        }
                                        else...{
                                            widget.messageList!.seenBy!.isEmpty?
                                            SizedBox():
                                            Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)

                                          }
                                      } else...{
                                        SizedBox()
                                      }


                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                    ]),
              } else if (widget.messageList!.type ==
                  "video") ...{
                Container(
                  constraints:  BoxConstraints(
                    maxWidth: 277,
                    maxHeight:
                    MediaQuery.of(context)
                        .size
                        .height /
                        2.5,
                  ),
                  decoration: BoxDecoration(

                    // RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft:
                      Radius.circular(10),
                      bottomRight:
                      Radius.circular(0),

                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    // ),
                    color: ColorPalette.primary,
                  ),
                  key: new PageStorageKey(
                    "vedio ${widget.roomid}${widget.messageList!.message}",
                  ),
                  child: Stack(
                      children:[
                        VideoPlayerScreen(
                          me:true,
                          autoplay: false,
                          looping: true,
                          alignmentGeometry: Alignment.topRight,
                          videoUrl: widget.messageList!.message ??
                              "",
                          // videoPlayerController:
                          //     VideoPlayerController.network(
                          //   messageList[index].message ?? "",
                          // ),
                        ),
                        Positioned(
                          right: 5,
                          bottom: 0,
                          child: Row(
                            children: [
                              Text(
                                widget.formattedTime??"",
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Color.fromARGB(255, 211, 209, 209),
                                ),
                              ),
                              SizedBox(width: 5,),
                              if(widget.grpchatid=="")...{
                                if(widget.activeUsersLength! >= 2)...{
                                  Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                                }
                                else if(widget.activeUsersLength! ==1 && widget.messageList!.seenBy == null )...{
                                  SizedBox()
                                }
                                else...{
                                    widget.messageList!.seenBy!.isEmpty?
                                    SizedBox():
                                    Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)

                                  }
                              } else...{
                                SizedBox()
                              }


                            ],
                          ),
                        ),
                      ]
                  ),
                ),


              } else if(widget.messageList!.type ==
                  "mention")...{
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      minWidth:
                      25,
                      maxWidth:
                      MediaQuery.of(context)
                          .size
                          .width/1.5,
                    ),
                    child: GestureDetector(
                      onLongPress: ()=> widget.ontap( widget.messageList
                          .message??""),

                      child: Container(
                        decoration: BoxDecoration(
                          // RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft:
                            Radius.circular(10),
                            bottomRight:
                            Radius.circular(0),
                          ),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              offset: Offset(0, 1), // changes position of shadow
                            ),
                          ],
                          // ),
                          color: ColorPalette.primary,
                        ),

                        // margin:
                        //     const EdgeInsets.symmetric(
                        //         horizontal: 10,
                        //         vertical: 5),
                        child:  Stack(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.only(
                                left: 10,
                                right:20,
                                top:7,
                                bottom:16,
                              ),
                              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  widget.messageList.reply!=null ?
                                  Container(
                                    width: w,
                                    padding: EdgeInsets.only(top:5,right:5,bottom:5,left:7),
                                    decoration: BoxDecoration(
                                      // border: Border.all(color: ColorPalette.primary),
                                        borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                                        color: Color.fromARGB(209, 199, 219, 235)

                                    ),
                                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.messageList.reply!.userid==widget.loginUserId?"you":"${widget.messageList.reply!.name.toString().toTitleCase()}",
                                            style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                                        Container(
                                            child:
                                            Stack(
                                              children: [
                                                Positioned(
                                                    left:-1,
                                                    top: 2,
                                                    child: widget.messageList.reply!.type=="image"?Icon(Icons.image,size: 16,):widget.messageList.reply!.type=="video"?Icon(Icons.video_library,size: 16,):widget.messageList.reply!.type=="audio"?Icon(Icons.mic,size:16):widget.messageList.reply!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                                widget.messageList.reply!.type=="text"||widget.messageList.reply!.type=="mention"?
                                                Text("${widget.messageList.reply!.message}",
                                                  softWrap: true,
                                                  textScaler: TextScaler.linear(1),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,)
                                                    :Padding(
                                                  padding: const EdgeInsets.only(left:15),
                                                  child: Text("${widget.messageList.reply!.message}",
                                                    softWrap: true,
                                                    textScaler: TextScaler.linear(1),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,),
                                                ),
                                              ],
                                            )
                                        )
                                      ],
                                    ),
                                  ):SizedBox(),
                                  MentionText(
                                    text: widget.messageList.message ??"",
                                    grpmember: widget.grpmember,
                                    mentionStyle: TextStyle(color: Color(0xFFF1D302),fontSize: PlatformUtils.isMobile? w/29:w/27),
                                    color: true,),
                                  // Text(
                                  // widget.messageList!
                                  //         .message ??
                                  //     "",
                                  //     textAlign: TextAlign.left,
                                  // style: const TextStyle(
                                  //     fontSize: 16,
                                  //     color: Color.fromARGB(255, 94, 206, 90)),
                                  // ),

                                  SizedBox(height: 5,)
                                ],
                              ),
                            ),
                            Positioned(
                              right: 5,
                              bottom: 5,
                              child: Row(
                                children: [
                                  Text(
                                    widget.formattedTime??"",
                                    style: const TextStyle(
                                      fontSize: 8,
                                      color: Color.fromARGB(255, 211, 209, 209),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  if(widget.grpchatid=="")...{
                                    if(widget.activeUsersLength!>= 2)...{
                                      Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                                    }
                                    else if(widget.activeUsersLength! ==1 && widget.messageList.seenBy == null )...{
                                      SizedBox()
                                    }
                                    else...{
                                        widget.messageList.seenBy!.isEmpty?
                                        SizedBox():
                                        Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)

                                      }
                                  } else...{
                                    SizedBox()
                                  }


                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              }
              else ...{
                  Align(
                    alignment: Alignment.centerRight,
                    child:
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      // padding: EdgeInsets.all(3),
                      constraints: BoxConstraints(
                        minWidth:
                        70,
                        maxWidth:
                        MediaQuery.of(context)
                            .size
                            .width/3,
                      ),
                      child: GestureDetector(
                        onLongPress: (){
        widget.ontap( widget.messageList
            .message??"");

        },
                        child: Container(
                          decoration: BoxDecoration(
                            // RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                              bottomLeft:
                              Radius.circular(10),
                              bottomRight:
                              Radius.circular(0),
                            ),

                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                offset: Offset(0, 1), // changes position of shadow
                              ),
                            ],
                            // ),
                            color: ColorPalette.primary,
                          ),

                          // margin:
                          //     const EdgeInsets.symmetric(
                          //         horizontal: 10,
                          //         vertical: 5),
                          child:  Stack(
                            // mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(
                                  left: 10,
                                  right:10,
                                  top:20,
                                  bottom:16,
                                ),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    widget.messageList.reply!=null ?
                                    Container(
                                      width: w,
                                      padding: EdgeInsets.only(top:5,right:5,bottom:5,left:7),
                                      decoration: BoxDecoration(
                                        // border: Border.all(color: ColorPalette.primary),
                                          borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                                          color: Color.fromARGB(209, 199, 219, 235)

                                      ),
                                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(widget.messageList.reply!.userid==widget.loginUserId?"you":"${widget.messageList.reply!.name.toString().toTitleCase()}",
                                              style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                                          Container(
                                              child:
                                              Stack(
                                                children: [
                                                  Positioned(
                                                      left:-1,
                                                      top: 2,
                                                      child: widget.messageList.reply!.type=="image"?Icon(Icons.image,size: 16,):widget.messageList.reply!.type=="video"?Icon(Icons.video_library,size: 16,):widget.messageList.reply!.type=="audio"?Icon(Icons.mic,size:16):widget.messageList.reply!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                                  widget.messageList.reply!.type=="text"||widget.messageList.reply!.type=="mention"?
                                                  Text("${widget.messageList.reply!.message}",
                                                    softWrap: true,
                                                    textScaler: TextScaler.linear(1),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,)
                                                      :Padding(
                                                    padding: const EdgeInsets.only(left:15),
                                                    child: Text("${widget.messageList.reply!.message}",
                                                      softWrap: true,
                                                      textScaler: TextScaler.linear(1),
                                                      maxLines: 1,
                                                      overflow: TextOverflow.ellipsis,),
                                                  ),
                                                ],
                                              )
                                          )
                                        ],
                                      ),
                                    ):SizedBox(),
                                    CustomSelectableLinkify(text: widget.messageList.message??"",   linkStyle: TextStyle(
                                        color: Colors.blue,
                                        decorationColor: Colors.blue

                                      // decoration: TextDecoration.underline,
                                    ),


                                      selectionChange:(index,{bool? val=false}){
                                        if(widget.selectionChange!=null)
                                          widget.selectionChange!(index,val:val??false);
                                      } ,textColor: Colors.white,

                                      linkifiers: [
                                        EmailLinkifier(),
                                        UrlLinkifier()
                                      ], onOpen: _openLink, index: widget.index, selectionChange1:(){
                                        if(widget.selectionChange!=null){
                                          widget.selectionChange!;
                                        }
                                      }, isSelected: widget.messageList.isSelectable==true?true:false, messageList: widget.messageList,),

        // selectionAreaColorChange(context,
        // isSected:widget.messageList.isSelectable==true? true:false,
        //
        // child: GestureDetector(
        //                                 onPanStart: (details) {
        //                                   setState(() {
        //                                     isSelecting = true;
        //                                   });
        //                                   _updateSelection(details.localPosition,widget.messageList.message??"");
        //                                 },
        //                                 onPanUpdate: (details) {
        //                                   _updateSelection(details.localPosition,widget.messageList.message??"");
        //
        //                                 },
        //
        //                                   child: SelectableLinkify(
        //                                     onOpen: (link) => _openLink(link),
        //                                     text: widget.messageList.message??"",
        //                                     linkStyle: TextStyle(color: Color.fromARGB(255, 219, 246, 244),decorationColor: Color.fromARGB(255, 219, 246, 244)),
        //                                     linkifiers: [
        //                                       EmailLinkifier(),
        //                                       UrlLinkifier()
        //                                     ],
        //                                     onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
        //                                       if (selection.baseOffset != selection.extentOffset) {
        //                                         print("selection startttt");
        //                                         if(widget.selectionChange!=null){
        //                                           widget.selectionChange!(widget.index);
        //                                         }
        //                                         // Text is selected
        //
        //                                       } else {
        //                                         // Text is not selected
        //                                         setState(() {
        //                                           print("testing case in false");
        //                                         });
        //                                       }
        //                                     },
        //                                     style:  TextStyle(
        //                                         fontSize: PlatformUtils.isMobile?w/29:w/27,
        //                                         color:Colors.white),
        //                                     selectionControls: isSelecting ? CustomTextSelectionControls() : null,
        //
        //                                   ),
        //
        //                               ),
        //                             ),







        //                             GestureDetector(
        //
        //                               onPanStart: (details) {
        //                                 setState(() {
        //                                   isSelecting = true;
        //                                 });
        //                                 _updateSelection(details.localPosition,widget.messageList.message??"");
        //                               },
        //                               onPanUpdate: (details) {
        //                                 _updateSelection(details.localPosition,widget.messageList.message??"");
        //
        //                               },
        //                               child:
        //                               Theme(data: Theme.of(context).copyWith(
        //                                   textSelectionTheme: TextSelectionThemeData(
        //                                       selectionHandleColor: Colors.orange,
        //                                       selectionColor:
        //                                       // Colors.white.withOpacity(.2)
        //                                     widget.messageList.isSelectable==true? Colors.grey.withOpacity(.2):Colors.transparent
        //                                   )),
        //                                 child: SelectableLinkify(
        //                                   onOpen: (link) => _openLink(link),
        //                                   text: widget.messageList.message??"",
        //                                   linkStyle: TextStyle(color: Color.fromARGB(255, 219, 246, 244),decorationColor: Color.fromARGB(255, 219, 246, 244)),
        //                                   linkifiers: [
        //                                     EmailLinkifier(),
        //                                     UrlLinkifier()
        //                                   ],
        //                                   onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
        //                                     if (selection.baseOffset != selection.extentOffset) {
        //                                       print("selection startttt");
        //                                       if(widget.selectionChange!=null){
        //                                         widget.selectionChange!(widget.index);
        //                                       }
        //                                       // Text is selected
        //
        //                                     } else {
        //                                       // Text is not selected
        //                                       setState(() {
        //                                         print("testing case in false");
        //                                       });
        //                                     }
        //                                   },
        // style:  TextStyle(
        //         fontSize: PlatformUtils.isMobile?w/29:w/27,
        //         color:Colors.white),
        //                                   selectionControls: isSelecting ? MaterialTextSelectionControls() : null,
        //
        //                                 ),
        //                               ),
        //                             ),


                                      // Theme(data: Theme.of(context).copyWith(
                                      //     textSelectionTheme: TextSelectionThemeData(
                                      //         selectionHandleColor: Colors.orange,
                                      //         selectionColor:widget.messageList.isSelectable==true? Colors.white.withOpacity(.2):Colors.transparent)),
                                      //   child: SelectableLinkify(
                                      //   onTap: (){
                                      //     Clipboard.setData(ClipboardData(text: widget.messageList.message ?? ""));
                                      //     // Fluttertoast.showToast(
                                      //     //   msg: 'URL copied to clipboard',
                                      //     //   toastLength: Toast.LENGTH_SHORT,
                                      //     //   gravity: ToastGravity.BOTTOM,
                                      //     //   timeInSecForIosWeb: 1,
                                      //     //   backgroundColor: Colors.grey,
                                      //     //   textColor: Colors.white,
                                      //     //   fontSize: 16.0,
                                      //     // );
                                      //     print("Akshay selectable");
                                      //   },
                                      //     options: LinkifyOptions(
                                      //         humanize: false
                                      //     ),
                                      //     linkifiers:  [
                                      //
                                      //       EmailLinkifier(),
                                      //       UrlLinkifier(),
                                      //
                                      //     ],
                                      //     onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
                                      //       if (selection.baseOffset != selection.extentOffset) {
                                      //         // Text is selected
                                      //         if(widget.selectionChange!=null){
                                      //           widget.selectionChange!(widget.index);
                                      //         }
                                      //       } else {
                                      //         // Text is not selected
                                      //         setState(() {
                                      //           print("testing case in false");
                                      //         });
                                      //       }
                                      //     },
                                      //     linkStyle: TextStyle(color: Color.fromARGB(255, 219, 246, 244),decorationColor: Color.fromARGB(255, 219, 246, 244)),
                                      //     onOpen: (link) async {
                                      //       if (!await launchUrl(Uri.parse(link.url))) {
                                      //         throw Exception('Could not launch ${link.url}');
                                      //       }
                                      //     },
                                      //     text: widget.messageList.message ??"",
                                      //
                                      //     textAlign: TextAlign.left,
                                      //     style:  TextStyle(
                                      //         fontSize: PlatformUtils.isMobile?w/29:w/27,
                                      //         color:Colors.white),),
                                      // ),
                                    // Text(
                                    // widget.messageList!
                                    //         .message ??
                                    //     "",
                                    //     textAlign: TextAlign.left,
                                    // style: const TextStyle(
                                    //     fontSize: 16,
                                    //     color: Color.fromARGB(255, 255, 255, 255)),
                                    // ),

                                    SizedBox(height: 5,)
                                  ],
                                ),
                              ),
                              Positioned(
                                  right: 0,
                                  top:-1,
                                  child:Container(
                                    width: 30,
                                    height:30,
                                    margin: EdgeInsets.only(right:0),
                                    child: AdminTableDotIcon(
                                      height: 25,
                                      clr: Colors.transparent,
                                      iconClr: Colors.white,
                                      icons: Icons.expand_more,
                                      iconSize:20,

                                      mouseHoverFunc: (val){

                                      },
                                      valueList: item,
                                      onTap: (val){
                                        if(val=="1"){
                                          widget.replayFun(1); // widget.r
                                        }
                                        // if(widget.onEvets!=null){widget.onEvets!(val);}



                                      },),
                                  )
                              ),
                              Positioned(
                                right: 5,
                                bottom: 5,
                                child: Row(
                                  children: [
                                    Text(
                                      widget.formattedTime??"",
                                      style: const TextStyle(
                                        fontSize: 8,
                                        color: Color.fromARGB(255, 211, 209, 209),
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    if(widget.grpchatid=="")...{
                                      if(widget.activeUsersLength!>= 2)...{
                                        Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                                      }
                                      else if(widget.activeUsersLength! ==1 && widget.messageList.seenBy == null )...{
                                        SizedBox()
                                      }
                                      else...{
                                          widget.messageList.seenBy!.isEmpty?
                                          SizedBox():
                                          Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)

                                        }
                                    } else...{
                                      SizedBox()
                                    }


                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                }

            },
            // totpage>1 &&  messageList[index].lastMessageOfDay == true?
            // Padding(
            //      padding: const EdgeInsets.only(top:5,left: 25,right: 25,bottom: 10),
            //      child: Center(
            //        child: Container(
            //          padding: EdgeInsets.only(top:5,bottom:5,right: 10,left: 10),

            //          decoration: BoxDecoration(
            //            borderRadius: BorderRadius.circular(20),
            //            color: Color.fromARGB(236, 233, 232, 232)
            //          ),
            //          child: Column(
            //            children:[

            //             Text(
            //                     "$msgdate",
            //                          textAlign: TextAlign.center,
            //                          softWrap: true,
            //                          maxLines: 3,
            //                      style: const TextStyle(
            //                        color: Color(0xff151522),
            //                        fontSize: 12,
            //                      ),
            //                    )
            //                    ,]
            //          ),
            //        ),
            //      ),
            //    ):Container(),
          ],
        );
     
  }
  Widget buildMessage(String message) {
    List<String> words = message.split(' '); // Split message by spaces

    List<Widget> wordWidgets = [];
    for (String word in words) {
      // Check if the word meets your condition (e.g., starts with '@')
      Color color = word.startsWith('@') ? Colors.red : Colors.black;

      // Create a Text widget for the word with the specified color
      Widget wordWidget = Text(
        '$word ',
        style: TextStyle(color: color),
      );

      wordWidgets.add(wordWidget);
    }

    // Use the Wrap widget to display the words in a line
    return Wrap(
      children: wordWidgets,
    );
  }

  Widget imageDialog(text, path,context) {
    return Dialog(
      // backgroundColor: Colors.transparent,
      // elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 40,
                  child: Center(
                    child: Text(
                      '${text.toString().toTitleCase()}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0,right: 8.0,left: 8.0,bottom:25),
            child: Container(
              width: MediaQuery.of(context).size.width/5,
              height: MediaQuery.of(context).size.height/3,
              child:
              path==""?TextAvatar(
                shape: Shape.Circular,
                size: 20,
                numberLetters: 2,
                fontSize: MediaQuery.of(context).size.width/5,
                textColor: Colors.white,
                fontWeight: FontWeight.w500,
                text:"${text.toString().toUpperCase()}" ,
              )
                  :Image.network(
                '$path',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _openLink(LinkableElement link) async {
    if (!await launchUrl(Uri.parse(link.url))) {
      throw Exception('Could not launch ${link.url}');
    }
  }
  Color getRandomColor() {
    // Generate random RGB values between 0 and 255
    final random = Random();
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);

    // Create and return a Color object with the random RGB values
    return Colors.blue;
  }

}


class MentionText extends StatelessWidget {
  final String text;
  final List<GroupUserList> grpmember;
  final TextStyle mentionStyle;
  final bool  color;


  MentionText({required this.text,required this.grpmember,required this.mentionStyle,this.color=false});

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];

    RegExp regExp = RegExp(r"(@\w+)");
    Iterable<RegExpMatch> matches = regExp.allMatches(text);

    int start = 0;
    for (RegExpMatch match in matches) {
      String mention = match.group(0)!;
      String prefix = text.substring(start, match.start);
      textSpans.add(TextSpan(text: prefix));
      String mentionWithoutAt = mention.substring(1).trim();
      bool mentionFound = false;
      for (int i = 0; i < grpmember.length; i++) {
        List<String> names = grpmember[i].name!.split(" ");
        if (names.length > 2) {
          names = [names.first, names[1]];
        }
        String formattedFullName = names.map((name) => name.trim()).join('');
        String fullName1 = "$formattedFullName";
        String fullName = "$fullName1";
        print("mention $fullName");
        if (fullName == mentionWithoutAt) {
          textSpans.add(TextSpan(
            text: mention,
            style: mentionStyle,
          ));
          mentionFound = true;
          break;
        }
      }
      if (!mentionFound) {
        textSpans.add(TextSpan(text: mention));
      }

      start = match.end;
    }

    if (start < text.length) {
      textSpans.add(TextSpan(text: text.substring(start)));
    }

    return RichText(
      text: TextSpan(children: textSpans ,style: TextStyle(color:color==true?Colors.white:Colors.black,)),
    );
  }
}


// class CustomSelectableLinkify extends StatefulWidget {
//   final String text;
//   final TextStyle? style;
//   final Color selectedTextColor;
//
//   const CustomSelectableLinkify({
//     Key? key,
//     required this.text,
//     this.style,
//     this.selectedTextColor = Colors.blue, // Default selected text color
//   }) : super(key: key);
//
//   @override
//   _CustomSelectableLinkifyState createState() => _CustomSelectableLinkifyState();
// }
//
// class _CustomSelectableLinkifyState extends State<CustomSelectableLinkify> {
//   late final FocusNode _focusNode;
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode();
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SelectableLinkify(
//       text: widget.text,
//       style: widget.style,
//       focusNode: _focusNode,
//       onTap: () {
//         // When text is tapped, ensure that the widget gets the focus
//         _focusNode.requestFocus();
//       },
//       onOpen: (_) {
//         // When link is tapped, ensure that the widget gets the focus
//         _focusNode.requestFocus();
//       },
//       linkStyle: TextStyle(color: Colors.blue), // Default link color
//       onTextHighlightChanged: (isHighlighted) {
//         setState(() {});
//       },
//       textSelectionControls: CustomTextSelectionControls(
//         selectionColor: widget.selectedTextColor,
//       ),
//     );
//   }
// }
class CustomImage extends StatefulWidget {
  final Function onTap;
  final ReplyTypeModel? replydata;
  final Function(String)? onEvets;
  final String keyValue;
  final String message;
  final String loginid;
  final String grpid;
  final String time;
  final bool me;
  final int? activelength;
  final List<String>? seenBy;
   CustomImage({super.key,required this.onTap, required this.keyValue, required this.message, required this.time, this.onEvets, this.replydata,required this.loginid,this.me=false,this.grpid="",this.activelength=0,this.seenBy});

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  bool isHover=false;
  List<customPopupmenuButton>item=[
    customPopupmenuButton(label: "Download",value: "1"),
    customPopupmenuButton(label: "Reply",value: "2"),
    customPopupmenuButton(label: "Copy",value: "3"),
    // customPopupmenuButton(label: "Channel",value: "2"),

  ];

  @override
  Widget build(BuildContext context) {
    double w1 = MediaQuery.of(context).size.width ;
    double w = w1 > 700
        ? 400
        : w1;
    var h = MediaQuery.of(context).size.height;
    return  MouseRegion(

          onEnter: (event) {
            isHover = true;
            setState(() {

            });

          },
          onExit: (event) {
            isHover = false;
            setState(() {

            });

          },
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // SizedBox(height:widget.isselcted==true? 5:0,),
          InkWell(
            onTap:(){

      Navigator.push(context,
      MaterialPageRoute(
      builder: (_) {
      return DetailScreen(
      image:
      widget.message ??
      "",
      );
      }));
      },
            // onLongPress: widget.ontap,
            child: Container(
                width: w / 1.5,

                padding: const EdgeInsets.all(4),
                decoration:  BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft:widget.me==false? Radius.circular(0):Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight:widget.me==false?  Radius.circular(10):Radius.circular(0),
                  ),
                  color:widget.me==false? Colors.white:ColorPalette.primary,
                ),
                alignment: Alignment.topRight,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        widget.replydata !=null ?
                        Padding(
                          padding: const EdgeInsets.only(top:8),
                          child: Container(
                            width: w,
                            padding: EdgeInsets.only(top:5,right:5,bottom:5,left:7),
                            decoration: BoxDecoration(
                              // border: Border.all(color: ColorPalette.primary),
                                borderRadius: BorderRadius.only(topRight:Radius.circular(7),topLeft: Radius.circular(7)),
                                color: Color.fromARGB(209, 199, 219, 235)

                            ),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.replydata?.userid==widget.loginid?"you":"${widget.replydata?.name.toString().toTitleCase()}",
                                    style:TextStyle(fontSize:10,fontWeight: FontWeight.bold,color: ColorPalette.primary)),
                                Container(
                                    child:
                                    Stack(
                                      children: [
                                        Positioned(
                                            left:-1,
                                            top: 2,
                                            child: widget.replydata?.type=="image"?Icon(Icons.image,size: 16,):widget.replydata!.type=="video"?Icon(Icons.video_library,size: 16,):widget.replydata!.type=="audio"?Icon(Icons.mic,size:16):widget.replydata!.type=="file"?Icon(Icons.file_copy,size:16):SizedBox()),
                                        widget.replydata!.type=="text"||widget.replydata!.type=="mention"?
                                        Text("${widget.replydata!.message}",
                                          softWrap: true,
                                          textScaler: TextScaler.linear(1),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,)
                                            :Padding(
                                          padding: const EdgeInsets.only(left:15),
                                          child: Text("${widget.replydata!.message}",
                                            softWrap: true,
                                            textScaler: TextScaler.linear(1),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,),
                                        ),
                                      ],
                                    )
                                )
                              ],
                            ),
                          ),
                        ):SizedBox(),
                        Container(
                            key: new PageStorageKey(
                              widget.keyValue,
                            ),
                            constraints: BoxConstraints(
                              maxHeight:
                              MediaQuery.of(context)
                                  .size
                                  .height /
                                  2.5,

                            ),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft:
                                  Radius.circular(
                                      0),
                                  topRight:
                                  Radius.circular(
                                      6),
                                  bottomLeft:
                                  Radius.circular(
                                      6),
                                  bottomRight:
                                  Radius.circular(6
                                  ),)),
                            width: w,
                            child:
                            Stack(
                              fit: StackFit.expand,
                              children: [

                                Padding(
                                  padding:  EdgeInsets.only(bottom:13,top: widget.replydata !=null?2:8),
                                  child: Image(
                                      loadingBuilder:
                                          (context,
                                          child,
                                          loadingProgress) {
                                        if (loadingProgress ==
                                            null)
                                          return child;
                                        return const SizedBox(
                                          child: Center(
                                              child: CircularProgressIndicator(
                                                color: Color.fromRGBO(255, 255, 255, 1),
                                              )),
                                        );
                                      },
                                      fit: BoxFit.cover,
                                      image: ResizeImage(policy:ResizeImagePolicy.fit,
                                          NetworkImage(
                                              widget.message),width:700,height:800,allowUpscaling: true)),
                                ),
                                // Positioned(child:_downloadStatus[widget.messageList.message??""]==false?
                                //
                                // InkWell(
                                //     onTap: () {
                                //       _downloadloading[widget.messageList.message??""]=true;
                                //       _downloadImage(widget.messageList.message??"");
                                //       setState(() {
                                //
                                //       });
                                //     },
                                //     child:_downloadloading[widget.messageList.message??""]==false?  Padding(
                                //       padding:  EdgeInsets.only(right:w/6,left:w/6,top:h/6.1,bottom:h/6.1),
                                //       child: Container(
                                //           padding: EdgeInsets.all(10),
                                //           decoration: ShapeDecoration(
                                //             color: Colors.white.withOpacity(0.7900000214576721),
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(36),
                                //             ),
                                //           ),
                                //
                                //           child: SvgPicture.string(CommunicationSvg().imageIcon)),
                                //     )
                                //         :Padding(
                                //       padding:  EdgeInsets.only(right:w/4,left:w/4,top:h/6.1,bottom:h/6.1),
                                //       child: InkWell(
                                //         onTap: () {
                                //           _downloadImage(widget.messageList.message??"");
                                //         },
                                //         child: Container(
                                //             width: 50,
                                //             height: 40,
                                //             padding: EdgeInsets.all(10),
                                //             decoration: ShapeDecoration(
                                //               color: Colors.white.withOpacity(0.7900000214576721),
                                //               shape: RoundedRectangleBorder(
                                //                 borderRadius: BorderRadius.circular(36),
                                //               ),
                                //             ),
                                //
                                //             child:customCupertinoLoading()),
                                //       ),
                                //     ))
                                //     :
                                // SizedBox()),
                                Positioned(
                                  bottom: 0,
                                  right: 2,

                                  child:widget.me==false? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        widget.time??"",
                                        style: const TextStyle(
                                          fontSize: 8,
                                          color: Colors.black,
                                        ),
                                      ),

                                    ],
                                  ):Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.time??"",
                      style: const TextStyle(
                        fontSize: 8,
                        color: Color.fromARGB(255, 211, 209, 209),
                      ),
                    ),
                    SizedBox(width: 5,),
                    if(widget.grpid=="")...{
                      if(widget.activelength! >=2)...{
                        Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)
                      }
                      else if(widget.activelength! == 1 && widget.seenBy == null )...{
                        SizedBox()
                      }
                      else...{
                          widget.seenBy!.isEmpty?
                          SizedBox():
                          Icon(Icons.done,color: Color.fromARGB(255, 211, 209, 209),size: 13,)

                        }
                    } else...{
                      SizedBox()
                    }
                  ],
                ),
                                ),

                              ],

                            )),
                      ],
                    ),
                    Positioned(
                      top: -15,
                      right: 0,

                      // height: 25,
                      // color: Colors.white,
                      // width: w / 1.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height:30,
                            width: 30,
                            child: Center(
                              child: AdminTableDotIcon(
                                height: 30,
                                clr: Colors.transparent,
                                iconClr:widget.me?Colors.white: Colors.black,
                                icons: Icons.expand_more,
                                iconSize:20,

                                mouseHoverFunc: (val){

                                },
                                valueList: item,
                                onTap: (val){
                                  print("VAl$val");
                                  if(widget.onEvets!=null){widget.onEvets!(val);}



                                },),
                            ),
                          ),
                          SizedBox(width: 5,)
                        ],
                      ),
                    ),
                  ],
                )),),
          const SizedBox(
            height: 3,
          ),

          // SizedBox(height:widget.isselcted==true? 5:0,),
        ],
      ),
    );
  }
  String selectedText="";
  void _updateSelection(Offset localPosition,String url) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: url, style: TextStyle(color: Colors.blue)),
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);

    final Offset globalPosition = (context.findRenderObject() as RenderBox).localToGlobal(localPosition);
    final TextPosition textPosition = textPainter.getPositionForOffset(globalPosition);

    final int startIndex = textPosition.offset - 1;
    final int endIndex = textPosition.offset;
    if (startIndex >= 0 && endIndex <= url.length) {
      setState(() {
        selectedText =url.substring(startIndex, endIndex);
      });
      print('Selected Text: $selectedText');
    }
  }
}


// class CustomTextSelectionControls extends MaterialTextSelectionControls {
//   final Color selectionColor;
//
//   CustomTextSelectionControls({
//     required this.selectionColor,
//   });
//
//   @override
//   Color get handleColor => Colors.blue; // Default handle color
//
//   @override
//   Color getToolbarColor(BuildContext context) {
//     return selectionColor; // Custom selected text color
//   }
// }


Widget selectionAreaColorChange(BuildContext context,{required Widget child,bool isSected=false,Color color=Colors.blue}){
  return Theme(data: Theme.of(context).copyWith(
      textSelectionTheme: TextSelectionThemeData(
          selectionColor:isSected? color.withOpacity(.2):Colors.transparent)), child: child);
}
class CustomSelectableLinkify extends StatefulWidget {
  final String text;
  final TextStyle linkStyle;
  final List<Linkifier> linkifiers;
  final Function(LinkableElement) onOpen;
  final Function(int,{bool? val})? selectionChange;
  final bool isSelected;
  final Function selectionChange1;
  final ChatModel messageList;
  final Color textColor;

  final int? index;

  CustomSelectableLinkify({
    Key? key,
    required this.text,
    required this.linkStyle,
    required this.linkifiers,
    required this.onOpen,
    this.selectionChange,
    this.textColor=Colors.black,
    required this.index, required this.selectionChange1, required this.isSelected, required this.messageList,
  }):super(key: key);

  @override
  CustomSelectableLinkifyState createState() => CustomSelectableLinkifyState();
}

class CustomSelectableLinkifyState extends State<CustomSelectableLinkify> {
  bool isSelecting = false;
  late TextSelectionControls customSelectionControls;
  TextSelection? selectedText;
  TextStyle normalStyle = TextStyle(color: Colors.black);
  int tapCount = 0;
  int tapClickCount = 0;
  int tapCount1 = 0;
  Timer? _tapTimer;
  int startIndex = 0;
  int endIndex=0;
  final GlobalKey _textKey = GlobalKey();
  String selectedWord="";
  @override
  void initState() {
    super.initState();
    customSelectionControls = MaterialTextSelectionControls();
    normalStyle.copyWith(color: widget.textColor);// Use default Material controls
  }

  void clickTapDown() {
    print("sssssssssssssssssssss");
    tapClickCount++;
    print("tapCount++$tapCount");
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 300), () {
      if (tapClickCount == 2) {
        // Handle double tap
        // _selectWord(details);
      } else if (tapCount == 3) {

        // Handle triple tap
        _selectSentence();
      }
      tapCount1=tapClickCount;
      tapClickCount = 0;
    });
  }
  void handleTapDown(TapDownDetails details) {
print("sssssssssssssssssssss");
    tapCount++;
    print("tapCount++$tapCount");
    _tapTimer?.cancel();
    _tapTimer = Timer(const Duration(milliseconds: 300), () {
      if (tapCount == 2) {
        // Handle double tap
        _selectWord(details);
      } else if (tapCount == 3) {

        // Handle triple tap
        _selectSentence();
      }
      tapCount1=tapCount;
      tapCount = 0;
    });
  }
  void _selectSentence() {
     startIndex = 0;
     endIndex = widget.text.length;

    setState(() {
      selectedText = TextSelection(baseOffset: startIndex, extentOffset: endIndex);
      FlutterClipboard.copy(widget.text);
      isSelecting = true;
      widget.selectionChange!(widget.index??-1,val:true);
    });
  }
  void _selectWord(TapDownDetails details) {
    RenderBox renderBox = _textKey.currentContext!.findRenderObject() as RenderBox;
    Offset localOffset = renderBox.globalToLocal(details.globalPosition);
    TextPosition textPosition = _getTextPositionAtOffset(localOffset);
     selectedWord = _getWordAtPosition(textPosition);
    print("SelectedWord$selectedWord");
    FlutterClipboard.copy(selectedWord);

    if (selectedWord.isNotEmpty) {
       startIndex = _getWordStartIndex(textPosition);
       endIndex = startIndex + selectedWord.length;
      print("startIndex$selectedWord");
      print("end$endIndex");


      setState(() {
        selectedText = TextSelection(baseOffset: startIndex, extentOffset: endIndex);
        isSelecting = true;
        widget.selectionChange!(widget.index??-1,val:true);
      });
    }
  }

  // void _selectSentence(TapDownDetails details) {
  //   print("entering in full senetence");
  //   RenderBox renderBox = _textKey.currentContext!.findRenderObject() as RenderBox;
  //   Offset localOffset = renderBox.globalToLocal(details.globalPosition);
  //   TextPosition textPosition = _getTextPositionAtOffset(localOffset);
  //   String selectedSentence = _getSentenceAtPosition(textPosition);
  //   print("entering in full senetence$selectedSentence");
  //
  //   if (selectedSentence.isNotEmpty) {
  //     int startIndex = _getSentenceStartIndex(textPosition);
  //     int endIndex = startIndex + selectedSentence.length;
  //
  //     setState(() {
  //       selectedText = TextSelection(baseOffset: startIndex, extentOffset: endIndex);
  //       print("entering in full senetence$selectedText");
  //       print("entering in full senetence${selectedText?.end}");
  //       isSelecting = true;
  //     });
  //   }
  // }

  TextPosition _getTextPositionAtOffset(Offset localOffset) {
    final TextSpan textSpan = TextSpan(text: widget.text, style: normalStyle);
    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
    )..layout(maxWidth: double.infinity);

    return textPainter.getPositionForOffset(localOffset);
  }

  String _getWordAtPosition(TextPosition position) {
    final text = widget.text;
    if (text.isEmpty) return '';

    int start = position.offset;
    int end = position.offset;

    while (start > 0 && !_isWhitespace(text[start - 1])) {
      start--;
    }
    while (end < text.length && !_isWhitespace(text[end])) {
      end++;
    }

    return text.substring(start, end);
  }

  int _getWordStartIndex(TextPosition position) {
    final text = widget.text;
    if (text.isEmpty) return 0;

    int start = position.offset;

    while (start > 0 && !_isWhitespace(text[start - 1])) {
      start--;
    }

    return start;
  }

  String _getSentenceAtPosition(TextPosition position) {
    final text = widget.text;
    if (text.isEmpty) return '';

    int start = position.offset;
    int end = position.offset;

    while (start > 0 && text[start - 1] != '.') {
      start--;
    }
    while (end < text.length && text[end] != '.') {
      end++;
    }
    if (end < text.length) end++; // Include the period

    return text.substring(start, end).trim();
  }

  int _getSentenceStartIndex(TextPosition position) {
    final text = widget.text;
    if (text.isEmpty) return 0;

    int start = position.offset;

    while (start > 0 && text[start - 1] != '.') {
      start--;
    }

    return start;
  }

  bool _isWhitespace(String character) {
    return character == ' ' || character == '\n' || character == '\t';
  }

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(

        selectionColor:
        widget.isSelected?Colors.blue:Colors.transparent, // Change to desired highlight color
      ),
      child: GestureDetector(
        onTapDown: handleTapDown,



        child:
        SelectableText.rich(
          TextSpan(
            style: TextStyle(color: Colors.red),
            children: _buildTextSpans(widget.text),
          ),
          key: _textKey,
          onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
            if (selection.baseOffset != selection.extentOffset) {
              print("Selection start: $selection");
              isSelecting = true;
              if (widget.selectionChange != null) {
                widget.selectionChange!(widget.index!);
              }
              // Text is selected
              setState(() {
                selectedText = selection;
              });
            } else {
              // Text is not selected
              setState(() {
                isSelecting = false;
                // if (widget.selectionChange != null) {
                //   widget.selectionChange!(-1);
                // }
              });
            }
          },
          selectionControls: customSelectionControls,
        ),
      ),
    );
  }

  // List<TextSpan> _buildTextSpans() {
  //   List<TextSpan> spans = [];
  //   final elements = linkify(widget.text, linkifiers: widget.linkifiers);
  //
  //   elements.forEach((element) {
  //     if (element is TextElement) {
  //       spans.add(TextSpan(
  //         text: element.text,
  //         style: normalStyle,
  //       ));
  //     } else if (element is LinkableElement) {
  //       spans.add(TextSpan(
  //         text: element.text,
  //         style: widget.linkStyle,
  //         recognizer: TapGestureRecognizer()..onTap = () => widget.onOpen(element),
  //       ));
  //     }
  //   });
  //
  //   return spans;
  // }
  // List<TextSpan> _buildTextSpans(String text) {
  //   final elements = linkify(text, linkifiers: widget.linkifiers);
  //   List<TextSpan> spans = [];
  //   String targetWord = selectedWord;
  //
  //   for (final element in elements) {
  //     if (element is TextElement) {
  //       int startIndex = widget.text.indexOf(element.text);
  //       int endIndex = startIndex + element.text.length;
  //
  //       if (element.text.contains(targetWord)) {
  //         List<TextSpan> innerSpans = [];
  //         int currentPosition = 0;
  //
  //         while (currentPosition < element.text.length) {
  //           int wordStartIndex = element.text.indexOf(targetWord, currentPosition);
  //           if (wordStartIndex == -1) {
  //             // Add remaining text
  //             innerSpans.add(TextSpan(
  //               text: element.text.substring(currentPosition),
  //               style: normalStyle.copyWith(color: widget.textColor),
  //             ));
  //             break;
  //           }
  //           // Add text before the target word
  //           if (wordStartIndex > currentPosition) {
  //             innerSpans.add(TextSpan(
  //               text: element.text.substring(currentPosition, wordStartIndex),
  //               style: normalStyle.copyWith(color: widget.textColor),
  //             ));
  //           }
  //           // Add the target word with highlighted background
  //           innerSpans.add(TextSpan(
  //             text: targetWord,
  //             style: widget.linkStyle.copyWith(
  //               backgroundColor: Colors.blue,
  //               color: Colors.white,
  //             ),
  //           ));
  //           // Move past the target word
  //           currentPosition = wordStartIndex + targetWord.length;
  //         }
  //
  //         spans.add(TextSpan(children: innerSpans));
  //       } else {
  //         spans.add(TextSpan(
  //           text: element.text,
  //           style: normalStyle.copyWith(color: widget.textColor),
  //         ));
  //       }
  //     } else if (element is LinkableElement) {
  //       String url = element.text;
  //       if (!url.startsWith("http://") && !url.startsWith("https://")) {
  //         url = "http://$url"; // Prepend http:// if it doesn't start with it
  //       }
  //       spans.add(TextSpan(
  //         text: element.text,
  //         style: widget.linkStyle,
  //         recognizer: TapGestureRecognizer()
  //           ..onTap = () => widget.onOpen(LinkableElement(element.text, url)),
  //       ));
  //     }
  //   }
  //
  //   return spans;
  // }

  List<TextSpan> _buildTextSpans(String text) {
    final elements = linkify(text, linkifiers: widget.linkifiers);
    List<TextSpan> spans = [];

    for (final element in elements) {
      if (element is TextElement) {
        spans.add(TextSpan(
          text: element.text,
          style:
          widget.messageList.isDoubleClickCopy==true
              &&tapCount1==3 ? widget.linkStyle.copyWith(backgroundColor: Colors.blue,
              color: Colors.white) :
          normalStyle.copyWith(color: widget.textColor
          ),
        ));
      }  else if (element is LinkableElement) {
        String url = element.text;
        if (!url.startsWith("http://") && !url.startsWith("https://")) {
          url = "http://$url"; // Prepend http:// if it doesn't start with it
        }
        spans.add(TextSpan(
          text: element.text,
          style: widget.linkStyle,
          recognizer: TapGestureRecognizer()..onTap = () => widget.onOpen(LinkableElement(element.text, url)),
        ));
      }
    }

    return spans;
  }
  bool _isWithinSelectedRange(int startIndex, int endIndex, String text) {
    int textStartIndex = widget.text.indexOf(text);
    int textEndIndex = textStartIndex + text.length;

    return (textStartIndex >= startIndex && textStartIndex <= endIndex) ||
        (textEndIndex >= startIndex && textEndIndex <= endIndex) ||
        (textStartIndex <= startIndex && textEndIndex >= endIndex);
  }
}


class CustomTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Color get handleColor => Colors.red;
  TextSelectionControls get handleControls => this;
}