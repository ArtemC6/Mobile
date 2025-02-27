import 'package:flutter/material.dart';

class ImageWidget {
  ImageWidget({
    required this.serverUri,
    required this.height,
    required this.width,
  });
  final String serverUri;
  final double height;
  final double width;
  static const opacity = .7;

  Image getImageForType(String keyword, String id) {
    switch (keyword) {
      case 'playlist':
        return Image.network(
          '$serverUri/api/v1/asset/file/challenge_picture/$id',
          height: height,
          width: width,
          opacity: const AlwaysStoppedAnimation(opacity),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/content-types/playlists.jpeg',
            height: height,
            width: width,
            opacity: const AlwaysStoppedAnimation(opacity),
            fit: BoxFit.cover,
          ),
        );
      case 'challenge':
        return Image.network(
          '$serverUri/api/v1/asset/object/challenge_picture/$id',
          height: height,
          width: width,
          opacity: const AlwaysStoppedAnimation(opacity),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/content-types/challenges.jpeg',
            height: height,
            width: width,
            opacity: const AlwaysStoppedAnimation(opacity),
            fit: BoxFit.cover,
          ),
        );
      case 'challenge_banner':
        return Image.network(
          '$serverUri/api/v1/asset/file/challenge_picture/$id',
          height: height,
          width: width,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          opacity: const AlwaysStoppedAnimation(.6),
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/Ccwhitebg.png',
            height: height,
            width: width,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
            opacity: const AlwaysStoppedAnimation(.6),
          ),
        );
      case 'story':
        return Image.network(
          '$serverUri/api/v1/asset/object/story_picture/$id',
          height: height,
          width: width,
          opacity: const AlwaysStoppedAnimation(opacity),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/voc_button.png',
            height: height,
            width: width,
            opacity: const AlwaysStoppedAnimation(opacity),
            fit: BoxFit.cover,
          ),
        );
      case 'channel':
        return Image.network(
          '$serverUri/api/v1/asset/file/channel_avatar/$id',
          height: height,
          width: width,
          opacity: const AlwaysStoppedAnimation(opacity),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.asset(
            'assets/images/voc_button.png',
            height: height,
            width: width,
            opacity: const AlwaysStoppedAnimation(opacity),
            fit: BoxFit.cover,
          ),
        );
      default:
        return Image.asset(
          'assets/images/Ccwhitebg.png',
          opacity: const AlwaysStoppedAnimation(opacity),
          fit: BoxFit.cover,
          height: height,
          width: width,
        );
    }
  }
}
