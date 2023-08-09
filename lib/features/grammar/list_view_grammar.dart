import 'package:flutter/material.dart';
import 'package:untitled/features/grammar/grammar_item.dart';
import '../../models/grammar.dart';

class ListViewGrammar extends StatelessWidget {
  const ListViewGrammar({Key? key, required this.listGrammar})
      : super(key: key);
  final List<Grammar> listGrammar;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
        itemCount: listGrammar.length,
        itemBuilder: (context, index) {
          return GrammarItem(grammar: listGrammar[index]);
        });
  }
}
