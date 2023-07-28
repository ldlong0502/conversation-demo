import 'package:flutter/material.dart';
import 'package:untitled/blocs/bloc_grammar/grammar_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/views/screens/grammar_details_screen.dart';
import '../../constants/constants.dart';
import '../../models/grammar.dart';

class GrammarScreen extends StatelessWidget {
  const GrammarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          listViewGrammar(context),
          headerTitle(context),
        ],
      ),
    );
  }

  headerTitle(context) {
    return Container(
        height: 70,

        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: primaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0.0, 3.0),
              spreadRadius: 2,
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      onPressed: () {
                        // Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.settings,
                        color: secondaryColor,
                        size: 30,
                      )),
                ),
              ),
              const Expanded(
                  flex: 3,
                  child: Center(
                      child: Text(
                        'GRAMMAR',
                        style: TextStyle(
                            color: secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ))),
              Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.star_rounded,
                            color: secondaryColor,
                            size: 30,
                          )),
                      IconButton(
                          onPressed: () {
                            // Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.search_rounded,
                            color: secondaryColor,
                            size: 30,
                          )),
                    ],
                  ))
            ],
          ),
        ]));
  }

  listViewGrammar(context) {
    return BlocBuilder<GrammarBloc, GrammarState>(
      builder: (context, state) {
        if (state is GrammarLoaded) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 90, right: 20, left: 20),
                itemCount: state.listGrammars.length,
                itemBuilder: (context, idx) {
                  return Container(
                    height: 55,
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    decoration: BoxDecoration(
                        color: primaryColor,
                        border: Border.all(color: secondaryColor, width: 1),
                        borderRadius: BorderRadius.circular(50)),
                    child: grammarItem(state.listGrammars[idx], context)
                  );
                }),
          );
        }
        else {
          return Container();
        }
      },
    );
  }

  grammarItem(Grammar item , context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) => GrammarDetailsScreen(grammar: item)));
        },
        child: SizedBox(
          child: Row(
            children: [
              Expanded(
                  child: Container(
                    height: 30,
                    width: 30,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration:  BoxDecoration(
                        shape: BoxShape.circle,
                        color: secondaryColor.withOpacity(0.7)
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                        Icons.circle,
                        color: Colors.white, size: 8),
                  ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.titleVi.toUpperCase(), style: kTitle, maxLines: 1),
                    Text( '(${item.title})', style: kSubTitle, maxLines: 1),
                  ],
                ),
              ),
              const Expanded(child: Icon(
                Icons.navigate_next_outlined, size: 30,
                color: secondaryColor,)),
            ],
          ),)
        ,

      )
      ,
    );
  }
}
