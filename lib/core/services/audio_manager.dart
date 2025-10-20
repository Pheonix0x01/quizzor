import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  final AudioPlayer _musicPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  
  bool _isSoundEnabled = true;
  bool _isMusicPlaying = false;

  bool get isSoundEnabled => _isSoundEnabled;
  bool get isMusicPlaying => _isMusicPlaying;

  void setSoundEnabled(bool enabled) {
    _isSoundEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  Future<void> playBackgroundMusic() async {
    if (!_isSoundEnabled || _isMusicPlaying) return;
    
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      await _musicPlayer.setVolume(0.3);
      await _musicPlayer.play(AssetSource('audio/background_music.mp3'));
      _isMusicPlaying = true;
    } catch (e) {
      print('Error playing background music: $e');
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _musicPlayer.stop();
    _isMusicPlaying = false;
  }

  Future<void> playClickSound() async {
    if (!_isSoundEnabled) return;
    
    try {
      await _sfxPlayer.play(AssetSource('audio/click.wav'));
    } catch (e) {
      print('Error playing click sound: $e');
    }
  }

  void dispose() {
    _musicPlayer.dispose();
    _sfxPlayer.dispose();
  }
}