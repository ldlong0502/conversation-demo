part of 'grammar_bloc.dart';

abstract class GrammarEvent extends Equatable {
  const GrammarEvent();
}


class GetAllGrammars extends GrammarEvent {
  const GetAllGrammars();
  @override
  List<Object> get props => [];
}