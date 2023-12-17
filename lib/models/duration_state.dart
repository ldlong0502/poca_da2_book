class DurationState {
  const DurationState(
      {required this.progress, required this.buffered, required this.total});

  final Duration progress;
  final Duration buffered;
  final Duration total;

  DurationState copyWith({
    Duration? progress,
    Duration? buffered,
    Duration? total,
  }) {
    return DurationState(
      progress: progress ?? this.progress,
      buffered: buffered ?? this.buffered,
      total: total ?? this.total,
    );
  }
}
