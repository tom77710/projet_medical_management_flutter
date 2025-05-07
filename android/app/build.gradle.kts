plugins {
    id("com.android.application")
    id("kotlin-android")
    // Le plugin Flutter doit venir après ceux d'Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")
    // 👇 Plugin nécessaire pour Firebase
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.projet_medical_management_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.projet_medical_management_flutter"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
