import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class ElevenLabs {
  final String voice = "3EW6UgZeJK77gVrQEc5y";
  final String apiUrl =
      "https://api.elevenlabs.io/v1/text-to-speech/3EW6UgZeJK77gVrQEc5y";

  final Map<String, String> headers = {
    "Accept": "audio/mpeg",
    "Content-Type": "application/json",
    "xi-api-key": "9e9f8a5292bc328dc37f58fc8337dcb2",
  };

  Future<Uint8List> fetchSpeechFromAPI(String text) async {
    String data = jsonEncode({
      "text": text,
      "model_id": "eleven_turbo_v2",
      "voice_settings": {"stability": 0.5, "similarity_boost": 0.5}
    });

    try {
      final response =
          await http.post(Uri.parse(apiUrl), body: data, headers: headers);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        log('Request failed with status: ${response.statusCode}.');
        return Uint8List(0);
      }
    } catch (e) {
      log("An error occurred: $e");
      return Uint8List(0);
    }
  }

  Future<String> saveSpeechToFile(
      Uint8List speechBytes, String filename) async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File filePath = File(
        '$tempPath/audio_message_${DateTime.now().millisecondsSinceEpoch}.mp3');
    await filePath.writeAsBytes(speechBytes);
    log("save audio_dictory: ${filePath.path}");
    return filePath.path;
  }
}
