part of 'grammar_cubit.dart';

abstract class GrammarState extends Equatable {
  const GrammarState();
}

class GrammarInitial extends GrammarState {
  @override
  List<Object> get props => [];
}

class GrammarLoading extends GrammarState {
  @override
  List<Object> get props => [];
}

class GrammarLoaded extends GrammarState {
  final List<Grammar> listGrammars;

  const GrammarLoaded({required this.listGrammars});

  @override
  List<Object> get props => [listGrammars];
}
