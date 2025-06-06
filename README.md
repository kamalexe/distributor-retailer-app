# Distributor/Retailer Management App

A Flutter application for managing distributors and retailers with features for listing, searching, adding, and updating their details.

## Features

- **Dual Listing System**
  - Separate tabs for Distributors and Retailers
  - Paginated list view with infinite scrolling
  - Pull-to-refresh functionality

- **Search Functionality**
  - Real-time search by name
  - Cross-platform search implementation
  - Instant results update

- **Data Management**
  - Add new distributors/retailers
  - Update existing distributor/retailer details
  - Image upload support
  - Form validation

- **User Interface**
  - Modern Material Design
  - Responsive layout
  - Loading indicators
  - Error handling with retry options
  - Bottom navigation bar

## Technical Details

### API Integration
- Base URL: `http://128.199.98.121/admin/Api`
- Endpoints:
  - GET `/distributors` - Fetch distributors/retailers list
  - POST `/add-distributor` - Add new distributor/retailer
  - POST `/update-distributor` - Update existing distributor/retailer

### State Management
- Uses Flutter's built-in StatefulWidget for state management
- Implements pagination for efficient data loading
- Handles loading states and error scenarios

### Security
- Network security configuration for HTTP traffic
- Authorization headers for API requests
- Secure data handling

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone https://github.com/yourusername/distributor_retailer_app.git
```

2. Navigate to project directory:
```bash
cd distributor_retailer_app
```

3. Install dependencies:
```bash
flutter pub get
```

4. Run the app:
```bash
flutter run
```

### Building for Production

For Android:
```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── api/
│   ├── api_service.dart
│   └── api_constants.dart
├── models/
│   └── distributor.dart
├── screens/
│   ├── listing_screen.dart
│   └── distributor_retailer_form.dart
├── widgets/
│   └── app_widget.dart
└── main.dart
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- All contributors who have helped in the development

## UI
![WhatsApp-Image-2025-06-06-at-113](https://github.com/user-attachments/assets/d699d965-0c70-469e-834d-e766f39dc903)



