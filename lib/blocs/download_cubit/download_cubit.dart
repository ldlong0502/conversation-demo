import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'download_state.dart';

class DownloadCubit extends Cubit<DownloadState> {
  DownloadCubit() : super(DownloadInitial());
  void updateProgress(int progress) {
    if(progress >=0 && progress <= 100) {
      emit(DownloadLoading(progress: progress));
    }
    if(progress == 100) {
      emit(DownloadLoaded());
    }
  }
}
