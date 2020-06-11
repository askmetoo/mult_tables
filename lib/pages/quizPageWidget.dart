import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mult_tables/model/enumLevel.dart';
import 'package:mult_tables/model/quizData.dart';

class QuizPageWidget extends StatelessWidget {
  const QuizPageWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const levelEasy = 'Easy';
    const levelMedium = 'Medium';
    const levelDiff = 'Difficult';

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                navigateToQuiz(context, Level.Easy);
              },
              child: Text('$levelEasy (0 to 5)'),
            ),
            RaisedButton(
              onPressed: () {
                navigateToQuiz(context, Level.Medium);
              },
              child: Text('$levelMedium (5 to 12)'),
            ),
            RaisedButton(
              onPressed: () {
                navigateToQuiz(context, Level.Difficult);
              },
              child: Text('$levelDiff (8 to 15)'),
            ),
          ],
        )),
      ),
    );
  }

  void navigateToQuiz(BuildContext context, Level level) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuizQuestionsWidget(level)),
    );
  }
}

class QuizQuestionsWidget extends StatefulWidget {
  final Level quizLevel;

  QuizQuestionsWidget(this.quizLevel);

  @override
  _QuizQuestionsWidgetState createState() => _QuizQuestionsWidgetState();
}

class _QuizQuestionsWidgetState extends State<QuizQuestionsWidget> {
  static const countOfQuestions = 8;
  Level level; // = widget.quizLevel;
  Quiz quiz = null; //Quiz(countOfQuestions, 17, 0, true);
  var question = '';
  int questionNo = 0;
  int answer = 0;
  int selected = -1;
  double _progressValue = 0;

  @override
  void initState() {
    super.initState();
    this.getQuizData();
  }

  void getQuizData() {
    level = widget.quizLevel;
    quiz = Quiz(countOfQuestions, level, true);
    setState(() {
      questionNo = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    String levelDesc = describeEnum(level);
    question = 'Question ${questionNo + 1} of $countOfQuestions :';

    var q1 =
        '${quiz.questions[questionNo].num1} * ${quiz.questions[questionNo].num2} = ';

    List<int> results = quiz.questions[questionNo].getAllPossibleAnswers();
    _progressValue = (questionNo) / countOfQuestions;
    answer = quiz.questions[questionNo].rightAns;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            margin: const EdgeInsets.all(40.0),
            alignment: Alignment.topCenter,
            child: Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(20.0)),
                new Text('Level : $levelDesc'),
                new Padding(padding: EdgeInsets.all(6.0)),
                new Text('Score : ${quiz.totalScore ?? 0}'),
                new Padding(padding: EdgeInsets.all(6.0)),
                new Text(
                  '$question',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                  ),
                ),
                new Padding(padding: EdgeInsets.all(6.0)),
                new Text(
                  '$q1',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.deepOrange,
                  ),
                ),
                new Padding(padding: EdgeInsets.all(8.0)),
                LinearProgressIndicator(
                  value: _progressValue,
                ),
                new Padding(padding: EdgeInsets.all(20.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                      child: new Text('${results[0]}'),
                      onPressed: () {
                        choiceSelected(results[0]);
                      },
                      color: selected == results[0]
                          ? Colors.teal
                          : Colors.blueGrey,
                      minWidth: 120.0,
                    ),
                    MaterialButton(
                      child: new Text('${results[1]}'),
                      onPressed: () {
                        choiceSelected(results[1]);
                      },
                      color: selected == results[1]
                          ? Colors.teal
                          : Colors.blueGrey,
                      minWidth: 120.0,
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    MaterialButton(
                      child: new Text('${results[2]}'),
                      onPressed: () {
                        choiceSelected(results[2]);
                      },
                      color: selected == results[2]
                          ? Colors.teal
                          : Colors.blueGrey,
                      minWidth: 120.0,
                    ),
                    MaterialButton(
                      child: new Text('${results[3]}'),
                      onPressed: () {
                        choiceSelected(results[3]);
                      },
                      color: selected == results[3]
                          ? Colors.teal
                          : Colors.blueGrey,
                      minWidth: 120.0,
                    )
                  ],
                ),
                new Padding(padding: EdgeInsets.all(20.0)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // RaisedButton(
                    //   child: const Text('Submit',
                    //       style: TextStyle(fontSize: 20)),
                    //   onPressed: () {
                    //     selected == -1 ? 0 : updateQuestion();
                    //   },
                    //   color: selected == -1 ? Colors.grey : Colors.lime,
                    // ),
                    ArgonTimerButton(
                      height: 50,
                      width: MediaQuery.of(context).size.width * 0.45,
                      minWidth: MediaQuery.of(context).size.width * 0.30,
                      highlightColor: Colors.transparent,
                      highlightElevation: 0,
                      roundLoadingShape: false,
                      splashColor: Colors.transparent,
                      onTap: (startTimer, btnState) {
                        if (btnState == ButtonState.Idle) {
                          startTimer(10);
                          updateQuestion();
                        }
                      },
                      initialTimer: 10,

                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      loader: ( timeLeft) {
                        return countDownButton(timeLeft);
                      },
                      borderRadius: 5.0,
                      //color: Colors.transparent,
                      elevation: 0,
                    ),
                  ],
                ),
                new Padding(padding: EdgeInsets.all(2.0)),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ArgonTimerButton(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.45,
                        minWidth: MediaQuery.of(context).size.width * 0.30,
                        highlightColor: Colors.transparent,
                        highlightElevation: 0,
                        roundLoadingShape: false,
                        onTap: (startTimer, btnState) {
                          if (btnState == ButtonState.Idle) {
                            startTimer(5);
                          }
                        },
                        //initialTimer: 10,
                        child: Text(
                          "Resend OTP",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w700),
                        ),
                        loader: (timeLeft) {
                          return Text(
                            "Wait | $timeLeft",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          );
                        },
                        borderRadius: 5.0,
                        color: Colors.transparent,
                        elevation: 0,
                        borderSide: BorderSide(color: Colors.black, width: 1.5),
                      ),
                    ])
              ],
            )),
      ),
    );
  }

  Widget countDownButton(int timeLeft) {
    Widget wdgt = Text('Done!');
    if (timeLeft > 0) {
      print('Time left: $timeLeft');
      wdgt = RaisedButton(
        child: Text(
          "Submit($timeLeft)",
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontWeight: FontWeight.w700),
        ),
        onPressed: () {

          selected == -1 ? 0 : updateQuestion();
        },
      );
    } else {
      print('Time left is 0, $timeLeft');
      //TODO: Disable selecting or changing answers
    }
    return wdgt;
  }

  updateQuestion() {
    //TODO: Save time taken to answer
    print('In udpateQuestion, $selected');
    quiz.questions[questionNo].selected = selected;
    setState(() {
      if (answer == selected) {
        quiz.totalScore++;
      }
      if (questionNo == quiz.countOfQuestions - 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => Summary(finalScore: quiz.totalScore)));
      } else {
        questionNo++;
        selected = -1;
      }
    });
  }

  void choiceSelected(int selection) {
    print('Choice selected: $selection');
    setState(() {
      selected = selection;
    });
  }
}

class Summary extends StatelessWidget {
  final int finalScore;
  Summary({Key key, @required this.finalScore}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Scaffold(
            body: Text('Results : $finalScore'),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
