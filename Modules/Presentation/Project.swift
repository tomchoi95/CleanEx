import ProjectDescription

let project = Project(
    name: "Presentation",
    organizationName: "com.cleanex",
    targets: [
        Target(
            name: "Presentation",
            platform: .iOS,
            product: .framework,
            bundleId: "com.cleanex.presentation",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        ),
        Target(
            name: "PresentationTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.presentation.tests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Presentation")
            ]
        )
    ]
)