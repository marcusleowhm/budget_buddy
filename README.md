The folders are separated by feature

Project Struture:
- cloud_functions: internal API calls
- lib: 
    - features (with their respective subfolders)
        - components (UI Components made up from standard flutter widgets or customized widgets)
        - cubit (State management library BloC)
        - providers (external API calls)
        - screens (split up into primary or secondary screens)
        - constants: Application constants
        - widgets: Custom widgets functioning like a wrapper for Flutter widgets
    - mock: 
        - account.dart keeps mock data for building the app
    - theme (reserved for use in the future to customize the app look)
    - utilities (Help functions (Json utilites, serializer, converter etc))
    - main.dart (program entry point)
    
Current Known Issues:
- Moving focus through the inputs require a lot of passing parameters around. Will need to refactor the move focus function
- Major refactor is needed to separate the textediting controllers from the data itself