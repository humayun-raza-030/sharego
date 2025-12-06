# ShareGo �?" Dual-Agent Operating Manual (Backend & Frontend)

# ShareGo Orchestration Log (Chronological) — UPDATE AFTER EVERY CHANGE

> This file is the **working copy** for day-to-day updates, to-do deltas, and sprint tracking.
> Keep entries short, dated, and actionable. Asia/Karachi timezone.

## Canonical Docs (paths)

- /mnt/data/ShareGo Proposal.pdf
- /mnt/data/Share Go Backend.docx
- /mnt/data/ShareGo Report 2.pdf
- /mnt/data/ShareGo Logo 1.png

---

## Schedule (Sprints & Dates)

- **Sprint 1:** 2025-11-22 → 2025-11-28 — Foundations & Auth/KYC
- **Sprint 2:** 2025-11-29 → 2025-12-05 — Feature A core (Trips/Requests/Matching + Booking scaffold)
- **Sprint 3:** 2025-12-06 → 2025-12-12 — Escrow (sim) + Handover OTP/QR + media/GPS + Admin release/refund
- **Sprint 4:** 2025-12-13 → 2025-12-19 — Marketplace (listings/offers/meetups/mark sold) + search
- **Sprint 5:** 2025-12-20 → 2025-12-26 — Reviews, basic Chat, AI (read-only) + Admin moderation pages
- **Sprint 6:** 2025-12-27 → 2026-01-02 — Hardening, QA, backups, APK & demo polish

---

## 2025-11-21 — Sprint 1 Wrap (Effectively Complete)

**Backend**

- Enforced JWT auth dependency and current-user retrieval; Trips now use JWT user.
- Added KYC model/schemas/routes (submit/status).
- Added placeholder routers (Requests, Bookings/Escrow, Listings/Offers/Meetups, Messages, Reviews) returning **501** to lock contracts.
- Added admin placeholder route and seed script (`server/seed.py`) for demo user/trip.
- SQLModel persistence for Users/Trips/OTP/KYC; `init_db` creates tables on startup.
- Tests passing: `PYTEST_DISABLE_PLUGIN_AUTOLOAD=1 python -m pytest -q`.
- **Warnings (open):** FastAPI `on_event` deprecation (migrate to lifespan); httpx testclient deprecation.

**Frontend**

- Token storage (shared_preferences) and Dio auth interceptor added.
- Riverpod auth state scaffold and `AuthService`; basic Auth UI (email + OTP) with retry/error surfaces; base layout displays API URL.
- `pubspec.yaml` updated (`dio`, `dio_smart_retry`, `flutter_riverpod`, `shared_preferences`); app uses `ProviderScope`.
- **Open:** global connectivity/retry banner & central snackbar; warning cleanup deferred.

**To-Do Delta**

- ✅ Sprint-1 core items complete.
- ➕ Add S2 tasks for Matching & Booking scaffold.
- 🔧 Create warning cleanup task (backend: lifespan/httpx; frontend: none).

---

## 2025-11-22 — Sprint 2 Kickoff

**Planned Backend Tasks**

- [ ]  Trips/Requests validators (dates, price, weight, airport codes).
- [ ]  `GET /matching/suggest?tripId=…|requestId=…` (rule-based: origin/dest/date window ±3d).
- [ ]  Booking scaffold: `POST /bookings` (→ `REQUESTED`), `/bookings/{id}/accept|decline` with owner guards; return 400/403/404 on illegal transitions.
- [ ]  Postman collection v0.1 + seed: sample requests.

**Planned Frontend Tasks**

- [ ]  Trip create/list/detail screens with validation & loaders.
- [ ]  Request create/list/detail screens with validation & loaders.
- [ ]  Matching screen (suggestions) + skeleton loaders.
- [ ]  Global connectivity banner; unified snackbar/error mapper; localized Urdu strings.

**Risks/Notes**

- Validate SQLite WAL + short transaction retries under concurrent test.
- Plan for file size limits & JPEG compression on mobile before Marketplace work.

---

## Live To-Do Lists (Keep Updated)

### Agent-B — Backend

