import ProjectDescription

let workspace = Workspace(
    name: "CleanEx",
    projects: [
        "./",
        "./Modules/Domain",
        "./Modules/Data", 
        "./Modules/Presentation",
        "./Modules/DI"
    ]
)