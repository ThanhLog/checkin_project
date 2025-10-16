
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.app_checkin"
    compileSdk = 36 

    defaultConfig {
        applicationId = "com.example.app_checkin"
        minSdk = 23
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        isCoreLibraryDesugaringEnabled  = true // ✅ Kotlin DSL
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Kotlin stdlib
    implementation("org.jetbrains.kotlin:kotlin-stdlib:1.9.10") // thay vì $kotlin_version

    // Core library desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // Flutter dependencies sẽ tự add
}

flutter {
    source = "../.."
}
