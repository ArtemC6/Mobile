import 'package:flutter/material.dart';

class HighlightWords {
  RichText formatSpecialWord(String text, ColorScheme mTheme) {
    // Updated RegExp to match words and hashtags
    final regExp = RegExp(
      r'(#\p{L}[\p{L}\p{M}\d]*|\p{L}[\p{L}\p{M}\d]*\p{L}[\p{L}\p{M}\d]*)',
      unicode: true,
    );

    final matches = regExp.allMatches(text);
    final spans = <TextSpan>[];
    var start = 0;

    for (final match in matches) {
      // Adding text before the match as normal text
      if (start < match.start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start).toUpperCase(),
            style: TextStyle(
              color: mTheme.onSurface.withOpacity(1),
              fontSize: 16,
              letterSpacing: 0.1,
            ),
          ),
        );
      }

      // Check if the matched word starts with '#'
      final isSpecialWord = text[match.start] == '#';
      spans.add(
        TextSpan(
          text: text
              .substring(
                isSpecialWord ? match.start + 1 : match.start,
                match.end,
              )
              .toUpperCase(),
          style: isSpecialWord
              ? TextStyle(
                  color: const Color.fromARGB(255, 107, 121, 255),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.1,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: const Color.fromARGB(255, 107, 121, 255)
                          .withAlpha(150),
                    ),
                  ],
                )
              : TextStyle(
                  color: mTheme.onSurface.withOpacity(1),
                  fontSize: 18,
                  letterSpacing: 0.1,
                ),
        ),
      );
      start = match.end;
    }

    // Add any remaining text after the last match
    if (start < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(start).toUpperCase(),
          style: TextStyle(
            color: mTheme.onSurface.withOpacity(1),
            fontSize: 18,
            letterSpacing: 0.1,
          ),
        ),
      );
    }

    return RichText(text: TextSpan(children: spans));
  }
}
