# Changelog

All notable changes to this project will be documented in this file.

## [0.0.1+1] - 2024-12-09

### Added
- **Initial setup**: Added basic navigation system using `nav_flex` package.
- **Dynamic Route Registration**: Routes can be added dynamically with optional guards.
- **Custom Transitions**: Added support for custom transitions (e.g., slide, fade) when navigating.
- **Route History**: Implemented route history tracking with `NavigationService` to allow users to return to previous routes.
- **Route Guards**: Added support for route guards to control access to pages, based on conditions (e.g., authentication).
- **History Button**: Introduced a draggable floating button (`DraggableHistoryButton`) to access navigation history.
- **Home Page**: Created `HomePage` as the starting point with a button to navigate to `DetailsPage`.
- **Details Page**: Added `DetailsPage` to display arguments passed from `HomePage` and navigate to `HistoryPage`.
- **History Page**: Created `HistoryPage` to display route history and allow the user to return to any previous route.

### Changed
- **Navigation Service**: Refined the `NavigationService` to handle navigation with transitions and history tracking.
- **Custom Transitions**: Improved handling of custom transitions through the `TransitionFactory`.
