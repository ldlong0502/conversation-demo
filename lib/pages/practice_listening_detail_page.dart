import 'package:flutter/material.dart';
import 'package:untitled/blocs/practice_listening_cubit/conversation_player_cubit.dart';
import 'package:untitled/blocs/practice_listening_cubit/current_lesson_cubit.dart';
import 'package:untitled/features/listening/conversation_list_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/listening/appbar_detail_player.dart';
class PracticeListeningDetailPage extends StatefulWidget {
  const PracticeListeningDetailPage({Key? key}) : super(key: key);

  @override
  State<PracticeListeningDetailPage> createState() => _PracticeListeningDetailPageState();
}

class _PracticeListeningDetailPageState extends State<PracticeListeningDetailPage> {


  @override
  void initState() {
    context.read<CurrentLessonCubit>().pause();
    super.initState();
  }
  @override
  void deactivate() {
    context.read<ConversationPlayerCubit>().dispose();
    context.read<CurrentLessonCubit>().dispose();
    super.deactivate();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.99),
      body: const Stack(
        children: [
          ConversationListView(),
          AppbarDetailPlayer(),
        ],
      ),
    );
  }
}
