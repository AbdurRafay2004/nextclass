allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

subprojects {
    afterEvaluate {
        val androidExt = project.extensions.findByName("android")
        if (androidExt != null) {
            try {
                val namespaceMethod = androidExt.javaClass.getMethod("getNamespace")
                val namespace = namespaceMethod.invoke(androidExt)
                if (namespace == null || namespace.toString().isEmpty()) {
                    val setNamespaceMethod = androidExt.javaClass.getMethod("setNamespace", String::class.java)
                    var newNamespace = project.group.toString()
                    if (newNamespace.isEmpty()) {
                        newNamespace = "com.example.${project.name.replace('-', '_')}"
                    }
                    setNamespaceMethod.invoke(androidExt, newNamespace)
                }
            } catch (e: Exception) {
                // Ignore if getNamespace/setNamespace doesn't exist
            }
        }
    }
}
