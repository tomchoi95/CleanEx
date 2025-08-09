import ProjectDescription

let project = Project(
    name: "Domain",
    organizationName: "com.cleanex",
    targets: [
        Target(
            name: "Domain",
            platform: .iOS,
            product: .framework,
            bundleId: "com.cleanex.domain",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: []
        ),
        Target(
            name: "DomainTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.domain.tests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Domain")
            ]
        )
    ]
)