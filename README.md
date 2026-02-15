# ImageFlow AI

An intelligent image processing application built with Flutter that automatically detects content type (faces or documents) and applies the appropriate processing pipeline using Google ML Kit.

## Features

### Core
- **Animated Splash Screen** — Owl logo with radial glow, gradient app name, and tagline — fade-in + scale entrance animation with auto-navigation to home
- **Smart Content Detection** — Automatically classifies images as face or document and routes to the correct processing flow
- **Face Processing** — Detects faces via ML Kit, crops face regions, applies B&W filter, and composites back onto the original image with a before/after slider comparison
- **Document Scanning** — Sobel edge detection, perspective transformation, contrast enhancement, and PDF export
- **Processing History** — All results are persisted to SQLite with thumbnails, type badges, dates, and file sizes
- **History Detail** — Full-screen result view with metadata, share, open in external viewer, and delete

### Bonus
- **OCR Text Extraction** — Extracts text from scanned documents, displays it alongside the image, and supports copy-to-clipboard and share
- **Live Camera Text Recognition** — Real-time OCR using the device camera with pause/resume controls and save-to-history

## Documentation

The entire codebase is fully documented with **DartDoc comments**. Hovering over any class, method, or constructor in your IDE will display a complete description of its purpose, behavior, and the parameters it expects. This applies to services, repositories, use cases, controllers, widgets, and models throughout the project.






![image_processing_dart_doc_gif](https://github.com/user-attachments/assets/f0d30d7d-d414-4b5a-9155-85b49734da19)


## Architecture

Clean Architecture with **GetX** for state management, routing, and dependency injection.

```
lib/
├── config/
│   ├── routes/          # Route constants & GetPage mappings
│   └── theming/         # Dark theme with owl-themed palette
├── core/
│   ├── errors/          # Failure hierarchy (DatabaseFailure, ProcessingFailure)
│   ├── services/
│   │   ├── database/    # SQLite via sqflite
│   │   ├── image_processing/  # Sobel edge detection, perspective transform, face composite
│   │   ├── ml_services/       # Google ML Kit (face detection + text recognition)
│   │   ├── image_picker/      # Camera/gallery with cropping
│   │   └── pdf/               # A4 PDF generation
│   └── shared/widgets/
└── features/
    ├── splash/           # Animated launch screen with logo & tagline
    ├── home/             # History list, FAB for new capture
    ├── processing/       # Content classification & processing pipeline
    ├── face_detection/   # Face result with before/after slider
    ├── text_recognition/ # OCR result, PDF export, live scan
    └── history_detail/   # Full-screen detail with metadata & actions
```

Each feature follows the structure:
```
feature/
├── data/
│   ├── models/          # toMap()/fromMap() data models
│   └── repositories/    # Repository implementations
├── domain/
│   ├── entities/        # Domain entities
│   ├── repositories/    # Abstract interfaces (prefixed with I)
│   └── use_cases/       # Single-responsibility use cases
└── presentation/
    ├── bindings/        # GetX lazy-loaded DI per route
    ├── controllers/     # GetxController with .obs reactive state
    └── views/
        ├── screens/
        └── widgets/
```

## Processing Flows

### Face Flow
1. Detect faces using ML Kit Face Detection
2. Extract bounding rectangles for each face
3. Crop face regions from the original image
4. Apply grayscale filter to cropped faces
5. Composite filtered faces back onto the original
6. Display before/after comparison via interactive slider
7. Save result and metadata to history

### Document Flow
1. Detect text regions using ML Kit Text Recognition
2. Run Sobel edge detection to find document boundaries
3. Locate document corners via quadrant-based scanning
4. Apply perspective transformation to correct angle
5. Enhance contrast (1.2x boost + grayscale)
6. Generate A4 PDF from the corrected image
7. Save PDF and metadata to history

## Setup & Run

### Prerequisites
- Flutter SDK `>=3.10.8`
- Android Studio or Xcode
- A physical device or emulator (ML Kit requires camera access for live features)

### Installation

```bash
# Clone the repository
git clone <https://github.com/moghoneim-code/flutter_image_processing_analysis.git>
cd flutter_image_processing_analysis

# Install dependencies
flutter pub get

# Run on a connected device
flutter run
```

### Build

```bash
flutter build apk      # Android
flutter build ios       # iOS
```

### Other Commands

```bash
flutter analyze         # Static analysis
flutter test            # Run tests
```

## Dependencies

| Category | Package | Purpose |
|----------|---------|---------|
| State Management | `get` | Reactive state, routing, DI |
| ML / Vision | `google_mlkit_face_detection` | Face detection |
| ML / Vision | `google_mlkit_text_recognition` | OCR / text recognition |
| Image Processing | `image_cropper` | Image cropping UI |
| Image Processing | `image_compare_slider` | Before/after slider comparison |
| Camera | `camera` | Live camera feed for real-time OCR |
| Storage | `sqflite` | SQLite local database |
| File Handling | `path_provider` | App directory paths |
| File Handling | `image_picker` | Camera/gallery image selection |
| PDF | `pdf` | PDF document generation |
| PDF | `open_filex` | Open files in external viewer |
| Sharing | `share_plus` | Platform share sheet |
| UI | `shimmer` | Loading skeleton animations |

## Screens

| Route | Screen | Description |
|-------|--------|-------------|
| `/splash` | Splash | Animated launch screen with logo fade-in/scale and auto-navigation to home |
| `/home` | Home | Processing history list with swipe-to-delete, FAB for new capture |
| `/processing` | Processing | Animated progress indicator while ML Kit classifies and processes |
| `/face-detection` | Face Result | Before/after slider comparing original vs B&W face composite |
| `/text-recognition` | Text Result | Extracted text display, copy/share actions, PDF export button |
| `/live-text-recognition` | Live Scan | Real-time camera OCR with pause/resume |
| `/history-detail` | History Detail | Full-screen result with metadata (type, date, size), open/share/delete |
