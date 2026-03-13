# Smart Class Check-in & Learning Reflection App 🚀

**Course:** 1305216 Mobile Application Development  
[cite_start]**Status:** MVP Prototype (Midterm Lab Exam) [cite: 1, 2]

---

## [cite_start]🎯 1. Product Requirement Document (PRD) [cite: 50]

### [cite_start]Problem Statement [cite: 51]

[cite_start]Traditional attendance fails to verify physical presence effectively and misses the opportunity to capture student engagement and emotional readiness for learning[cite: 8].

### [cite_start]Target User [cite: 52]

- [cite_start]University students attending physical classes[cite: 6].

### [cite_start]Feature List [cite: 53]

- [cite_start]**Dual-Factor Check-in:** Combines GPS coordinates with QR code scanning[cite: 14].
- [cite_start]**Reflection Engine:** Captures mood and expectations before class, and learned outcomes after class[cite: 20, 21, 32].
- [cite_start]**Local Persistence:** Securely stores records on device using `shared_preferences`[cite: 43].

### [cite_start]User Flow [cite: 54]

1. [cite_start]**Home:** Select "Check-in" or "Finish Class"[cite: 59].
2. [cite_start]**Check-in:** Record GPS + Timestamp -> Scan QR -> Fill Reflection Form -> Save[cite: 14].
3. [cite_start]**Finish Class:** Scan QR -> Record GPS -> Fill Feedback Form -> Save[cite: 17, 18].

### [cite_start]Tech Stack [cite: 56]

- [cite_start]**Frontend:** Flutter (Mobile & Web)[cite: 42].
- [cite_start]**Storage:** `shared_preferences` (Local JSON Storage)[cite: 71].
- [cite_start]**Deployment:** Firebase Hosting[cite: 73].

---

## [cite_start]🛠️ 2. Setup & Installation

### Prerequisites

- Flutter SDK (latest version)
- Firebase CLI (for deployment)

### Instructions

1. **Clone the Repo:** `git clone <your-repo-url>`
2. **Install Deps:** `flutter pub get`
3. **Run App:** `flutter run` (or `flutter run -d chrome` for web)

---

## [cite_start]🤖 3. AI Usage Report

- [cite_start]**Tools Used:** Gemini (Mr. Bug)[cite: 93].
- [cite_start]**AI Contribution:** Generated PRD structure, local storage service logic, and UI scaffolding for QR/GPS integration.
- [cite_start]**Human Modification:** Adjusted GPS permission handling and customized the reflection form validation manually.

---

## 🌐 4. Deployment Link

[cite_start]**Live Demo:** [Insert your Firebase URL here]
