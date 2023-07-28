import 'package:flutter/material.dart';

import '../../blocs/bloc_kanji/kanji_bloc.dart';
import '../../constants/constants.dart';
import '../../models/drawing_point.dart';
import 'package:drawing_animation/drawing_animation.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/split_text.dart';
class DrawingRoomWidget extends StatefulWidget {
  const DrawingRoomWidget({super.key,required this.state});
  final KanjiLoaded state;
  @override
  State<DrawingRoomWidget> createState() => _DrawingRoomWidgetState();
}

class _DrawingRoomWidgetState extends State<DrawingRoomWidget> with TickerProviderStateMixin {
  late AnimationController _animationController;


  @override
  void initState() {
    super.initState();
    if(!mounted) return;
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

  var selectedColor = secondaryColor;
  var selectedWidth = 10.0;

  DrawingPoint? currentDrawingPoint;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                margin: EdgeInsets.all(20).copyWith(
                  top: size.height * 0.15
                ),
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
                      if (position.dx >= size.width * 0.1 && position.dx <= size.width * 0.8 && position.dy >= 0 && position.dy <= size.height * 0.5 ) {
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
               _buildAnimateDraw(),
              _buildActionSlider(),

              /// color pallet


              /// pencil size
            ],
          ),

        ),
        _buildFloatAction(widget.state)
      ],
    );
  }

  _buildAnimateDraw() {
    final listStringPath = SplitText().extractPathDataList(widget.state.kanjiCurrent.path);
    final paint = Paint()
      ..color = secondaryColor
      ..strokeWidth = 5.0
      ..style = PaintingStyle.stroke;
    var listPath = <Path>[];
    var listPaints = <Paint>[];
    for (var i in listStringPath) {
      listPath.add(parseSvgPathData(i));
      listPaints.add(paint);
    }
    return Positioned(
        top: 50,
        left: 30,
        child: Opacity(
          opacity: !widget.state.isHideActionPracticeWriting ? 1 : 0,
          child: Container(
            margin: const EdgeInsets.all(20),
            height: 70,width: 70,
          child: Stack(
            children: [
              AnimatedDrawing.paths(
                listPath,
                paints: listPaints,
                controller: _animationController,
                run: _animationController.isAnimating,
                duration: _animationController.duration,
                onFinish: () {
                  _animationController.stop();
                },
              ),
              Align(
                  child: Container(
                    height: 0.5,
                    color: Colors.black54,
                    width: 140,
                  )),
              Align(
                  child: Container(
                    height: 140,
                    color: Colors.black54,
                    width: 0.5,
                  ))
            ],
          ),),
        ));
  }

  _buildActionSlider() {
    return Positioned(
        right: 0,

        child: Container(
          margin: const EdgeInsets.all(30).copyWith(
            top: 70
          ),

      height: 180,
      width: 45,
      decoration: BoxDecoration(
        color: secondaryColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              offset: const Offset(1.0, 4.0),
              spreadRadius: 2,
              blurRadius: 4.0,
            ),
          ],
        borderRadius: BorderRadius.circular(30)
      ),
          child: Column(
            children: [
              GestureDetector(
                onTap: (){
                  if (!_animationController.isAnimating) {
                    _animationController.forward(from: 0.0);
                  }
                },
                child: Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: primaryColor)
                      )
                  ),
                  child: const Icon(Icons.play_arrow, color: primaryColor,),
                ),
              ),
              InkWell(
                onTap:(){
                  if (drawingPoints.isNotEmpty && historyDrawingPoints.isNotEmpty) {
                    setState(() {
                      drawingPoints.removeLast();
                    });
                  }
                },
                child: Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: primaryColor)
                      )
                  ),
                  child: const Icon(Icons.restore, color: primaryColor,),
                ),
              ),
              GestureDetector(
                onTap: (){
                  if(widget.state.isHideActionPracticeWriting){
                    _animationController.forward(from: 0.0);
                  }

                  context.read<KanjiBloc>().add(const HideActionClick());
                },
                child: Container(
                  height: 45,
                  width: 50,
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: primaryColor)
                      )
                  ),
                  child:  Icon(
                   !widget.state.isHideActionPracticeWriting ? Icons.visibility_off : Icons.visibility, color: primaryColor,),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    drawingPoints.clear();
                  });
                },
                child: const SizedBox(
                  height: 45,
                  width: 50,

                  child: Icon(Icons.restore_from_trash, color: primaryColor,),
                ),
              )
            ],
          ),
    ));
  }
  _buildFloatAction(KanjiLoaded state) {
    final widthDevice = MediaQuery.of(context).size.width;
    final index = state.listKanjis
        .indexWhere((element) => element.id == state.kanjiCurrent.id);
    final max = state.listKanjis.length;
    return Positioned(
        bottom: 50,
        left: (widthDevice - 150) / 2,
        child: Container(
          height: 30,
          width: 150,
          decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: secondaryColor.withOpacity(0.5),
                offset: const Offset(0.0, 3.0),
                spreadRadius: 2,
                blurRadius: 4.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        final previousIndex =
                        index - 1 < 0 ? max - 1 : index - 1;
                        _animationController.forward(from: 0);
                        context.read<KanjiBloc>().add(UpdateKanjiCurrent(
                            kanji: state.listKanjis[previousIndex]));
                        drawingPoints.clear();
                      },
                      child: const Icon(
                        Icons.arrow_left_sharp,
                        color: primaryColor,
                      ))),
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 9),
                        color: primaryColor,
                      ),
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          '${index + 1}/$max',
                          textAlign: TextAlign.center,
                          style: kTitle.copyWith(
                              color: primaryColor, fontSize: 10),
                        ),
                      ),
                      Container(
                        width: 1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 9),
                        color: primaryColor,
                      ),
                    ],
                  )),
              Expanded(
                  child: GestureDetector(
                      onTap: () {
                        final nextIndex = index + 1 >= max ? 0 : index + 1;
                        _animationController.forward(from: 0);
                        context.read<KanjiBloc>().add(UpdateKanjiCurrent(
                            kanji: state.listKanjis[nextIndex]));
                        drawingPoints.clear();
                      },
                      child: const Icon(
                        Icons.arrow_right_sharp,
                        color: primaryColor,
                      ))),
            ],
          ),
        ));
  }
}

class DrawingPainter extends CustomPainter {
  final List<DrawingPoint> drawingPoints;

  DrawingPainter({required this.drawingPoints});

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawingPoint in drawingPoints) {
      final paint = Paint()
        ..color = drawingPoint.color
        ..isAntiAlias = true
        ..strokeWidth = drawingPoint.width
        ..strokeCap = StrokeCap.round;

      for (var i = 0; i < drawingPoint.offsets.length; i++) {
        var notLastOffset = i != drawingPoint.offsets.length - 1;

        if (notLastOffset) {
          final current = drawingPoint.offsets[i];
          final next = drawingPoint.offsets[i + 1];
          canvas.drawLine(current, next, paint);
        } else {
          /// we do nothing
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}