import 'package:flutter/material.dart';
import 'package:untitled/blocs/kanji_cubit/kanji_cubit.dart';
import 'package:untitled/configs/app_color.dart';
import 'package:untitled/features/kanji/practice_writing/animate_kanji_draw.dart';
import 'package:untitled/features/kanji/practice_writing/float_button_drawing.dart';
import 'package:untitled/widgets/float_navigate_button.dart';

import '../../../blocs/kanji_practice_writing_cubit/kanji_practice_writing_cubit.dart';
import '../../../blocs/list_kanji_cubit/list_kanji_cubit.dart';
import '../../../models/drawing_point.dart';
import '../../../models/kanji.dart';
import '../../../utils/split_text.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawing_painter.dart';

class DrawingRoom extends StatefulWidget {
  const DrawingRoom({super.key, required this.kanji, required this.state});

  final Kanji kanji;
  final KanjiPracticeWritingLoaded state;

  @override
  State<DrawingRoom> createState() => _DrawingRoomState();
}

class _DrawingRoomState extends State<DrawingRoom>
    with TickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    if (!mounted) return;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animationController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  var historyDrawingPoints = <DrawingPoint>[];
  var drawingPoints = <DrawingPoint>[];

  var selectedColor = AppColor.blue;
  var selectedWidth = 10.0;

  DrawingPoint? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final cubit = context.watch<KanjiPracticeWritingCubit>();
    final listKanjis = BlocProvider.of<ListKanjiCubit>(context).state!;
    final index =
        listKanjis.indexWhere((element) => element.id == widget.kanji.id);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              /// Canvas
              Container(
                height: size.height * 0.5,
                width: size.width,
                margin:
                    const EdgeInsets.all(20).copyWith(top: size.height * 0.15),
                child: GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      currentDrawingPoint = DrawingPoint(
                        id: DateTime.now().microsecondsSinceEpoch,
                        offsets: [
                          details.localPosition,
                        ],
                        color: selectedColor,
                        width: selectedWidth,
                      );

                      if (currentDrawingPoint == null) return;
                      drawingPoints.add(currentDrawingPoint!);
                      historyDrawingPoints = List.of(drawingPoints);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      if (currentDrawingPoint == null) return;

                      Offset position = details.localPosition;

                      // Check if the position is inside the container
                      if (position.dx >= size.width * 0.1 &&
                          position.dx <= size.width * 0.8 &&
                          position.dy >= 0 &&
                          position.dy <= size.height * 0.5) {
                        currentDrawingPoint = currentDrawingPoint?.copyWith(
                          offsets: currentDrawingPoint!.offsets
                            ..add(details.localPosition),
                        );
                      }

                      drawingPoints.last = currentDrawingPoint!;
                      historyDrawingPoints = List.of(drawingPoints);
                    });
                  },
                  onPanEnd: (_) {
                    currentDrawingPoint = null;
                  },
                  child: CustomPaint(
                    painter: DrawingPainter(
                      drawingPoints: drawingPoints,
                    ),
                  ),
                ),
              ),
              AnimateKanjiDraw(
                  animationController: _animationController,
                  state: widget.state),
              FloatButtonDrawing(
                  onPlay: onPlay,
                  onRedo: onRedo,
                  onHide: onHide,
                  onDelete: onDelete,
                  state: widget.state),
            ],
          ),
        ),
        FloatNavigateButton(
          max: listKanjis.length,
          index: index,
          onNext: () {
            final nextIndex = index + 1 >=  listKanjis.length ? 0 : index + 1;
            cubit.updateKanji(listKanjis[nextIndex]);
            _animationController.forward(from: 0);
          },
          onPrevious: () {
            final previousIndex = index - 1 < 0   ? listKanjis.length - 1 : index - 1;
            cubit.updateKanji(listKanjis[previousIndex]);
            _animationController.forward(from: 0);
          },
        )
      ],
    );
  }

  void onNext() {

  }
  void onPrevious() {

  }
  void onPlay() {
    if (!_animationController.isAnimating) {
      _animationController.forward(from: 0.0);
    }
  }

  void onRedo() {
    if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
      setState(() {
        drawingPoints.removeLast();
      });
    }
  }

  void onDelete() {
    setState(() {
      drawingPoints.clear();
    });
  }

  void onHide() {
    if (widget.state.isHideCoordinates) {
      _animationController.forward(from: 0.0);
    }

    BlocProvider.of<KanjiPracticeWritingCubit>(context)
        .updateIsHideCoordinates();
  }
}
