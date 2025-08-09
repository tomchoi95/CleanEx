import ProjectDescription

let project = Project(
    name: "DI",
    organizationName: "com.cleanex",
    targets: [
        Target(
            name: "DI",
            platform: .iOS,
            product: .framework,
            bundleId: "com.cleanex.di",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Data", path: "../Data"),
                .project(target: "Presentation", path: "../Presentation")
            ]
        ),
        Target(
            name: "DITests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.di.tests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "DI")
            ]
        )
    ]
)