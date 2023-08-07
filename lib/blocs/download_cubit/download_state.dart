part of 'download_cubit.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();
}

class DownloadInitial extends DownloadState {
  @override
  List<Object> get props => [];
}

class DownloadLoading extends DownloadState {
  const DownloadLoading({required this.progress});
  final int progress;
  @override
  List<Object> get props => [progress];
}
class DownloadLoaded extends DownloadState {
  @override
  List<Object> get props => [];
}