import ProjectDescription

let project = Project(
    name: "CleanEx",
    targets: [
        .target(
            name: "CleanEx",
            destinations: .iOS,
            product: .app,
            bundleId: "com.cleanex.app",
            deploymentTargets: .iOS("15.0"),
            sources: ["CleanEx/Sources/**"],
            resources: ["CleanEx/Resources/**"],
            dependencies: [
                .project(target: "Presentation", path: "./Modules/Presentation"),
                .project(target: "DI", path: "./Modules/DI")
            ]
        ),
        .target(
            name: "CleanExTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.app.tests",
            sources: ["CleanEx/Tests/**"],
            dependencies: [
                .target(name: "CleanEx")
            ]
        )
    ]
)