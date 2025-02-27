part of 'sound_receirver_mode_cubit.dart';

const int vadThreshold = 34000;

class SoundReceiverModeState extends Equatable {
  const SoundReceiverModeState({
    this.ticketToken,
    this.isMicGranted = true,
    this.isModeActive = false,
    this.code = '',
    this.streamId = '',
  });
  final String? ticketToken;
  final bool isMicGranted;
  final bool isModeActive;
  final String code;
  final String streamId;

  @override
  List<Object?> get props => [
        ticketToken,
        isMicGranted,
        isModeActive,
        code,
        streamId,
      ];

  SoundReceiverModeState copyWith({
    String? ticketToken,
    bool? isMicGranted,
    bool? isModeActive,
    String? code,
    String? streamId,
  }) {
    return SoundReceiverModeState(
      ticketToken: ticketToken ?? this.ticketToken,
      isMicGranted: isMicGranted ?? this.isMicGranted,
      isModeActive: isModeActive ?? this.isModeActive,
      code: code ?? this.code,
      streamId: streamId ?? this.streamId,
    );
  }
}
