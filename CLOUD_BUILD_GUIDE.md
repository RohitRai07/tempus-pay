# Tempus Pay — Cloud Build & GitHub Actions Guide

Because compiling an Android APK (`.apk`) requires the Android SDK, Gradle, and build-tools (which are not installed locally in this sandbox), the cleanest and easiest way to get your signed **Tempus Pay** APK without installing anything on your PC is to use **GitHub Actions** (which compiles it for free in the cloud).

---

## Step 1: Create a Free GitHub Repository
1. Go to [GitHub](https://github.com) and create a new **private** or **public** repository named `tempus-pay`.
2. Push your project files (`REVERSE_ENGINEERING_REPORT.md`, `tempus_pay_spec.yaml`, etc.) to the repository.

---

## Step 2: Add the Automated Build Workflow
Create a file named `.github/workflows/build_apk.yml` in your repository with the following contents:

```yaml
name: Build Tempus Pay APK

on:
  push:
    branches: [ main, master ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v3

      - name: Set up Java
        uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Set up Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.19.x'
          channel: 'stable'

      - name: Install Dependencies
        run: flutter pub get

      - name: Build Release APK
        run: flutter build apk --release

      - name: Upload APK Artifact
        uses: actions/upload-artifact@v3
        with:
          name: tempus-pay-release
          path: build/app/outputs/flutter-apk/app-release.apk
```

---

## Step 3: Download Your APK
1. Once you push this workflow to GitHub, click on the **Actions** tab in your repository.
2. Watch the build finish (usually takes 2-3 minutes).
3. Click on the completed run, scroll down to **Artifacts**, and download `tempus-pay-release`.
4. Extract the downloaded zip file to get your `app-release.apk`, transfer it to your Android phone, and install it!
