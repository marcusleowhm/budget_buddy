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
        - account.dart keeps mock data for building the app
    - theme (reserved for use in the future to customize the app look)
    - utilities (Help functions (Json utilities, serializer, converter etc))
    - main.dart (program entry point)
    
Current Known Issues:
- Moving focus through the inputs require a lot of passing parameters around. Will need to refactor the move focus function
- Refactor UTransactionCubit to use LedgerInput to match id instead of index whenever changing state
- Move form validation logic from cubit into the formcontrol utility
- Need to create additional properties on the transaction data for different TransactionType. e.g. Income Category, Expense Category, Account To
- Pixel overflow on datetime when running on Desktop
- Error message still show when form is valid