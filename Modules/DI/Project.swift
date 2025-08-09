import ProjectDescription

let project = Project(
    name: "DI",
    targets: [
        .target(
            name: "DI",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.cleanex.di",
            sources: ["Sources/**"],
            dependencies: [
                .project(target: "Domain", path: "../Domain"),
                .project(target: "Data", path: "../Data"),
                .project(target: "Presentation", path: "../Presentation")
            ]
        ),
        .target(
            name: "DITests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "com.cleanex.di.tests",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "DI")
            ]
        )
    ]
)