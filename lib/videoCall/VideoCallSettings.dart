import 'dart:math';
import 'package:thws_study_helfer/model/utils.dart';
import 'package:flutter/material.dart';
import 'package:thws_study_helfer/model/globals.dart' as globals;
import 'package:zego_uikit_prebuilt_video_conference/zego_uikit_prebuilt_video_conference.dart';
class VideoCallSettings extends StatelessWidget {
  final String conferenceID;
  VideoCallSettings({
    Key? key,
    required this.conferenceID,
  }) : super(key: key);
  final conferenceIdController = TextEditingController();
  final String userId = Random().nextInt(900000 + 100000).toString();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ZegoUIKitPrebuiltVideoConference(
        appID: Utils.appId,
        appSign: Utils.appSignIn,
        userID: 'user_$userId',
        userName: globals.userName,
        conferenceID: conferenceID,
        config: ZegoUIKitPrebuiltVideoConferenceConfig(),
      ),
    );
  }
}