import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jitsi_meet/jitsi_meet.dart';

class JitseeMeet {
  final user = FirebaseAuth.instance.currentUser;
  void joinMeet(
      {required String room,
      required bool isAudio,
      required bool isVideo}) async {
    try {
      Map<FeatureFlagEnum, bool> featureFlags = {
        FeatureFlagEnum.WELCOME_PAGE_ENABLED: true,
        FeatureFlagEnum.CLOSE_CAPTIONS_ENABLED: true,
      };
      // FeatureFlag featureFlag = FeatureFlag();
      // featureFlag.welcomePageEnabled = true;
      // featureFlag.closeCaptionsEnabled = true;
      // featureFlag.resolution = FeatureFlagVideoResolution
      //     .MD_RESOLUTION; // Limit video resolution to 360p

      var options = JitsiMeetingOptions(room: room)
        ..userDisplayName = user!.displayName
        ..userEmail = user!.email
        ..userAvatarURL = user!.photoURL
        ..audioOnly = isAudio
        ..videoMuted = isVideo
        ..featureFlags.addAll(featureFlags);

      await JitsiMeet.joinMeeting(options);
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