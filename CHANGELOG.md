## 0.2.2

- Removed deprecated widgets

## 0.2.1

- Common buttons (wrappers for Flutter buttons)
- Theme switching widgets - buttons, switch, toggle buttons

## 0.2.0

- Updated dependencies
- Working DebugService on web. Only console logging is available on web. 
- Rename widgets **AppXxx** to **AcXxx**. Annotate original widgets as deprecated. Deprecation 
  messages contain references to new widgets.
- `AcResourcesBuilder` (replacement for `AppLocalization`) requires `builder` method,
  `child` is optional. Returns descendant of `AcResources` in builder method instead of `Locale`.
  Locale is available as `resources.locale`.


## 0.1.6

- Updated dependencies

## 0.1.5

- ColorConverter moved from `ac_dart`

## 0.1.4

- Generally available public release
