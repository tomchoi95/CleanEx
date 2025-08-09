import ProjectDescription

let project = Project(
    name: "CleanEx",
    organizationName: "com.cleanex",
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "YOUR_TEAM_ID"
        ]
    ),
    targets: [
        // Main App Target
        Target(
            name: "CleanEx",
            platform: .iOS,
            product: .app,
            bundleId: "com.cleanex.app",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["CleanEx/Sources/**"],
            resources: ["CleanEx/Resources/**"],
            dependencies: [
                .project(target: "Presentation", path: "./Modules/Presentation"),
                .project(target: "DI", path: "./Modules/DI")
            ]
        ),
        
        // App Tests Target
        Target(
            name: "CleanExTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.app.tests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["CleanEx/Tests/**"],
            dependencies: [
                .target(name: "CleanEx")
            ]
        )
    ]
)