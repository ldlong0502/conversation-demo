import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:untitled/models/grammar.dart';
import 'package:untitled/repositories/grammar_repository.dart';

part 'grammar_event.dart';
part 'grammar_state.dart';

class GrammarBloc extends Bloc<GrammarEvent, GrammarState> {
  GrammarBloc() : super(GrammarInitial()) {

    final gramRepo = GrammarRepository.instance;
    on<GetAllGrammars>((event, emit) async {
      emit(GrammarLoading());
      final list = await gramRepo.getAllGrammars();

      emit(GrammarLoaded(listGrammars: list));
    });
  }
}
