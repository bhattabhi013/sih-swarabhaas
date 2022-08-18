import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:jitsi_meet_wrapper/jitsi_meet_wrapper.dart';

class JitseeMeet {
  final user = FirebaseAuth.instance.currentUser;
  void joinMeet(
      {required String room,
      required bool isAudio,
      required bool isVideo}) async {
    try {
      // FeatureFlag featureFlag = FeatureFlag();
      // featureFlag.welcomePageEnabled = true;
      // featureFlag.closeCaptionsEnabled = true;
      // featureFlag.resolution = FeatureFlagVideoResolution
      //     .MD_RESOLUTION; // Limit video resolution to 360p
      var options = JitsiMeetingOptions(
        roomNameOrUrl: room,
        isAudioOnly: isAudio,
        isVideoMuted: isVideo,
        userDisplayName: user!.displayName,
        userEmail: user!.email,
        // featureFlags: featureFlags,
      );

      // var options = JitsiMeetingOptions(room: room
      //   ..userDisplayName : user!.displayName
      //   ..userEmail = user!.email
      //   ..userAvatarURL = user!.photoURL
      //   ..audioOnly = isAudio
      //   ..videoMuted = isVideo
      //   ..featureFlags.addAll(featureFlags));

      await JitsiMeetWrapper.joinMeeting(options: options);
    } catch (error) {
      debugPrint("error: $error");
    }
  }

  void createMeeting(
      {required String roomName,
      required bool isAudioMuted,
      required bool isVideoMuted,
      required String username}) {}
}
