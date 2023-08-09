import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/repositories/lesson_repository.dart';

part 'listening_effect_state.dart';

class ListeningEffectCubit extends Cubit<ListeningEffectState> {
  ListeningEffectCubit() : super(ListeningEffectInitial());
  final repo = LessonRepository.instance;
  void load() async {
    final isBlur = await repo.getBlur();
    final isTranslate = await repo.getTranslate();
    final isPhonetic = await repo.getPhonetic();
    emit(
        ListeningEffectLoaded(
            isBlur: isBlur,
            isSpeed: false,
            isPhonetic: isPhonetic,
            isTranslate: isTranslate));
  }

  void updateEffect(int index) async {
    if(state is ListeningEffectLoaded) {
      var stateNow = state as ListeningEffectLoaded;
      if (index == 1) {
        await repo.setBlur(!stateNow.isBlur);
        emit(stateNow.copyWith(isBlur: !stateNow.isBlur));
      } else if (index == 2) {
        await repo
            .setTranslate(!stateNow.isTranslate);
        emit(stateNow.copyWith(isTranslate: !stateNow.isTranslate));
      } else if (index == 3) {
        await repo
            .setPhonetic(!stateNow.isPhonetic);
        emit(stateNow.copyWith(isPhonetic: !stateNow.isPhonetic));
      }
      else {
        emit(stateNow.copyWith(isSpeed: !stateNow.isSpeed));
      }
    }
  }
}
