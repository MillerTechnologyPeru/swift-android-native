// Compatibility module.
//
// This fork previously renamed the `AndroidLogging` target to `SkipAndroidLogging` to avoid a
// module-name collision with other packages in a Skip app's graph. That rename made the fork
// incompatible with PureSwift/Android, which imports the upstream `AndroidLogging` name.
//
// Instead of renaming, the upstream target keeps its name and this thin module re-exports it, so
// both `import AndroidLogging` and `import SkipAndroidLogging` resolve to the same code.
@_exported import AndroidLogging
