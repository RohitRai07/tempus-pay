# Tempus Pay UAT

Tempus Pay is a professional, production-quality fintech UAT mobile application built using Flutter.

## Features
- **Secure UAT Authentication:** Mobile `9000000001`, OTP `123456`, MPIN `2580`.
- **Comprehensive Fintech Dashboard:** Net balance, account summaries, quick actions, and recent ledger history.
- **Card Management:** Virtual and credit cards with freeze/unfreeze controls.
- **Fund Transfers:** Secure simulated transfers with beneficiary validation and duplicate-submission protection.
- **Bill Payments:** Support for electricity, mobile recharges, broadband, and utilities.
- **Simulated Payment Gateway:** 8 deterministic test scenarios (`success`, `declined`, `insufficient_funds`, `cancelled`, `timeout`, `pending`, `duplicate`, `delayed`).

---

## Building the APK via Cloud (GitHub Actions)

Since compiling Android applications requires the Android SDK and Gradle, the easiest way to generate your installable APK without installing heavy tools locally is using GitHub Actions:

1. Create a new empty repository on [GitHub](https://github.com) named `tempus-pay` under your username `RohitRai07`.
2. Push this project folder to your repository:
   ```bash
   git push -u origin main
   ```
3. Go to your repository on GitHub (`https://github.com/RohitRai07/tempus-pay`) and click on the **Actions** tab.
4. Once the build workflow completes successfully, download the **tempus-pay-debug** artifact zip, extract `app-debug.apk`, and install it on your Android phone!