- [X]  JWT enforcement & current user on Trips
- [X]  KYC submit/status
- [X]  Placeholder routers → 501 (Requests/Bookings/Escrow/Marketplace/Meetups/Messages/Reviews)
- [X]  Admin placeholder & `server/seed.py`
- [X]  SQLModel + `init_db`
- [X]  Tests green
- [ ]  **Warning cleanup:** switch to FastAPI **lifespan**; update httpx test transport
- [ ]  Trips/Requests validators & filters
- [ ]  `/matching/suggest` (rule-based)
- [ ]  Booking scaffold (create/accept/decline) + strict 4xx mapping
- [ ]  Postman v0.1 + extended seed

### Agent-F — Frontend

- [X]  Token storage + Dio auth interceptor
- [X]  Auth UI (email/OTP), retry/errors
- [X]  Riverpod auth state
- [X]  Base layout shows API URL
- [ ]  Global snackbar/error handler
- [ ]  Connectivity/retry banner
- [ ]  Trip/Request create/list/detail
- [ ]  Matching screen (suggestions)
- [ ]  Form validations; Urdu/English labels

---

## Conventions

- **Every commit** must update this file with a short, dated entry.
- Use checkboxes under Live To-Do Lists; move completed items to the dated entry above.
- Keep `AGENTS.md` in sync for the high-level status; **this log is the ground truth**.

## 0) Project Scope �?" Quick Recall (Authoritative)

**Feature A �?" Personal Shopping (Escrow, traveler-focused)**
Buyer posts item request �+' Traveler posts trip/capacity �+' private chat �+' agree price �+' **simulated escrow hold** �+' pickup/delivery with **OTP/QR + photos + GPS + optional seal ID** �+' admin releases escrow �+' mutual reviews.

**Feature B �?" Overweight Marketplace (OLX-style classifieds, no auctions)**
Any user posts listing �+' buyers send private **offers / counter-offers** (no public bidding) �+' if they agree, **Meetup & payment are off-platform** (cash/transfer) �+' optional in-app OTP �?oMeetup Confirmation�?? (timestamp only) �+' seller marks **Sold** �+' reviews.

**AI assistant (very simple):** domain-restricted FAQ + read-only DB tools (own data only), policy flags advisory; **no write actions, no RAG, no internet**.

**Hard guardrails:**

* **SQLite** database (`sharego.db`)
* **No bidding/auctions** anywhere
* **Escrow only in Feature A**; **Marketplace has no escrow/no delivery by ShareGo**
* OTP/QR codes are **hashed**; media stored as relative paths under `./media/`

Repo skeleton and schema/endpoint lists are considered canonical.

---

## 1) Roles at a Glance

### Agent-B (Backend Lead) �?" �?oOps-Safe FastAPI�??

**Mission:** Deliver a secure, well-tested FastAPI monolith + Jinja2 admin that implements the exact schemas, state machines, and endpoints. Provide stable, versioned contracts to mobile. Keep AI micro-app read-only and sandboxed.

**You own:** Auth/JWT/OTP, KYC, Trips/Requests/Matching, Bookings/Escrow (sim), Handover events (OTP/QR/GPS/photos), Marketplace (listings/offers/meetups), Reviews, Media, Admin (Jinja2), AI (read-only tools), Migrations, Indexing/FTS, Rate-limits, Audit logs, CI tests, Backup.

### Agent-F (Frontend Lead) �?" �?oFlutter, Fail-Gracefully�??

**Mission:** Ship a clean, low-latency Flutter app covering traveler & buyer flows (A) and classifieds (B), with offline-tolerant UX for Pakistan. Integrate QR scan, GPS, camera, Dio REST, Riverpod/BLoC state. Include in-app chat, offer threads, OTP verify screens, and a minimal read-only AI chat.

**You own:** Screens, navigation, state, input validation, media capture, location/QR permissions, error surfaces, retries, skeleton loaders, Urdu/English strings, small-screen layouts, AA color contrast, sensible toasts/snackbars.

---

## 2) Global Guardrails (Both Agents)

* **Legal & UX disclaimers:** For Feature B, show an **always-visible disclaimer**: �?oShareGo does **not** handle payments, courier, delivery, or customs for Marketplace. Parties must arrange themselves and follow local laws.�??
* **Pakistan realities:** OTP delays on local telcos, intermittent power/internet (graceful retries), PKR currency, distance in km, Urdu transliteration allowed, airport presets (LHE/KHI/ISB), cash preferred, simple address text fields.
* **Security:** JWT HS256; bcrypt hashes; 10 MB upload cap; extension whitelist (jpg/png/pdf); PII masking in AI replies; only owners can mutate their entities; all sensitive transitions logged to `audit_logs`.
* **Performance:** Add indexes, consider FTS5 for `market_listings` search; pagination (default 20); N+1 avoidance in read endpoints.
* **No hidden features:** Absolutely **no** shadow escrow in Marketplace; **no** public bidding UI.

