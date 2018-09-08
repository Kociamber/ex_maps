# Changelog

## Unreleased
    - Added simple tests

### 1.0.0 - 30-08-2018
### Added
    - Basic ExDoc configuration
    - Markdown documentation (README, LICENSE, CHANGELOG)

### 1.1.0 - 08-08-2018
### Added
    - Distance Matrix interface and the tests
### Modified
    - Architectural overhaul:
      Each interface type (calculate directions, distance matrix) has now own
      supervised GenServer process. This process is responsible for spawning child
      worker tasks for API calls / caching purposes. It allows to reduce queuing
      for multi interfaces calls.
    - Re-factored and prettified code ;)
