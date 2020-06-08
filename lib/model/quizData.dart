import 'dart:math';
import 'package:mult_tables/model/enumLevel.dart';

//TODO:Save selections and results
class Quiz {
  bool allow12and21;
  int countOfQuestions;
  Level levelOfQuiz;

  var _result; //= getListForQuiz(5, 7, 0, true);
  var _firstListOfNumbers, _secondListOfNumbers;

  List<Question> questions = [];

  List<List<int>> arrayOfPossibleResults = [];

  int totalScore=0;

  Quiz(this.countOfQuestions, this.levelOfQuiz, this.allow12and21) {
    _result = _getQuestionsForQuiz(countOfQuestions, levelOfQuiz, allow12and21);

    _firstListOfNumbers = _result[0];
    _secondListOfNumbers = _result[1];

    for (int count = 0; count < countOfQuestions; count++) {
      questions
          .add(Question(_firstListOfNumbers[count], _secondListOfNumbers[count]));
    }

    

    // for (int i = 0; i < countOfQuestions; i++) {
    //   arrayOfPossibleResults.add(
    //       _getPossibleResults(firstListOfNumbers[i], secondListOfNumbers[i]));
    // }
  }

// @param const countOfQuestions = 5; This is the length of the List returned
// const levelOfQuiz = enum.index *10 + 10; //random generator upto this level (not inclusive). Max number in the quiz
// const startLevel = 0; //lowest digit in the quiz, Min number in the quiz
// const allow12and21 = true;
  List<List> _getQuestionsForQuiz(
      int countOfQuestions, Level levelOfQuiz, bool allow12and21) {
    var l1 = <int>[];
    var l2 = <int>[];

    var _resultList = <String>[];

    var _num1, _num2, _comb;
    int _effort = 0;

    int generateNumsFrom =
        levelOfQuiz == Level.Easy ? 0 : levelOfQuiz == Level.Medium ? 5 : 8;
    int generateNumsUpto =
        levelOfQuiz == Level.Easy ? 5 : levelOfQuiz == Level.Medium ? 12 : 15;

    if ((generateNumsFrom + 3) > generateNumsUpto) {
      generateNumsUpto = generateNumsUpto + 3;
    }
    print(
        'Random numbers are being generated from $generateNumsFrom to $generateNumsUpto');

    while (l1.length < countOfQuestions && _effort < 100) {
      _effort++;
      _num1 = _getRandomNumberInRange(generateNumsFrom, generateNumsUpto);

      _num2 = _getRandomNumberInRange(generateNumsFrom, generateNumsUpto);

      if (allow12and21) {
        _comb = '$_num1$_num2';
      } else {
        if (_num1 > _num2) {
          _comb = '$_num2$_num1';
        }
      }
      if (!_resultList.contains(_comb)) {
        _resultList.add(_comb);
        l1.add(_num1);
        l2.add(_num2);
      } else {
        print('Skipping $_comb');
      }
      print('Effort spent is $_effort');
    }

    print('question list is: $l1 and $l2');
    return [l1, l2];
  }

  int _getRandomNumberInRange(int generateNumsFrom, int generateNumsUpto) {
    final _random = Random();
    int range = generateNumsUpto - generateNumsFrom;
    int num = _random.nextInt(range) + generateNumsFrom;
    return num;
  }
}

class Question {
  int num1, num2;
  String operation;
  int selected = -1;
  DateTime time;
  List<int> answers;

  Question(this.num1, this.num2, {this.operation = '*'});

  Question.add(int num1, int num2) : this(num1, num2, operation: '+');

  int get rightAns => num1 * num2;

  List<int> getAllPossibleAnswers(){
      if(answers == null){
        answers = _getPossibleResults(num1, num2);
      }
      return answers;   
  }

  List<int> _getPossibleResults(final int firstNo, final int secondNo) {
    List<int> results = [];
    List<int> resultsUpdated = [];
    final int answer = firstNo * secondNo;
    const int listLength = 4;

    results = List.generate(
        listLength,
        (index) =>
            firstNo * secondNo + Random().nextInt(secondNo + listLength));

    //make the answers more difficult by ensuring the last digit is the same as the answer
    if (answer > 9) {
      int modified;
      String ans = answer.toString().substring(answer.toString().length - 1);
      results.forEach((element) {
        modified = element;
        if (element > 9) {
          modified = int.parse(
              element.toString().substring(0, element.toString().length - 1) +
                  ans);
        }
        resultsUpdated.add(modified);
      });

      if (results.length == resultsUpdated.length) {
        results = resultsUpdated;
      }
    }

    //ensure list has unique numbers - no repeats
    //remove duplicate
    List<int> uniqueResults = [
      ...{...results}
    ];

    if (results.length != uniqueResults.length) {
      int noOfDuplicates = results.length - uniqueResults.length;
      int value = Random().nextInt(100);
      for (int i = 0; i < noOfDuplicates; i++) {
        if (!uniqueResults.contains(value)) {
          uniqueResults.add(value);
        } else {
          var nextInt = Random().nextInt(1000);
          uniqueResults.add(value + nextInt);
        }
      }
    }

    List<int> right = [answer];
    if (!uniqueResults.contains(answer)) {
      int index = Random().nextInt(4);
      uniqueResults.replaceRange(index, index, right);
    }
    
    uniqueResults.shuffle();

    return uniqueResults;
  }
}
