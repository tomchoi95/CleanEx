import ProjectDescription

let project = Project(
    name: "Data",
    organizationName: "com.cleanex",
    targets: [
        Target(
            name: "Data",
            platform: .iOS,
            product: .framework,
            bundleId: "com.cleanex.data",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain")
            ]
        ),
        Target(
            name: "DataTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.data.tests",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "Data")
            ]
        )
    ]
)