---

## 3) End-to-End Build Plan (Milestones & Definition-of-Done)

> Build is split into 6 sprints. Each sprint ends with Backend Postman/cURL demo + Flutter screen recording + Admin Jinja2 proof. All items include unit/integration tests where relevant.

### Sprint 1 �?" Foundations & Auth/KYC

**B:**

* Bootstrap FastAPI app structure per repo layout; wire SQLite URL and Alembic.
* Models for `users`, `kyc_profiles`, base repos/schemas, `feature_flags`, `audit_logs`.
* Email OTP (dev mode logs code), JWT issuance, role guards (`user|admin|ops`).
* KYC submit (multipart), status, admin approve/reject in Jinja2.
* Media storage under `./media`, relative path policy.
* **DoD:**`POST /auth/register`, `/auth/verify-otp`, `/kyc/submit`, `/admin/kyc`. Admin page shows queue & approve action.
  **F:**
* Flutter project, theme, routing, Dio client, JWT storage, Riverpod/BLoC.
* Auth screens (register/OTP login), Profile skeleton, KYC upload form (CNIC/passport + selfie), file pick & compress.
* Urdu/English string map; PKR currency pipe.
* **DoD:** Login + KYC submission works E2E; admin can approve; profile shows KYC status.

### Sprint 2 �?" Feature A: Trips, Requests, Matching

**B:**

* Tables: `trips`, `requests`, simple rule-based `GET /matching/suggest`.
* Read endpoints with filters (origin, dest, date windows).
* **DoD:** CRUD+search for trips/requests; matching returns sensible results; unit tests.
  **F:**
* Screens: Post Trip (with flight proof upload), Post Request; Listing grids; Filters; Detail views; �?oSuggest matches�?? action.
* **DoD:** Post/search/list/detail flows usable with loading/empty/error states.

### Sprint 3 �?" Feature A: Bookings + Escrow (Sim) + Handover

**B:**

* Tables: `bookings`, `escrow_tx`, `handover_events`.
* Booking lifecycle; `POST /bookings`, accept/decline; sandbox escrow hold on creation.
* Pickup/Delivery verify endpoints: OTP/QR + GPS + photos + optional `seal_id`.
* Admin escrow actions (release/refund) in Jinja2 Booking detail.
* **DoD:** Happy path demo: Trip+Request �+' Booking �+' Pickup OTP �+' Delivery OTP �+' Admin Release.
  **F:**
* Booking screens: create, accept/decline; OTP scan/generate; attach photos; GPS capture.
* Visual timeline for Booking with badges (HOLD, PICKED, DELIVERED, CLOSED).
* **DoD:** Full traveler/buyer handover flow works; QR scanning reliable on low-light.

### Sprint 4 �?" Feature B: Marketplace (Listings, Offers, Meetups)

**B:**

* Tables: `market_listings`, `market_offers`, `market_meetups`; Offer state machine (sent�+'countered�+'accepted/declined; withdraw by owner anytime before acceptance).
* Search: query, category, price bounds, optional lat/long radius; FTS5 optional.
* Optional OTP �?omeetup confirm�?? (record only). `mark_sold` (seller-only).
* **DoD:** Offer threads visible in Admin; listing moderation flag/unflag; proper 4xx on illegal transitions.
  **F:**
* Screens: Marketplace grid, filters, detail, create listing (camera & gallery), offer thread with counter/accept/decline/withdraw; create/confirm meetup OTP; mark sold; **always-visible disclaimer**.
* **DoD:** Buyer�+'Offer�+'Counter�+'Accept�+'Meetup Confirm�+'Seller Mark Sold; reviews prompt.

### Sprint 5 �?" Reviews, Chat, AI (Read-only)

**B:**

* `reviews` table; posting rules tied to delivered/closed (A) or sold (B).
* Lightweight chat per booking/listing (WebSocket optional, else long-poll).
* AI micro-app: FAQ map, `policy_flags`, read-only tools (`get_booking_status`, `list_my_trips/requests`, `search_market_listings`, `get_offers_for_my_listing`).
* **DoD:** AI answers only from FAQ/tools; refuses writes or legal advice; returns user-owned data only.
  **F:**
