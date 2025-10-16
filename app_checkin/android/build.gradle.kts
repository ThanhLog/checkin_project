// Top-level build.gradle.kts

buildscript {
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("com.android.tools.build:gradle:8.2.1") // dùng version Android Gradle Plugin
        classpath("com.google.gms:google-services:4.4.0") // Firebase plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Optional: Custom build directory (nếu thực sự cần)
val newBuildDir = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
