# Product Requirement Document (PRD)

## Problem Statement

[cite_start]Traditional attendance fails to verify physical presence effectively and misses the opportunity to capture student engagement and emotional readiness for learning[cite: 8].

## Target User

[cite_start]University students attending physical classes[cite: 6].

## Feature List

- [cite_start]**Dual-Factor Check-in:** Combines GPS coordinates with QR code scanning[cite: 14].
- [cite_start]**Reflection Engine:** Captures mood and expectations before class, and learned outcomes after class[cite: 20, 21, 32].
- [cite_start]**Local Persistence:** Securely stores records on device using `shared_preferences`[cite: 43].

## User Flow

1. [cite_start]**Home:** Select "Check-in" or "Finish Class"[cite: 59].
2. [cite_start]**Check-in:** Record GPS + Timestamp -> Scan QR -> Fill Reflection Form -> Save[cite: 14].
3. [cite_start]**Finish Class:** Scan QR -> Record GPS -> Fill Feedback Form -> Save[cite: 17, 18].

## Data Fields

- [cite_start]Check-in: `lat`, `long`, `timestamp`, `prevTopic`, `expectedTopic`, `mood`[cite: 14].
- [cite_start]Check-out: `lat`, `long`, `timestamp`, `learnedTopic`, `feedback`[cite: 17, 18].

## Tech Stack

- [cite_start]**Frontend:** Flutter (Mobile & Web)[cite: 42].
- [cite_start]**Storage:** `shared_preferences` (Local JSON Storage)[cite: 71].
- [cite_start]**Deployment:** Firebase Hosting[cite: 73].