* Reviews UI; chat threads; AI chat view with command chips (e.g., �?oShow my bookings�??).
* **DoD:** AI shows booking status for logged user; policy advisory shows (e.g., lithium batteries high risk).

### Sprint 6 �?" Polish, Hardening, Docs, Demo Script

**B:**

* Rate-limit sensitive routes; audit logging for critical actions; error normalization; backup scripts.
* Admin dashboard counts & queues; feature flags toggles.
* **DoD:** CI passing; seed script; backup/restore tested; Admin pages presentable.
  **F:**
* Skeleton loaders, shimmer; input masks (PKR, phone); Urdu RTL tolerance; empty states art.
* Viva demo path bookmarked; crash-free with basic analytics (screen hits).
* **DoD:** Smooth 8�?"12 min demo path recorded.

---

## 4) API Contracts (Selected, Final)

> Base URL: `/` (FastAPI). Auth: `Authorization: Bearer <JWT>`. All timestamps ISO-8601. Currency default `PKR`. **Validation:** title 3�?"80 chars, description �% 2000, price �%� 0.

### Auth & KYC

* `POST /auth/register {email, phone?}` �+' 200 (dev prints OTP)
* `POST /auth/verify-otp {email, otp}` �+' `{access_token, roles}`
* `POST /kyc/submit` (multipart: `doc_type`, files, `selfie`) �+' `{status:"pending"}`
* `GET /kyc/status` �+' `{status}`

### Feature A �?" Trips/Requests/Matching/Bookings/Handover/Escrow

* `POST /trips``{origin_airport, dest_airport, date, capacity_kg, flight_proof_path?}`
* `GET /trips?origin=&dest=&date=`
* `POST /requests``{product_name, specs_json?, target_price, dest_city, weight_kg, window_start, window_end, declaration_path?}`
* `GET /requests?...`
* `GET /matching/suggest?tripId=�?�|requestId=�?�`
* `POST /bookings``{trip_id, request_id}` �+' `{id, status:"HOLD"}`
* `POST /bookings/{id}/accept|decline`
* `POST /bookings/{id}/pickup/verify``{otp|qr, gps, photos_paths[], seal_id?}`
* `POST /bookings/{id}/delivery/verify``{otp|qr, gps, photos_paths[], seal_id?}`
* `POST /admin/escrow/{bookingId}/release|refund`*(admin)*

### Feature B �?" Marketplace (OLX-style, **no escrows**)

* `POST /market/listings``{title, description, photos_paths[], category, condition, location_text, latitude?, longitude?, ask_price, currency?, contact_pref?}`
* `GET /market/listings?query=&location=&radius_km=&category=&min=&max=&status=ACTIVE`
* `GET /market/listings/{id}`
* `POST /market/listings/{id}/offer``{amount, message}`
* `POST /market/offers/{offer_id}/counter``{amount, message}`
* `POST /market/offers/{offer_id}/accept` | `/decline` | `/withdraw`
* `POST /market/meetups``{listing_id, place_text, scheduled_ts}` �+' `{otp*: dev only}`
* `POST /market/meetups/{id}/confirm``{otp}`
* `POST /market/listings/{id}/mark_sold``{offer_id?, note?}`

### Shared

* `POST /reviews``{target_type:'booking'|'market', target_id, reviewee_id, rating(1..5), comment?}`
* `GET /me` �+' profile incl. `rating_avg`, `kyc_status`
* `GET /media/{path}` �+' static (nginx recommended)

**HTTP codes:** 400 invalid/illegal transition, 401 JWT missing/invalid, 403 not owner, 404 not found.

*(The full model fields/indexes and cURL cheatsheet are already defined in your backend tech doc.)*

---

## 5) Database (SQLite) �?" Production-MVP Snapshot

* **Core A:**`users`, `kyc_profiles`, `trips`, `requests`, `bookings`, `escrow_tx`, `handover_events`
* **Marketplace B:**`market_listings`, `market_offers`, `market_meetups`
* **Trust/Ops:**`reviews`, `audit_logs`, `feature_flags`
* **AI (read-only):**`policy_flags`, `ai_sessions`, `ai_messages`, `ai_feedback`

