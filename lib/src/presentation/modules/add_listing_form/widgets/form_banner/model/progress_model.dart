class Progress {
  int? currentStep;
  int? totalSteps;

  Progress({required this.currentStep, required this.totalSteps});

  double get progressPercentage => (currentStep ?? 1) / (totalSteps ?? 1);
}
