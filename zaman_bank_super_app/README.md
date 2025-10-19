# Zaman Bank Super App

A Flutter mobile banking application for Zaman Bank, designed with Islamic banking principles in mind.

## Features

- **Splash Screen**: Welcome screen with personalized greeting
- **Home Screen**: Main dashboard with account overview, promotional cards, and quick actions
- **Transfer Screen**: Money transfer functionality (placeholder)
- **Chat Screen**: Bank customer support chat (placeholder)
- **Bottom Navigation**: Easy navigation between main sections

## Screenshots

The app includes:
- Beautiful gradient splash screen with Islamic bank branding
- Modern home screen with cards for accounts, financing, and savings
- Clean UI following Islamic banking principles
- Responsive design for mobile devices

## Getting Started

### Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd zaman_bank_super_app
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── constants/
│   └── app_constants.dart    # App colors and text styles
├── screens/
│   ├── splash_screen.dart    # Welcome screen
│   ├── home_screen.dart      # Main dashboard
│   ├── transfer_screen.dart   # Transfer functionality
│   └── chat_screen.dart      # Customer support chat
├── widgets/
│   ├── promo_card.dart       # Promotional cards
│   ├── account_card.dart     # Account information card
│   ├── action_button.dart    # Quick action buttons
│   ├── finance_card.dart     # Financing options card
│   └── bottom_navigation.dart # Bottom navigation bar
└── main.dart                 # App entry point
```

## Dependencies

- `flutter`: Flutter SDK
- `google_fonts`: Custom fonts
- `cupertino_icons`: iOS-style icons

## Design Features

- **Islamic Banking Theme**: Green color scheme representing growth and prosperity
- **Modern UI**: Clean, card-based design with subtle shadows
- **Responsive Layout**: Adapts to different screen sizes
- **Smooth Animations**: Fade transitions and smooth navigation

## Future Enhancements

- API integration for real banking data
- Authentication system
- Push notifications
- Biometric authentication
- Multi-language support
- Dark mode support

## Contributing

This is a skeleton project ready for API integration and additional features. The UI is complete and ready for backend connectivity.

## License

This project is for demonstration purposes.
