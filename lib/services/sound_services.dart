import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:mystory_flutter/providers/chatProvider.dart';
import 'package:mystory_flutter/services/util_service.dart';
import 'package:mystory_flutter/utils/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../global.dart';

String pathToSaveAudio = 'chat_audio.aac';

class SoundService {
  var utilService = locator<UtilService>();
  FlutterSoundRecorder? _audioRecorder;
  // FlutterSoundPlayer? _player;

  bool _isRecordingInitialised = false;

  bool get isRecording => _audioRecorder!.isRecording;

  Future init() async {
    _audioRecorder = FlutterSoundRecorder();
    // _player = FlutterSoundPlayer();

    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      throw Exception('Microphone permission not granted');
    }
    await _audioRecorder!.openAudioSession();
    // await _player!.openAudioSession();
    _isRecordingInitialised = true;
  }

  dispose() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.closeAudioSession();
    _audioRecorder = null;
    // _player = null;
    _isRecordingInitialised = false;
  }

  Future _record() async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!
        .startRecorder(codec: Codec.defaultCodec, toFile: pathToSaveAudio);
  }

  Future _stop(BuildContext context) async {
    if (!_isRecordingInitialised) return;
    await _audioRecorder!.stopRecorder().then((pathU) async {
      await utilService.sendAudioToStorage(pathU).then((url) async {
        await context
            .read<ChatProvider>()
            .sendMediaMessage(url, type: 'audio')
            .then((_) {
          Navigator.pop(context);
        });
      });
    });
  }

  Future toggoleRecording(BuildContext context) async {
    print(_audioRecorder!.isStopped);
    if (_audioRecorder!.isStopped) {
      await _record();
    } else {
      showLoadingAnimation(context);
      await _stop(context);
    }
  }
}
