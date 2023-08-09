import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/repositories/grammar_repository.dart';

import '../../models/grammar.dart';

// class GrammarCubit extends Cubit<List<Grammar>?> {
//   GrammarCubit() : super(null);
//   void load() async => emit(await GrammarRepository.instance.getAllGrammars());
// }
import 'package:equatable/equatable.dart';

part 'grammar_state.dart';

class GrammarCubit extends Cubit<GrammarState> {
  final repo = GrammarRepository.instance;

  GrammarCubit() : super(GrammarInitial());
  late List<Grammar> listGrammars;
  void getData() async {
    emit(GrammarLoading());
    await repo.downloadFile();
    listGrammars = await repo.getGrammars();
    emit(GrammarLoaded(listGrammars: listGrammars));
  }
}
