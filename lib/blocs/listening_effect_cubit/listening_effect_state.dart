part of 'listening_effect_cubit.dart';

abstract class ListeningEffectState extends Equatable {
  const ListeningEffectState();
}

class ListeningEffectInitial extends ListeningEffectState {
  @override
  List<Object> get props => [];
}

class ListeningEffectLoaded extends ListeningEffectState {
  const ListeningEffectLoaded(
      {required this.isBlur,
      required this.isSpeed,
      required this.isPhonetic,
      required this.isTranslate});

  final bool isBlur;
  final bool isSpeed;
  final bool isPhonetic;
  final bool isTranslate;
  ListeningEffectLoaded copyWith({
    bool? isBlur,
    bool? isSpeed,
    bool? isPhonetic,
    bool? isTranslate,
  }) {
    return ListeningEffectLoaded(
      isBlur: isBlur ?? this.isBlur,
      isSpeed: isSpeed ?? this.isSpeed,
      isPhonetic: isPhonetic ?? this.isPhonetic,
      isTranslate: isTranslate ?? this.isTranslate,
    );
  }
  @override
  List<Object> get props => [isBlur, isSpeed, isPhonetic, isTranslate];
}
