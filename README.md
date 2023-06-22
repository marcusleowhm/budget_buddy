Command:  
- To run the application: `flutter run -t lib/main_<env>.dart`. For example: 
    - dev -> `flutter run -t lib/main_dev.dart`
    - prod -> `flutter run -t lib/main_prod.dart`

The folders are separated by features
Project Struture:
- cloud_functions: internal API calls
- lib: 
    - features (with their respective subfolders)
        - components (UI Components made up from standard flutter widgets or customized widgets)
        - cubit (State management library BloC)
        - providers (external API calls)
        - screens (split up into primary or secondary screens)
        - constants: Application constants
        - widgets: Custom widgets to wrap and extend Flutter widgets with additional properties or methods
    - mock: 
        - account.dart keeps mock data for building the app (refactored to be initialized in the cubit since 22 June 2023)
    - theme (reserved for use in the future to customize the app look)
    - utilities (Help functions (Json utilities, serializer, converter etc))
    - main.dart (program entry point)
    
Current Known Issues:
