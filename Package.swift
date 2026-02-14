// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "swift-android-native",
    products: [
        .library(name: "AndroidNative", targets: ["AndroidNative"]),
        .library(name: "AndroidContext", targets: ["AndroidContext"]),
        .library(name: "AndroidAssetManager", targets: ["AndroidAssetManager"]),
        .library(name: "SkipAndroidLogging", targets: ["SkipAndroidLogging"]),
        .library(name: "SkipAndroidLooper", targets: ["SkipAndroidLooper"]),
        .library(name: "AndroidChoreographer", targets: ["AndroidChoreographer"]),
    ],
    dependencies: [
        .package(url: "https://source.skip.tools/swift-jni.git", "0.0.0"..<"2.0.0"),
    ],
    targets: [
        .target(name: "SkipAndroidNDK", path: "Sources/AndroidNDK", linkerSettings: [
            .linkedLibrary("android", .when(platforms: [.android])),
            .linkedLibrary("log", .when(platforms: [.android])),
        ]),
        .target(name: "ConcurrencyRuntimeC"),
        .target(name: "AndroidSystem", dependencies: [
            .target(name: "SkipAndroidNDK", condition: .when(platforms: [.android]))
        ], swiftSettings: [
            .define("SYSTEM_PACKAGE_DARWIN", .when(platforms: [.macOS, .macCatalyst, .iOS, .watchOS, .tvOS, .visionOS])),
            .define("SYSTEM_PACKAGE"),
        ]),
        .testTarget(name: "AndroidSystemTests", dependencies: [
            "AndroidSystem",
        ]),
        .target(name: "AndroidAssetManager", dependencies: [
            .product(name: "SwiftJNI", package: "swift-jni"),
            .target(name: "SkipAndroidNDK", condition: .when(platforms: [.android])),
        ]),
        .testTarget(name: "AndroidAssetManagerTests", dependencies: [
            "AndroidAssetManager",
        ]),
        .target(name: "SkipAndroidLogging", dependencies: [
            .target(name: "SkipAndroidNDK", condition: .when(platforms: [.android])),
        ], path: "Sources/AndroidLogging"),
        .testTarget(name: "AndroidLoggingTests", dependencies: [
            "SkipAndroidLogging",
        ]),
        .target(name: "AndroidContext", dependencies: [
            "AndroidAssetManager",
            .target(name: "SkipAndroidNDK", condition: .when(platforms: [.android])),
        ]),
        .testTarget(name: "AndroidContextTests", dependencies: [
            "AndroidContext",
        ]),
        .target(name: "SkipAndroidLooper", dependencies: [
            "AndroidSystem",
            "SkipAndroidLogging",
            "ConcurrencyRuntimeC",
        ], path: "Sources/AndroidLooper"),
        .testTarget(name: "AndroidLooperTests", dependencies: [
            "SkipAndroidLooper",
        ]),
        .target(name: "AndroidChoreographer", dependencies: [
            "AndroidSystem",
            "SkipAndroidLogging",
        ]),
        .testTarget(name: "AndroidChoreographerTests", dependencies: [
            "AndroidChoreographer",
        ]),
        .target(name: "AndroidNative", dependencies: [
            "AndroidContext",
            "SkipAndroidLogging",
            "SkipAndroidLooper",
            "AndroidChoreographer",
        ]),
        .testTarget(name: "AndroidNativeTests", dependencies: [
            "AndroidNative",
        ], resources: [.embedInCode("Resources/sample_resource.txt")]),
    ]
)
