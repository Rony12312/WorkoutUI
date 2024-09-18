import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WorkoutDetailsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WorkoutDetailsScreen extends StatefulWidget {
  const WorkoutDetailsScreen({super.key});

  @override
  _WorkoutDetailsScreenState createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen> {
  late VideoPlayerController _controller;
  bool isPlaying = false;

  List<Exercise> exercises = [
    Exercise(
        name: "Standard Push-Ups",
        proTip:
            "Focus on sitting \"back\" and down, keep your knees \"pushed\" outwards",
        sets: [
          ExerciseSet(reps: 15, weight: 15.5, isCompleted: false),
          ExerciseSet(reps: 15, weight: 15.5, isCompleted: false),
          ExerciseSet(reps: 15, weight: 15.5, isCompleted: false),
        ]),
    Exercise(
        name: "Chest Dips",
        proTip: "Keep your knees \"pushed\" outwards",
        sets: [
          ExerciseSet(reps: 12, weight: 10.0, isCompleted: false),
          ExerciseSet(reps: 12, weight: 10.0, isCompleted: false),
          ExerciseSet(reps: 12, weight: 10.0, isCompleted: false),
        ]),
    Exercise(
        name: "Incline Bench Press",
        proTip: "Maintain proper posture",
        sets: [
          ExerciseSet(reps: 10, weight: 20.0, isCompleted: false),
          ExerciseSet(reps: 10, weight: 20.0, isCompleted: false),
          ExerciseSet(reps: 10, weight: 20.0, isCompleted: false),
        ]),
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('videos/pushup.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get completedExercisesCount {
    return exercises.where((exercise) => exercise.isCompleted).length;
  }

  bool isExerciseCompleted(Exercise exercise) {
    return exercise.sets.every((set) => set.isCompleted);
  }

  void _togglePlayback() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        isPlaying = false;
      } else {
        _controller.play();
        isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // Dark theme background
      appBar: AppBar(
        backgroundColor: Colors.grey[900], // Dark theme background
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Player
            Container(
              height: 200,
              child: _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : const Center(child: CircularProgressIndicator()),
            ),
            const SizedBox(height: 10),

            // Play/Pause Button
            Center(
              child: ElevatedButton(
                onPressed: _togglePlayback,
                child: Text(
                  isPlaying ? 'Pause Video' : 'Play Video',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Workout Title and Pro Tip
            const Text(
              'Chest Workout',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              'Pro Tip: Focus on sitting "back" and down, keep your knees "pushed" outwards',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // Completed Exercises Overview
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Exercises ${completedExercisesCount}/${exercises.length}',
                  style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                Checkbox(
                  value: completedExercisesCount == exercises.length,
                  onChanged: (value) {},
                  checkColor: Colors.orange,
                  activeColor: Colors.transparent,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of Exercises
            ListView.builder(
              shrinkWrap: true,
              // Ensure it takes only the needed height
              physics: const NeverScrollableScrollPhysics(),
              // Prevent internal scrolling
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Title, Pro Tip, and Checkbox for completion
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                exercises[index].name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Pro Tip: ${exercises[index].proTip}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                                overflow: TextOverflow
                                    .ellipsis, // Handle overflow for long text
                              ),
                            ],
                          ),
                        ),
                        Checkbox(
                          value: isExerciseCompleted(exercises[index]),
                          onChanged: (value) {
                            setState(() {
                              for (var set in exercises[index].sets) {
                                set.isCompleted = value ?? false;
                              }
                              exercises[index].isCompleted =
                                  isExerciseCompleted(exercises[index]);
                            });
                          },
                          checkColor: Colors.orange,
                          activeColor: Colors.transparent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Exercise Card with Sets, Reps, Weights
                    ExerciseCard(
                      exercise: exercises[index],
                      onSetCompletionChanged: (setIndex, isChecked) {
                        setState(() {
                          exercises[index].sets[setIndex].isCompleted =
                              isChecked;
                          exercises[index].isCompleted =
                              isExerciseCompleted(exercises[index]);
                        });
                      },
                      onRepsChanged: (setIndex, reps) {
                        setState(() {
                          exercises[index].sets[setIndex].reps = reps;
                        });
                      },
                      onWeightChanged: (setIndex, weight) {
                        setState(() {
                          exercises[index].sets[setIndex].weight = weight;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),

            // Next Workout Button
            ElevatedButton(
              onPressed: () {
                // Handle "Next Workout" action
              },
              child: const Text(
                'Next Workout',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Stateful widget for each exercise card
class ExerciseCard extends StatefulWidget {
  final Exercise exercise;
  final Function(int, bool) onSetCompletionChanged;
  final Function(int, int) onRepsChanged;
  final Function(int, double) onWeightChanged;

  ExerciseCard({
    required this.exercise,
    required this.onSetCompletionChanged,
    required this.onRepsChanged,
    required this.onWeightChanged,
  });

  @override
  _ExerciseCardState createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sets, Reps, and Weights
            Column(
              children: widget.exercise.sets.asMap().entries.map((entry) {
                int setIndex = entry.key;
                ExerciseSet set = entry.value;
                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Set ${setIndex + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            initialValue: set.reps.toString(),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Reps',
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                              ),
                            ),
                            onChanged: (value) {
                              widget.onRepsChanged(
                                  setIndex, int.tryParse(value) ?? set.reps);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextFormField(
                            initialValue: set.weight.toString(),
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'Weight',
                              hintStyle: const TextStyle(color: Colors.grey),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.orange),
                                borderRadius: BorderRadius.circular(
                                    20.0), // Rounded border
                              ),
                            ),
                            onChanged: (value) {
                              widget.onWeightChanged(setIndex,
                                  double.tryParse(value) ?? set.weight);
                            },
                          ),
                        ),
                        Checkbox(
                          value: set.isCompleted,
                          onChanged: (value) {
                            widget.onSetCompletionChanged(
                                setIndex, value ?? false);
                          },
                          checkColor: Colors.orange,
                          activeColor: Colors.transparent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class Exercise {
  final String name;
  final String proTip;
  final List<ExerciseSet> sets;
  bool isCompleted;

  Exercise({
    required this.name,
    required this.proTip,
    required this.sets,
    this.isCompleted = false,
  });
}

class ExerciseSet {
  int reps;
  double weight;
  bool isCompleted;

  ExerciseSet({
    required this.reps,
    required this.weight,
    this.isCompleted = false,
  });
}
