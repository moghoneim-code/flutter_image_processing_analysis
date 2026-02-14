enum ProcessingStep {
  analyzing("Analyzing image content..."),
  detecting("Detecting edges and faces..."),
  optimizing("Enhancing image quality..."),
  routing("Routing to final flow...");
  final String message;
  const ProcessingStep(this.message);
}