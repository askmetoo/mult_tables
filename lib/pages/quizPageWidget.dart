import 'dart:async';

import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mult_tables/model/enumLevel.dart';
import 'package:mult_tables/model/quizData.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    AwesomeDialog(
      context: context,
      headerAnimationLoop: false,
      dialogType: DialogType.INFO,
      animType: AnimType.SCALE,
      title: 'Ready for Quiz?',
      desc:
          'You have selected the ${level == Level.Easy ? 'Easy' : level == Level.Medium ? 'Medium' : 'Difficult'} level. There will be ${_QuizQuestionsWidgetState.countOfQuestions} questions in the quiz and you will have ${_QuizQuestionsWidgetState._countDownTime} seconds for each question. \n All the best!',
      btnOkText: 'Go',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizQuestionsWidget(level)),
        );
      },
    )..show();
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
  static const int _countDownTime = 10;

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

    int timeL = 0;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
            margin: const EdgeInsets.all(40.0),
            alignment: Alignment.topCenter,
            child: Column(children: <Widget>[
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
                    color:
                        selected == results[0] ? Colors.teal : Colors.blueGrey,
                    minWidth: 120.0,
                  ),
                  MaterialButton(
                    child: new Text('${results[1]}'),
                    onPressed: () {
                      choiceSelected(results[1]);
                    },
                    color:
                        selected == results[1] ? Colors.teal : Colors.blueGrey,
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
                    color:
                        selected == results[2] ? Colors.teal : Colors.blueGrey,
                    minWidth: 120.0,
                  ),
                  MaterialButton(
                    child: new Text('${results[3]}'),
                    onPressed: () {
                      choiceSelected(results[3]);
                    },
                    color:
                        selected == results[3] ? Colors.teal : Colors.blueGrey,
                    minWidth: 120.0,
                  )
                ],
              ),
              new Padding(padding: EdgeInsets.all(20.0)),
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
                    splashColor: Colors.transparent,
                    onTap: (startTimer, btnState) {
                      if (questionNo != quiz.countOfQuestions - 1) {
                        startTimer(10);
                      }
                      updateQuestion(timeL);
                      print('In onTap for 1 , time left is $timeL');
                    },
                    initialTimer: _countDownTime,

                    child: Text(
                      selected == -1 ? 'Next' : 'Submit',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w700),
                    ),
                    loader: (timeLeft) {
                      timeL = timeLeft;
                      return Text(
                        "Submit | $timeLeft",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      );
                    },
                    borderRadius: 5.0,
                    //color: Colors.transparent,
                    elevation: 0,
                  ),
                ],
              )
            ])),
      ),
    );
  }

  updateQuestion(int timeInSeconds) {
    print('In udpateQuestion, $selected');
    quiz.questions[questionNo].selected = selected;
    quiz.questions[questionNo].time = _countDownTime - timeInSeconds;
    setState(() {
      if (questionNo == quiz.countOfQuestions - 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => ResultsPage(quiz: quiz)));
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

class ResultsPage extends StatelessWidget {
  final Quiz quiz;
  ResultsPage({Key key, @required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _saveSettings(quiz);
    return new WillPopScope(
      child: Container(
        padding: EdgeInsets.all(40),
        child: Center(
          child: Scaffold(
            body: Column(
              children: [
                Text(
                    'Results : ${quiz?.totalScore} right from ${quiz?.countOfQuestions} questions, completed in ${quiz?.totalTime} seconds'),
                //Navigate to QuizPageWidget
                RaisedButton(
                    child: Text('New Quiz'),
                    onPressed: () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizPageWidget()),
                          )
                        }),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }

//TODO: fix initiation issues
  _saveSettings(Quiz quiz) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    int totalTimesPlayed = (prefs.getInt('totalTimesPlayed') ?? 0) + 1;
    String lastPlayed =
        (prefs.getString('lastPlayed') ?? DateTime.now().toString());
    int lastScore = (prefs.getInt('lastScore') ?? quiz.totalScore);
    String lastLevel =
        (prefs.getString('lastLevel') ?? quiz.levelOfQuiz.toString());

    int allTimeBestScoreAtEasy, allTimeBestScoreAtMed, allTimeBestScoreAtDiff;
    int totalScore = quiz.totalScore;
    bool newAllTimeScoreSet = false;

    if (quiz.levelOfQuiz == Level.Easy) {
      allTimeBestScoreAtEasy = (prefs.getInt('allTimeBestScoreAtEasy') ?? 0);
      if (allTimeBestScoreAtEasy < totalScore) {
        allTimeBestScoreAtEasy = totalScore;
        newAllTimeScoreSet= true;
        await prefs.setInt('allTimeBestScoreAtEasy', allTimeBestScoreAtEasy);
        await prefs.setString('newAllTimeScoreSetAtEasy', DateTime.now().toString());
      }
    } else if (quiz.levelOfQuiz == Level.Medium) {
      allTimeBestScoreAtMed = (prefs.getInt('allTimeBestScoreAtMed') ?? 0);
      if (allTimeBestScoreAtMed < totalScore) {
        allTimeBestScoreAtMed = totalScore;
        newAllTimeScoreSet= true;
        await prefs.setInt('allTimeBestScoreAtMed', allTimeBestScoreAtMed);
        await prefs.setString('newAllTimeScoreSetAtMed', DateTime.now().toString());
      }
    } else if (quiz.levelOfQuiz == Level.Difficult) {
      allTimeBestScoreAtDiff = (prefs.getInt('allTimeBestScoreAtDiff') ?? 0);
      if (allTimeBestScoreAtDiff < totalScore) {
        allTimeBestScoreAtDiff = totalScore;
        newAllTimeScoreSet= true;
        await prefs.setInt('allTimeBestScoreAtDiff', allTimeBestScoreAtDiff);
        await prefs.setString('newAllTimeScoreSetAtDiff', DateTime.now().toString());
      }
    }


    print('Quiz attempted $totalTimesPlayed times. Quiz was last played on $lastPlayed at $lastLevel and the score was $lastScore. \n The Top score at Level Easy was $allTimeBestScoreAtEasy, \n The Top score at Level Medium was $allTimeBestScoreAtMed, \n The Top score at Level Difficult was $allTimeBestScoreAtDiff. \n This attempt set a new Top score = $newAllTimeScoreSet');

    await prefs.setInt('totalTimesPlayed', totalTimesPlayed);
    await prefs.setString('lastPlayed', lastPlayed);
    await prefs.setInt('lastScore', lastScore);
    await prefs.setString('lastLevel', lastLevel);
    
  }
}
