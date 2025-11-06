import 'dart:math';
import 'package:flutter/material.dart';
import '../Utils/common.dart';
import '../data/quiz_questions.dart';
import '../services/ad_manager.dart';
import '../utils/animations.dart';
import '../widgets/WorkingNativeAdWidget.dart';
import '../widgets/loading_widget.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with TickerProviderStateMixin {
  QuizSet? currentSet;
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;
  int correctAnswers = 0;
  bool showResult = false;
  bool isAnswerSelected = false;
  bool isQuizStarted = false;

  late AnimationController _questionAnimationController;
  late AnimationController _optionAnimationController;
  late AnimationController _resultAnimationController;
  late Animation<double> _questionFadeAnimation;
  late Animation<Offset> _questionSlideAnimation;
  late Animation<double> _optionScaleAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _questionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _optionAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _resultAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _questionFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _questionAnimationController,
        curve: Curves.easeOut,
      ),
    );

    _questionSlideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _questionAnimationController,
            curve: Curves.easeOut,
          ),
        );

    _optionScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _optionAnimationController,
        curve: Curves.elasticOut,
      ),
    );
  }

  @override
  void dispose() {
    _questionAnimationController.dispose();
    _optionAnimationController.dispose();
    _resultAnimationController.dispose();
    super.dispose();
  }

  void _startQuiz() {
    final random = Random();
    final sets = QuizData.allSets;
    final selectedSet = sets[random.nextInt(sets.length)];

    setState(() {
      currentSet = selectedSet;
      isQuizStarted = true;
      currentQuestionIndex = 0;
      correctAnswers = 0;
      selectedAnswerIndex = null;
      showResult = false;
      isAnswerSelected = false;
    });

    _questionAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _optionAnimationController.forward();
    });
  }

  void _selectAnswer(int index) {
    if (isAnswerSelected) return;

    setState(() {
      selectedAnswerIndex = index;
      isAnswerSelected = true;
    });

    final question = currentSet!.questions[currentQuestionIndex];
    if (index == question.correctAnswerIndex) {
      correctAnswers++;
    }

    // Show feedback and move to next question
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (currentQuestionIndex < currentSet!.questions.length - 1) {
      if(currentQuestionIndex % 3 == 0){
        if (Common.adsopen == "2") {
          Common.openUrl();
        }
        AdManager().showInterstitialAd();
      }
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        isAnswerSelected = false;
      });

      _questionAnimationController.reset();
      _optionAnimationController.reset();
      _questionAnimationController.forward();
      Future.delayed(const Duration(milliseconds: 200), () {
        _optionAnimationController.forward();
      });
    } else {
      _showResults();
    }
  }

  void _showResults() {
    setState(() {
      showResult = true;
    });
    _resultAnimationController.forward();
  }

  void _resetQuiz() {
    setState(() {
      isQuizStarted = false;
      currentSet = null;
      currentQuestionIndex = 0;
      correctAnswers = 0;
      selectedAnswerIndex = null;
      showResult = false;
      isAnswerSelected = false;
    });
    _questionAnimationController.reset();
    _optionAnimationController.reset();
    _resultAnimationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (!isQuizStarted) {
      return _buildStartScreen(colorScheme);
    }

    if (showResult) {
      return _buildResultScreen(colorScheme);
    }

    return _buildQuizScreen(colorScheme);
  }

  Widget _buildStartScreen(ColorScheme colorScheme) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D1117),
              const Color(0xFF161B22),
              const Color(0xFF21262D),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleAnimation(
                    duration: const Duration(milliseconds: 800),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Transform.rotate(
                            angle: value * 0.1,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primary.withValues(alpha: 0.3),
                                    colorScheme.secondary.withValues(
                                      alpha: 0.3,
                                    ),
                                  ],
                                ),
                                border: Border.all(
                                  color: colorScheme.primary,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.5,
                                    ),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.quiz,
                                size: 60,
                                color: colorScheme.primary,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  StaggeredAnimation(
                    index: 0,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: ShaderMask(
                              shaderCallback: (bounds) => LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary,
                                  colorScheme.secondary,
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'Movie & TV Quiz',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  StaggeredAnimation(
                    index: 1,
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - value)),
                            child: Text(
                              'Test your knowledge!',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 48),
                  StaggeredAnimation(
                    index: 2,
                    child: Column(
                      children: [
                        _buildInfoCard(
                          icon: Icons.help_outline,
                          title: '20 Questions',
                          subtitle:
                              'Answer 20 questions about movies and TV shows',
                          colorScheme: colorScheme,
                          index: 0,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.shuffle,
                          title: 'Random Set',
                          subtitle:
                              'Questions are randomly selected from 5 sets',
                          colorScheme: colorScheme,
                          index: 1,
                        ),
                        const SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.emoji_events,
                          title: 'Get Your Score',
                          subtitle: 'See how well you know movies and TV shows',
                          colorScheme: colorScheme,
                          index: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  StaggeredAnimation(
                    index: 3,
                    child: _buildStartButton(colorScheme),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colorScheme,
    required int index,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 800 + (index * 100)),
                      curve: Curves.elasticOut,
                      builder: (context, scaleValue, child) {
                        return Transform.scale(
                          scale: scaleValue,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.2),
                                  colorScheme.secondary.withValues(alpha: 0.2),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icon,
                              color: colorScheme.primary,
                              size: 24,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStartButton(ColorScheme colorScheme) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 32),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _startQuiz,
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 48,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Start Quiz',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2), // Shadow position (X, Y)
                                blurRadius: 8, // Softness of shadow
                                color: Colors.black45, // Shadow color
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          builder: (context, rotateValue, child) {
                            return Transform.rotate(
                              angle: rotateValue * 0.2,
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizScreen(ColorScheme colorScheme) {
    if (currentSet == null) {
      return const LoadingWidget();
    }

    final question = currentSet!.questions[currentQuestionIndex];
    final progress = (currentQuestionIndex + 1) / currentSet!.questions.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [const Color(0xFF0D1117), const Color(0xFF161B22)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(-20 * (1 - value), 0),
                                child: Text(
                                  'Question ${currentQuestionIndex + 1}/${currentSet!.questions.length}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(20 * (1 - value), 0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.2,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: colorScheme.primary,
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${((progress * 100).toInt())}%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: progress),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.easeOut,
                      builder: (context, animatedProgress, child) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: animatedProgress,
                            minHeight: 10,
                            backgroundColor: const Color(0xFF21262D),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              colorScheme.primary,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Question
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _questionFadeAnimation,
                        child: SlideTransition(
                          position: _questionSlideAnimation,
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeOut,
                            builder: (context, scaleValue, child) {
                              return Transform.scale(
                                scale: 0.9 + (0.1 * scaleValue),
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF161B22),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: colorScheme.primary.withValues(
                                        alpha: 0.5,
                                      ),
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: colorScheme.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      TweenAnimationBuilder<double>(
                                        tween: Tween(begin: 0.0, end: 1.0),
                                        duration: const Duration(
                                          milliseconds: 800,
                                        ),
                                        curve: Curves.elasticOut,
                                        builder: (context, iconScale, child) {
                                          return Transform.scale(
                                            scale: iconScale,
                                            child: Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                  colors: [
                                                    colorScheme.primary
                                                        .withValues(alpha: 0.3),
                                                    colorScheme.secondary
                                                        .withValues(alpha: 0.3),
                                                  ],
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.help_outline,
                                                color: colorScheme.primary,
                                                size: 28,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          question.question,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Options
                      ...List.generate(question.options.length, (index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(
                              milliseconds: 400 + (index * 100),
                            ),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(50 * (1 - value), 0),
                                  child: Transform.scale(
                                    scale: 0.8 + (0.2 * value),
                                    child: ScaleTransition(
                                      scale: _optionScaleAnimation,
                                      child: _buildOptionButton(
                                        option: question.options[index],
                                        index: index,
                                        isCorrect:
                                            index ==
                                            question.correctAnswerIndex,
                                        isSelected:
                                            selectedAnswerIndex == index,
                                        colorScheme: colorScheme,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildOptionButton({
    required String option,
    required int index,
    required bool isCorrect,
    required bool isSelected,
    required ColorScheme colorScheme,
  }) {
    Color? backgroundColor;
    Color? borderColor;
    IconData? icon;
    Color? iconColor;

    if (isAnswerSelected) {
      if (isSelected) {
        if (isCorrect) {
          backgroundColor = Colors.green.withValues(alpha: 0.2);
          borderColor = Colors.green;
          icon = Icons.check_circle;
          iconColor = Colors.green;
        } else {
          backgroundColor = Colors.red.withValues(alpha: 0.2);
          borderColor = Colors.red;
          icon = Icons.cancel;
          iconColor = Colors.red;
        }
      } else if (isCorrect) {
        backgroundColor = Colors.green.withValues(alpha: 0.2);
        borderColor = Colors.green;
        icon = Icons.check_circle;
        iconColor = Colors.green;
      } else {
        backgroundColor = Colors.grey[900];
        borderColor = Colors.grey[700]!;
      }
    } else {
      backgroundColor = isSelected
          ? colorScheme.primary.withValues(alpha: 0.2)
          : Colors.grey[900];
      borderColor = isSelected ? colorScheme.primary : Colors.grey[700]!;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _selectAnswer(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(13),
          decoration: BoxDecoration(
            color: backgroundColor ?? const Color(0xFF161B22),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: 2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: borderColor.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ]
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    String.fromCharCode(65 + index), // A, B, C, D
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: borderColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 12),
                Icon(icon, color: iconColor, size: 24),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen(ColorScheme colorScheme) {
    final percentage = (correctAnswers / currentSet!.questions.length * 100)
        .toInt();

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF0D1117),
              const Color(0xFF161B22),
              const Color(0xFF21262D),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _resultAnimationController,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.elasticOut,
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Transform.rotate(
                          angle: value * 0.1,
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorScheme.primary.withValues(alpha: 0.3),
                                  colorScheme.secondary.withValues(alpha: 0.3),
                                ],
                              ),
                              border: Border.all(
                                color: colorScheme.primary,
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.5,
                                  ),
                                  blurRadius: 30,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Center(
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    colorScheme.primary,
                                    colorScheme.secondary,
                                  ],
                                ).createShader(bounds),
                                child: Text(
                                  '$percentage%',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _resultAnimationController,
                  child: Column(
                    children: [
                      Text(
                        _getResultMessage(percentage),
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You got $correctAnswers out of ${currentSet!.questions.length} questions correct!',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                FadeTransition(
                  opacity: _resultAnimationController,
                  child: _buildResultCard(
                    icon: Icons.emoji_events,
                    title: 'Score',
                    value: '$correctAnswers/${currentSet!.questions.length}',
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(height: 16),
                FadeTransition(
                  opacity: _resultAnimationController,
                  child: _buildResultCard(
                    icon: Icons.percent,
                    title: 'Percentage',
                    value: '$percentage%',
                    colorScheme: colorScheme,
                  ),
                ),
                const SizedBox(height: 48),
                FadeTransition(
                  opacity: _resultAnimationController,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildActionButton(
                        label: 'Play Again',
                        icon: Icons.refresh,
                        onPressed: _startQuiz,
                        colorScheme: colorScheme,
                        isPrimary: true,
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        label: 'Home',
                        icon: Icons.home,
                        onPressed: _resetQuiz,
                        colorScheme: colorScheme,
                        isPrimary: false,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const WorkingNativeAdWidget(),
    );
  }

  Widget _buildResultCard({
    required IconData icon,
    required String title,
    required String value,
    required ColorScheme colorScheme,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      builder: (context, animationValue, child) {
        return Opacity(
          opacity: animationValue,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - animationValue)),
            child: Transform.scale(
              scale: 0.9 + (0.1 * animationValue),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            colorScheme.primary.withValues(alpha: 0.2),
                            colorScheme.secondary.withValues(alpha: 0.2),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required ColorScheme colorScheme,
    required bool isPrimary,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          decoration: BoxDecoration(
            color: isPrimary
                ? Colors.white
                : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: isPrimary
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 2,
                  ),
            boxShadow: isPrimary
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isPrimary ? Colors.black87 : Colors.white,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isPrimary ? Colors.black87 : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getResultMessage(int percentage) {
    if (percentage >= 90) {
      return 'Outstanding! 🎉';
    } else if (percentage >= 80) {
      return 'Excellent! 🌟';
    } else if (percentage >= 70) {
      return 'Great Job! 👏';
    } else if (percentage >= 60) {
      return 'Good Work! 👍';
    } else if (percentage >= 50) {
      return 'Not Bad! 💪';
    } else if (percentage >= 40) {
      return 'Keep Trying! 📚';
    } else {
      return 'Practice More! 🎯';
    }
  }
}
