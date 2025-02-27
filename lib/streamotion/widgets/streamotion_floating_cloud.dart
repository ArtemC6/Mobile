import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:particle_field/particle_field.dart';
import 'package:rnd/rnd.dart';
import 'package:voccent/streamotion/cubit/models/streamotion_model.dart';
import 'package:voccent/streamotion/cubit/pid.dart';
import 'package:voccent/streamotion/widgets/streamotion_utils.dart';

class StreamotionFloatingCloud extends StatefulWidget {
  const StreamotionFloatingCloud({
    required this.stackBelowWidget,
    required this.noise,
    required this.displayingEmotionSink,
    required this.emotion,
    super.key,
  });

  final Widget stackBelowWidget;
  final double noise;
  final StreamSink<StreamotionCompareModel> displayingEmotionSink;
  final StreamotionCompareModel? emotion;

  @override
  State<StreamotionFloatingCloud> createState() =>
      _StreamotionFloatingCloudState();
}

class _StreamotionFloatingCloudState extends State<StreamotionFloatingCloud> {
  late SpriteSheet sprite;
  StreamotionCompareModel previousEmotion = const StreamotionCompareModel();
  late PID pidArousal;
  late PID pidValence;

  @override
  void initState() {
    sprite = SpriteSheet(
      image: const AssetImage('assets/Kiki Bouba.png'),
      frameWidth: 31,
      frameHeight: 23,
      length: 26,
    );
    pidArousal = PID(
      Kp: 0.01,
      minOutput: -1.0 - widget.noise,
      maxOutput: 1.0 + widget.noise,
    );
    pidValence = PID(
      Kp: 0.01,
      minOutput: -1.0 - widget.noise,
      maxOutput: 1.0 + widget.noise,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ParticleField(
      // start out the same:
      spriteSheet: sprite,
      blendMode: BlendMode.dstIn,
      origin: Alignment.topLeft,
      // but with a different onTick handler:
      onTick: (controller, elapsed, size) {
        final rnd = Random();
        final particles = controller.particles;
        final emotion = widget.emotion;
        if (emotion != null) {
          var arousal = emotion.arousal;
          var valence = emotion.valence;

          pidArousal.setPoint = arousal;
          arousal = previousEmotion.arousal +
              pidArousal(previousEmotion.arousal, dt: elapsed);

          pidValence.setPoint = valence;
          valence = previousEmotion.valence +
              pidValence(previousEmotion.valence, dt: elapsed);

          final displayedEmotion =
              StreamotionCompareModel(valence: valence, arousal: arousal);

          widget.displayingEmotionSink.add(displayedEmotion);
          previousEmotion = displayedEmotion;

          final color = StreamotionUtils.getPointColor(valence, arousal);
          arousal = rnd(arousal - widget.noise, arousal + widget.noise);
          valence = rnd(valence - widget.noise, valence + widget.noise);

          particles.add(
            Particle(
              x: (valence + 1) * size.width / 2.0,
              y: (1 - arousal) * size.height / 2.0,
              color: color.withOpacity(0.2),
              // scale: 0.3,
              frame: rnd.nextInt(13) + (emotion.valence > 0 ? 13 : 0),
              rotation: rnd(pi),
              lifespan: 1000,
              // age: 0,
            ),
          );
        } else {
          // particles.add(
          //   Particle(
          //     x: size.width / 2.0,
          //     y: size.height / 2.0,
          //     color: Colors.white,
          //     frame: rnd.nextInt(13),
          //     rotation: rnd(pi),
          //     lifespan: 50,
          //   ),
          // );
        }

        for (var i = particles.length - 1; i >= 0; i--) {
          final particle = particles[i];
          // calculate ratio of age vs lifespan:
          final ratio = particle.age / particle.lifespan;
          // update the particle (remember, it automatically applies vx/vy):
          particle.update(
            // accelerate, by adding to velocity y each frame:
            // vy: particle.vy - 0.1,
            // scale down as the particle approaches its lifespan:
            scale: sqrt((1 - ratio) * 10),
            // fade out as the particle approaches its lifespan:
            color: particle.color.withOpacity(ratio),
            // advance the spritesheet frame:
            frame: particle.frame >= 13
                ? (particle.frame + 1) % 13 + 13
                : (particle.frame + 1) % 13,
          );
          // remove particle if its age exceeds its lifespan:
          if (particle.age > particle.lifespan) particles.removeAt(i);
        }
      },
    ).stackBelow(child: widget.stackBelowWidget);
  }
}
