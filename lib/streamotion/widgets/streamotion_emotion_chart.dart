import 'dart:math';

import 'package:flutter/material.dart';
import 'package:voccent/streamotion/cubit/models/streamotion_model.dart';
import 'package:voccent/streamotion/widgets/streamotion_utils.dart';

class StreamotionEmotionChart extends StatelessWidget {
  const StreamotionEmotionChart(this.data, this.currentEmotion, {super.key});

  final Stream<StreamotionCompareModel> currentEmotion;
  final Map<String, StreamotionCompareModel> data;

  Size _textSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  double _computeHighlightLevel(
    double x,
    double y,
    StreamotionCompareModel emotionData,
  ) {
    final distance2 =
        pow(x - emotionData.valence, 2) + pow(y - emotionData.arousal, 2);
    return max(1 - sqrt(distance2), 0) * max(1 - sqrt(distance2), 0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return StreamBuilder<StreamotionCompareModel>(
          stream: currentEmotion,
          initialData: const StreamotionCompareModel(),
          builder: (context, snapshot) {
            final emotionData = snapshot.data!;

            final sortedEntries = data.entries.toList()
              ..sort((entryA, entryB) {
                final highlightA = _computeHighlightLevel(
                  entryA.value.valence,
                  entryA.value.arousal,
                  emotionData,
                );
                final highlightB = _computeHighlightLevel(
                  entryB.value.valence,
                  entryB.value.arousal,
                  emotionData,
                );
                return highlightA.compareTo(highlightB);
              });

            return Stack(
              clipBehavior: Clip.antiAlias,
              children: sortedEntries.map((entry) {
                final text = entry.key;
                final size = _textSize(text, const TextStyle(fontSize: 20));

                final width = constraints.maxWidth - size.width;
                final height = constraints.maxHeight - size.height;

                final y = entry.value.arousal;
                final x = entry.value.valence;
                final left = (x + 1) * (width / 2.0);
                final top = (1 - y) * (height / 2.0);

                final highlightLevel =
                    _computeHighlightLevel(x, y, emotionData);

                var color = StreamotionUtils.getPointColor(x, y);
                const criticalHighlightLevel = 0.2;
                color = color.withOpacity(highlightLevel * 0.5 + 0.5);

                return Positioned(
                  left: left,
                  top: top,
                  child: Transform.scale(
                    scale: highlightLevel * 0.6 + 0.7,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        // backgroundBlendMode: BlendMode.overlay,
                        color: highlightLevel > criticalHighlightLevel
                            ? Colors.black
                            : Colors.transparent,
                        border: Border.all(
                          color: highlightLevel > criticalHighlightLevel
                              ? StreamotionUtils.getPointColorAccent(x, y)
                              : Colors.transparent,
                          width: 1.3,
                        ),
                      ),
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontSize: 20,
                              color: color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        );
      },
    );
  }
}
