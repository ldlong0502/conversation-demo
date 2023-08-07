import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/features/listening/conversation_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/widgets/loading_progress.dart';
import '../blocs/listening_effect_cubit/listening_effect_cubit.dart';
import '../features/listening/appbar_detail_player.dart';
import 'package:just_audio/just_audio.dart';
class PracticeListeningDetailPage extends StatefulWidget {
  const PracticeListeningDetailPage({Key? key}) : super(key: key);

  @override
  State<PracticeListeningDetailPage> createState() =>
      _PracticeListeningDetailPageState();
}

class _PracticeListeningDetailPageState
    extends State<PracticeListeningDetailPage> {

  final audioPlayer = AudioPlayer();
  @override
  void deactivate() {
    BlocProvider.of<ConversationPlayerCubit>(context).dispose();
    super.deactivate();
  }
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ListeningEffectCubit()..load(),
      child: BlocBuilder<ListeningEffectCubit, ListeningEffectState>(
        builder: (context, state) {
          if(state is ListeningEffectLoaded) {
            return Scaffold(
              backgroundColor: Colors.white.withOpacity(0.99),
              appBar:const PreferredSize(
                preferredSize: Size.fromHeight(180),
                child: AppbarDetailPlayer(),
              ),
              body: const ConversationListView(),
            );
          }
          return const Scaffold(body: LoadingProgress());
        },
      ),
    );
  }
}
