
Flutter app (3.x) with simple state + HTTP to the backend above.

Requirements
- Flutter SDK 3.x or later (if running from source) -> (https://docs.flutter.dev/get-started/install)
- Android Studio / VSCode with Flutter extension
- Backend running at http://localhost:3000 (or device-reachable IP)

Quick start (Chrome)
# 1) clone
git clone https://github.com/adlynkhairudin123/front-end-test-vista.git
cd front-end-test-vista

# 2) deps
flutter pub get

# 3) run Web
flutter run -d chrome --dart-define=API_BASE=http://localhost:3000
or
flutter run -d windows    
or
flutter run -d edge       


The app reads the API base from a compile-time define:
// in lib/api.dart (or config)
const String kApiBase = String.fromEnvironment('API_BASE', defaultValue: 'http://localhost:3000');
All requests use kApiBase.

Other run targets
1. Android Emulator:
flutter run --dart-define=API_BASE=http://10.0.2.2:3000

2. iOS Simulator:
flutter run --dart-define=API_BASE=http://127.0.0.1:3000

3. Physical device (same Wi-Fi):
flutter run --dart-define=API_BASE=http://<YOUR_PC_IP>:3000

Modules:
- CompanyListScreen — shows companies and their services
- CreateCompanyScreen — create new company (validates fields)
- CreateServiceScreen — create new service (validates fields + price numeric)

Flow:
1. Open the app (Chrome easiest).
2. Tap Add Company → create with { Adlyn / REG-001 }.
3. Tap Add Service → create with { Gold / Premium / 49.90 / select company }.
4. Back to list → company card shows chip Gold • RM 49.90.

Troubleshooting
- Network from device: use your PC IP, not localhost.
- CORS: API enables CORS; make sure backend is on http://localhost:3000.
- No data: the app lists whatever the API returns; create via UI or Swagger.

SUMMARY:-
1. can run backend with:
- docker compose down -v
- docker compose up --build
→ visit Swagger at http://localhost:3000/api-docs.

2. can run frontend with:
- flutter pub get
- flutter run -d chrome --dart-define=API_BASE=http://localhost:3000

RESULT:
<img width="1911" height="955" alt="image" src="https://github.com/user-attachments/assets/e34443d1-a2b5-4436-b118-00bcbe27b475" />
<img width="1912" height="953" alt="image" src="https://github.com/user-attachments/assets/dd93d411-224e-4f8e-8557-2d2a80a72714" />
<img width="1917" height="949" alt="image" src="https://github.com/user-attachments/assets/b7ff383c-1523-46ac-9490-e3a2b8b4fa7f" />
<img width="1915" height="955" alt="image" src="https://github.com/user-attachments/assets/60c25c0b-8cd2-482c-b754-9aff3b58f6fe" />



