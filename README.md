# Flutter Sembast Provider Example
A basic contact management flutter app demonstrating the use of Provider for state management and Sembast for persistent data storage.

- [Sembast](https://pub.dev/packages/sembast)
- [Provider](https://pub.dev/packages/provider)

Every time persistent data is changed (when a contact is added, edited, or deleted from sembast), the provider data is refreshed from sembast. The ui is updated by calling `notifyListeners();`. You will notice the UI on all screens is instantly updated with the latest data, and the data persists when the app is closed.