> Keep JSON blobs as TEXT (stringified). Add indexes on `market_listings(status, category, ask_price)` and `(latitude, longitude)`; optionally FTS5 virtual table for listings.

---

## 6) State Machines & Rules (Authoritative)

### Bookings (A)

`REQUESTED �+' HOLD �+' PICKED_UP �+' DELIVERED �+' CLOSED`*(or*`CANCELLED/REFUNDED`)\*

* `HOLD` upon booking creation (sim escrow).
* OTP pickup/delivery create immutable `handover_events`.
* `CLOSED` only after admin `escrow:release`.
* Disputes module (A only) can pause release.

### Offers (B)

`sento �+' countered �+' accepted | declined` with **withdraw** allowed by offer owner any time pre-accept.

* Only **seller** can counter/accept/decline; buyer can **withdraw**.
* On **accepted**, **lock** new offers (soft lock) until seller marks **Sold** or re-opens.
* Payment & delivery **off-platform**; OTP meetup is optional record.

### Listings (B)

`ACTIVE �+' SOLD | HIDDEN | FLAGGED`

* Seller-only `mark_sold`; Admin can set `FLAGGED` (hide from search).
* One active offer per user per listing (new offer auto-withdraws previous if still pending).

---

## 7) Edge-Case Playbooks (Both Agents Must Handle)

