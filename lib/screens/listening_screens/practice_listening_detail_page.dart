import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/features/listening/conversation_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/services/sound_service.dart';
import 'package:untitled/widgets/loading_progress.dart';
import '../../blocs/listening_effect_cubit/listening_effect_cubit.dart';
import '../../features/listening/appbar_detail_player.dart';

class PracticeListeningDetailPage extends StatefulWidget {
  const PracticeListeningDetailPage({Key? key, required this.positionNow}) : super(key: key);
  final Duration positionNow;
  @override
  State<PracticeListeningDetailPage> createState() =>
      _PracticeListeningDetailPageState();
}

class _PracticeListeningDetailPageState
    extends State<PracticeListeningDetailPage> {

  final soundService = SoundService.instance;

  @override
  void dispose() {
    soundService.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<CurrentLessonCubit>().state!;
    return BlocProvider(
      create: (context) => ListeningEffectCubit()..load(),
      child: BlocBuilder<ListeningEffectCubit, ListeningEffectState>(
        builder: (context, state) {
          if(state is ListeningEffectLoaded) {
            return Scaffold(
              backgroundColor: Colors.white.withOpacity(0.99),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(180),
                child: AppbarDetailPlayer(
                 positionNow: widget.positionNow
                ),
              ),
              body:  ConversationListView(listSentences: cubit.sentences,),
            );
          }
          return const Scaffold(body: LoadingProgress());
        },
      ),
    );
  }
}
