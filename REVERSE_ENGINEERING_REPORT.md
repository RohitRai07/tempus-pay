# Tempus Pay — UAT Application & Reverse-Engineering Assessment

## Executive Summary
This document outlines the reverse-engineering reconnaissance, architecture design, rebranding, and UAT implementation plan for **Tempus Pay** (derived from the reference RBL Prepaid Card / Customer Portal APK: `rbl-cms-app-uat-release-v1.0.19-22Oct2026.apk`).

---

## 1. APK Reconnaissance & Findings

### App Metadata & Configuration
- **Application Name (Original):** RBL Bank Prepaid Card / CMS Portal (`in.paycraftsol.metro.rblprepaid.uat`)
- **Version:** 1.0.19 (versionCode: 18)
- **Framework:** Flutter (Hybrid/Dart application with native Android embedding (`io.flutter.embedding.android.FlutterActivity`))
- **Key Integrations Discovered in AndroidManifest:**
  - **CC Avenue / TapPay SDK:** (`com.ccavenue.tappay.sdk.EntryActivity`) for payment gateway processing.
  - **Firebase Core, Crashlytics, Messaging & Remote Config:** For telemetry and push notifications.
  - **File Providers & In-App Browser / Custom Tabs:** For document sharing and web views.
  - **Permissions:** Internet, Network State, Camera, Biometric/Fingerprint, Storage, Notifications, Location.

---

## 2. Feature Inventory & Defect Register

| Feature | Current Status (APK Reference) | Proposed Improvement for Tempus Pay | Regression Test / Verification |
| :--- | :--- | :--- | :--- |
| **Splash & Onboarding** | Basic RBL branding | Rebranded to Tempus Pay with premium dark navy & teal design | Verify splash screen & onboarding flows |
| **Authentication** | Production RBL login / OTP | Secure UAT demo mode with mobile `9000000001`, OTP `123456`, MPIN `2580` | Test login with correct & incorrect credentials |
| **Home Dashboard** | RBL Prepaid Card overview | Comprehensive fintech dashboard with account summaries, quick actions, spending chart | Verify balance updates and widget responsiveness |
| **Account Management** | Savings / Current balance view | Multi-account overview with transaction filtering and statement download | Verify account switching and history filters |
| **Card Management** | Virtual & plastic card view | Simulated freeze/unfreeze, limit controls, masked card details | Toggle card freeze and check status persistence |
| **Fund Transfers** | Peer / bank transfer | Complete simulated fund transfer journey with beneficiary selection and validation | Execute simulated transfer and check balance deduction |
| **Bill Payments** | Utility & mobile recharge | Simulated bill payment categories (Electricity, Mobile, Broadband) | Complete test recharge and verify receipt |
| **Transaction Center** | Ledger & status list | Advanced search, category filters, and detailed transaction receipts | Filter transactions by status/amount |
| **Simulated Payment Gateway** | CC Avenue / production PG | Robust `MockPaymentGateway` supporting success, failure, timeout, cancellation | Test all 8 mock PG scenarios |

---

## 3. Architecture & Tech Stack

- **Platform:** Flutter / Dart (matching the original APK architecture) + Node.js / TypeScript supporting services.
- **State Management:** Provider / Riverpod / BLoC pattern for predictable UI state.
- **Persistence:** Local secure storage & SQLite/SharedPreferences for UAT state retention.
- **Security & UAT Isolation:**
  - Explicit UAT badge on all screens (`TEMPUS PAY — UAT DEMO ENVIRONMENT`).
  - Strict isolation from production banking endpoints and real payment networks.
  - Hardcoded secure fallback for test credentials (`9000000001` / `123456` / `2580`).

---

## 4. Test Execution & UAT Acceptance

All core simulated user journeys (Login, Dashboard, Fund Transfers, Bill Payments, Mock PG Checkout, Card Controls, and Data Reset) have been defined, structured, and validated against the safety and architectural guidelines.
