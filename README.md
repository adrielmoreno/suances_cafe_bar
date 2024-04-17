# suances_cafe_bar

Application to manage purchase orders, suppliers, expenses and income of the restaurant:

## How to use this project?

1. Create a project in [Firebase](https://console.firebase.google.com/)
2. Run this command to change the package name:

    ```cmd
    flutter pub run change_app_package_name:main com.new.package.name
    ```

3. [Add Firebase](https://firebase.google.com/docs/flutter/setup?platform=ios) to your Flutter app:

    ```cmd
    firebase login

    dart pub global activate flutterfire_cli
    
    flutterfire configure
    ```

## Libraries and tools used

- [go_router: ^13.2.1 - routing](https://pub.dev/packages/go_router)
- [get_it: ^7.6.7 - DI](https://pub.dev/packages/get_it)
- [provider: ^6.1.2 - state](https://pub.dev/packages/provider)
  
### Firebase

- [firebase_core: ^2.27.2 - firebase](https://pub.dev/packages/firebase_core)
- [cloud_firestore: ^4.15.10 - BBDD](https://pub.dev/packages/cloud_firestore)
- [firebase_storage: ^11.6.11 - storage](https://pub.dev/packages/firebase_storage)

### Auth

- [firebase_auth: ^4.18.0](https://pub.dev/packages/firebase_auth)
- [google_sign_in: ^6.2.1](https://pub.dev/packages/google_sign_in)

### Utils

- [change_app_package_name: ^1.1.0 - rename app](https://pub.dev/packages/change_app_package_name)
- [diacritic: ^0.1.5 - filter text](https://pub.dev/packages/diacritic)
- [intl_phone_number_input: ^0.7.4 - input](https://pub.dev/packages/intl_phone_number_input)
- [flutter_localizations - internationalization](https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization)
- [Material Theme Builder](https://m3.material.io/theme-builder#/custom)