1. **OTP issues (Pakistan telcos):** allow 3 attempts; 30s resend; numeric 6-digit; store hash+salt; throttle by IP+email.
2. **Media upload on poor networks:** chunk or show retry; compress to �% 1600px long edge; EXIF stripped.
3. **GPS spoof/denied:** require location permission; if denied, allow manual location text but label event `gps_unverified`.
4. **Offer storming:** enforce �?oone active offer per user per listing�??; 429 on spam (slowapi).
5. **Listing moderation:** admin can `FLAG` to hide; seller sees reason; audit log entry.
6. **Escrow disputes (A):** auto-freeze release; Admin UI shows timeline & attachments.
7. **SQLite write locks:** use short transactions; WAL mode; backoff & retry (50�?"100 ms jitter).
8. **Offline UX:** queue non-idempotent actions in app cache; show �?oPending sync�?݃??; retry on connectivity.
9. **Timezones:** store UTC in DB; display local in app (Asia/Karachi).
10. **Dual-account abuse:** surface rating history; throttle offers by fresh accounts.
11. **Meetup OTP reuse:** single-use; store `confirmed_ts`; subsequent confirms 400.
12. **Images with faces/PII:** avoid showing other users�?T documents in client; admin-only viewers in Jinja2.

---

## 8) Frontend (Agent-F) �?" Step-by-Step Implementation Guide

1. **Project boot & theming**
   * Create Flutter app, set light/dark themes; Typography friendly to Urdu/English; number/currency formatters (PKR).
   * Add packages: `dio`, `riverpod`/`bloc`, `go_router`, `shared_preferences`, `image_picker`, `qr_code_scanner`, `geolocator`, `permission_handler`.
2. **Core services**
   * `AuthService` (OTP register/verify, token storage/interceptor)
   * `ApiClient` with Dio, base URL, retry interceptor (exponential backoff), 401 handler (token refresh or relogin).
   * `MediaService` (image compression �+' upload �+' returns relative path).
   * `LocationService` (permission �+' coordinate �+' reverse text if needed).
3. **State & routing**
   * Feature modules: `auth`, `profile`, `trips`, `requests`, `matching`, `booking`, `handover`, `marketplace`, `offers`, `meetups`, `reviews`, `chat`, `ai`.
   * Each module: `Repository �+' Notifier/Cubit �+' Screens/Widgets`.
   * Global error boundary & SnackBar/toast utility.
4. **Screens (must-have)**
   * Auth (register/OTP), Profile+KYC, Trips (create/list/detail), Requests (create/list/detail), Matching suggestions, Booking flow, Handover (OTP/QR scan, camera, GPS), Marketplace (grid/filter/detail/create), Offers thread (with bargain actions), Meetup OTP (create/confirm), Mark Sold, Reviews, Chat, AI (read-only).
   * Universal **disclaimer banner** on Marketplace views.
5. **Accessibility & resilience**
   * Large tap targets; explicit errors under fields; skeleton loaders; connectivity banner; retry buttons; empty states.
   * All forms validate on blur; numeric keyboards for OTP/price/weight; Urdu label support.
6. **Testing (golden rules)**
   * Widget tests for form validators; integration tests mocking Dio with canned JSON; offline queue test; QR+camera permission flows.
7. **Delivery**
   * Produce one release build (Android APK/AAB) for viva; record E2E demo scenario.

**Definition-of-Done (Agent-F):** All error states have visible UI; every network call has loading & retry; back/forward navigation never loses critical form data; min 10 happy-path and 10 edge-path manual cases pass.

---

## 9) Backend (Agent-B) �?" Step-by-Step Implementation Guide

1. **Scaffold & config**
   * Repo per provided layout: `server/app/{core,schemas,repos,auth,users,kyc,...,marketplace,admin}` with `main.py`.
   * `.env` with `DB_URL=sqlite:///./sharego.db`, `JWT_SECRET`, `MEDIA_ROOT`, flags.
   * Alembic migrations creating all tables as specified. WAL mode enabled on startup.
2. **Security & deps**
   * JWT bearer dependency, role guard decorator; bcrypt hashing; CORS for mobile.
   * Slowapi for rate-limits on `/auth/*`, `/market/offers/*`.
3. **Modules in order (with tests)**
   * Auth/KYC/Media �+' Trips/Requests/Matching �+' Bookings/Escrow/Handover �+' Marketplace (Listings/Offers/Meetups) �+' Reviews �+' Chat �+' AI read-only tools.
   * Each router has **Pydantic** request/response models and **sqlmodel** repos; strict 400/403/404 mapping for illegal transitions.
4. **Admin (Jinja2)**
   * Pages: Dashboard counts, KYC queue, Booking detail (timeline, release/refund buttons), Market Listings (photos, offer history), Config Flags.
   * Sign in as `admin` role only.
5. **Observability & ops**
   * Structured logs (JSON) with request ID; `audit_logs` on accept/decline/counter, mark\_sold, escrow actions, admin flags.
   * Nightly backup script (db + media), restore script; log rotation.
   * Seed script generating demo users, trips, requests, listings, and a happy-path scene.
6. **Testing**
   * Pytest unit tests for validators and state transitions (booking/offer lifecycles).
   * Integration tests with `TestClient`, in-memory sqlite, monkeypatched OTP generator.
   * cURL/Postman collection exported.

**Definition-of-Done (Agent-B):** All state machines reject illegal transitions with precise 400; all owner checks 403 as expected; image uploads are validated and stored; admin actions visible in audit logs; API doc (`/docs`) clean.

*(Field lists, endpoints and cURL snippets mirror your backend doc and are binding.)*

---

## 10) AI Assistant �?" Operating Instructions

* **System prompt (short):** �?oYou are ShareGo�?Ts assistant. Answer only about ShareGo features, escrow steps, OTP/QR handovers, OLX-style marketplace rules (**no auctions**), and safety/legal advisories from FAQs/policy flags. Use **read-only DB tools** to show the user�?Ts own statuses. Do **not** perform actions or give legal advice. ShareGo does not handle marketplace delivery or payments.�??
* **Allowed tools (read-only):**
  `get_booking_status`, `list_my_trips`, `list_my_requests`, `search_market_listings`, `get_offers_for_my_listing`, `policy_flags(product, route)`.
* **Refusals:** Any write action; legal advice; internet queries; PII of other users.
* **PII:** Mask emails/phones except user�?Ts own.
* **Rate limit:** e.g., 20 RPM.

*(Matches your AI section and no-RAG rule.)*

---

## 11) QA: Test Matrix (Minimum)

**Unit (Backend):**

* Auth: OTP throttle, invalid OTP, token expiry.
* KYC: bad MIME, oversize file, resubmit after reject.
* Listings: invalid title/price; flag/hide; owner-only edits.
* Offers: illegal accept by non-seller; multiple offers from same buyer; withdraw after counter; accept twice.
* Meetups: confirm wrong OTP; confirm twice; unrelated buyer.
* Bookings: pickup without HOLD; delivery before pickup; double release; refund path.
* Reviews: posting before eligibility.

**Integration (E2E):**

* A: Trip+Request �+' Booking �+' Pickup OTP �+' Delivery OTP �+' Admin Release �+' Reviews.
* B: Listing �+' Offer �+' Counter �+' Accept �+' Meetup Confirm �+' Mark Sold �+' Reviews.
* Admin moderation hides FLAGGED listing from search.

**Frontend manual/UAT:**

* Offline upload retry; QR scanner in low light; Urdu labels; low-end device memory (image compress).
* Accessibility contrast & font scaling.

---

## 12) Runbooks

**Local run**

```bash
# Backend
cd server
pip install -r requirements.txt
alembic upgrade head
uvicorn app.main:app --reload --port 8000

# AI (optional micro-app)
cd ai
pip install -r requirements.txt
uvicorn main:app --reload --port 5005

# Flutter
cd mobile
flutter pub get
flutter run
```

**Backup/restore**

* Nightly copy `sharego.db` + `./media/` to dated folder.
* Restore: stop app �+' replace files �+' start app �+' run integrity check.

**Admin bootstrap**

* Create first admin manually via script (set `roles=['admin']`).
* Protect `/admin` behind role check.

**Deployment (MVP)**

* Uvicorn behind nginx; serve `/static` and `/media` via nginx.
* Enable HTTPS; set CORS origins to app domain.
* WAL mode for SQLite; filesystem with safe permissions.

---

## 13) UX Copy & Disclaimers (ready to paste)

* **Marketplace Legal:**
  �?oMarketplace transactions are **peer-to-peer**. ShareGo does **not** provide delivery, courier, or payment services for Marketplace deals. Always verify the other party and follow local laws.�??
* **Escrow Scope:**
  �?oEscrow applies **only** to Personal Shopping bookings (Feature A). Marketplace has **no escrow**.�??
* **OTP Notice:**
  �?oKeep your OTP private. Share it only at the agreed meetup or delivery moment.�??

---

## 14) Deliverables Checklist (Per Agent)

**Agent-B (Backend) �?" Ship List**

* [ ]  Alembic migrations for all tables
* [ ]  `/docs` clean & accurate
* [ ]  Postman/cURL collection
* [ ]  Admin pages: KYC, Bookings, Market moderation, Flags
* [ ]  Seed & backup scripts
* [ ]  Pytest green (unit+integration)
* [ ]  Log redaction & audit logs present

**Agent-F (Frontend) �?" Ship List**

* [ ]  APK build + E2E screen capture
* [ ]  All screens implemented with loaders & errors
* [ ]  Image compress & retry; GPS & QR flows
* [ ]  Urdu/English strings
* [ ]  Basic analytics events
* [ ]  20-case UAT sheet ticked

---

## 15) Viva Demo Script (8�?"12 min)

1. Login �+' KYC submit �+' **Admin approves** (Jinja2).
2. **Feature A:** Post Trip + Post Request �+' Matching �+' Booking (escrow hold) �+' Pickup OTP (QR) + photos + GPS �+' Delivery OTP �+' **Admin Release** �+' Reviews.
3. **Feature B:** Create Listing �+' Second user sends Offer �+' Counter �+' Accept �+' Create Meetup OTP �+' Confirm OTP at meetup �+' Seller **Mark Sold** �+' Reviews; **disclaimer visible**.
4. **AI:** �?oWhat is escrow?�??, �?oShow my bookings�??, �?oAre power banks allowed?�?? (policy advisory), �?oDoes ShareGo deliver marketplace items?�?? �+' **AI says no**; read-only proofs.

---

## 16) Acceptance Criteria �?" Production-MVP

* **Correctness:** All state machines enforce legal transitions with clear errors.
* **Security:** Only owners mutate their data; uploads validated; JWT & rate-limits in place.
* **Resilience:** App usable under 2G/3G; retries and fallbacks work.
* **Clarity:** Marketplace disclaimer present on all relevant screens; no auction/bidding UI anywhere.
* **Demo-able:** End-to-end flows (A&B) run consistently on seeded data.

---

### Appendix A �?" Canonical References (your docs)

* Project proposal overview & goals.
* Backend technical documentation (schema, endpoints, cURL).
* FYP report (SRS, use-cases, diagrams).

---

**That�?Ts it.** Assign Agent-B and Agent-F to this `AGENTS.md`, split sprints as above, and you�?Tll have a clean, OLX-style marketplace with traveler escrow flow, a simple AI helper, and a solid FastAPI+Flutter stack �?" tuned for Pakistan�?Ts realities.
