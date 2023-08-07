class PositionData {
  final Duration position;
  final Duration duration;
  final Duration bufferedPosition;
  PositionData({
    required this.position,
    required this.bufferedPosition,
    required this.duration,
  });
}