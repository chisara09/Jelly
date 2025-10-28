# 1v1 Hoops — Requirements Document

## 1. App Overview
A simple iPhone app for people who play one-on-one basketball. Players can find others nearby, set up games, report scores, and climb a community leaderboard. It’s for anyone who wants friendly competition and a clear way to track wins and losses.

---

## 2. Main Goals
1. Show a fair, easy-to-read leaderboard.
2. Let users find and challenge nearby players.
3. Make it simple to set up a game: time, place, rules.
4. Record the final score with proof (both players confirm).
5. Track player stats over time (wins, losses, streaks).
6. Help users chat and plan games safely in-app.
7. Keep data even if the app closes and comes back later.

---

## 3. User Stories (US-001, US-002, …)
- **US-001**: As a user, I want to make an account so that my wins and losses are saved.  
- **US-002**: As a user, I want to create a player profile so that others know who I am.  
- **US-003**: As a user, I want to share my location so that I can see nearby players.  
- **US-004**: As a user, I want to search for players by name or park so that I can challenge them.  
- **US-005**: As a user, I want to send a challenge so that we can set up a 1v1 game.  
- **US-006**: As a user, I want to pick a court, date, and time so that the game details are clear.  
- **US-007**: As a user, I want to chat with the other player so that we can confirm rules.  
- **US-008**: As a user, I want reminders before the game so that I don’t forget.  
- **US-009**: As a user, I want to report the score after the game so that the result is recorded.  
- **US-010**: As a user, I want the other player to confirm the score so that it’s fair.  
- **US-011**: As a user, I want to see a leaderboard so that I know who’s on top.  
- **US-012**: As a user, I want to see my stats (wins, losses, streak) so that I can track progress.  
- **US-013**: As a user, I want to block or report someone so that I feel safe.  
- **US-014**: As a user, I want to edit or delete my account so that I have control.  
- **US-015**: As a user, I want dark mode so that it’s easy on my eyes at night.  

---

## 4. Features (F-001, F-002, …)
- **F-001: Sign Up / Login**  
  - Lets a user create an account or sign in.  
  - Appears on first launch or when logged out.  
  - If wrong: Show “Check your email or password.”  

- **F-002: Profile**  
  - Shows name, photo, home court, bio, record, streak.  
  - Appears on Profile tab.  
  - If wrong: Show “Couldn’t load profile.”  

- **F-003: Location + Nearby Players**  
  - Lists players and courts near you.  
  - Appears on “Find Players” tab.  
  - If wrong: Show “Turn on Location.”  

- **F-004: Search & Filters**  
  - Search players by name/court; filter by skill or distance.  
  - Appears on “Find Players.”  
  - If wrong: Show “No matches found.”  

- **F-005: Create Challenge**  
  - Send a challenge with court, date, rules.  
  - Appears on a player profile or “New Game.”  
  - If wrong: Show “Couldn’t send.”  

- **F-006: Game Chat**  
  - Private messages for a planned game.  
  - Appears after a challenge is created.  
  - If wrong: Show “Message not sent.”  

- **F-007: Reminders & Notifications**  
  - Alerts for new challenges, chat, game times.  
  - Appears as in-app banners/alerts.  
  - If wrong: Show “Notifications off.”  

- **F-008: Record Score**  
  - Enter final score and winner.  
  - Appears after game time.  
  - If wrong: Show “Couldn’t save score.”  

- **F-009: Score Confirmation**  
  - Opponent confirms or disputes result.  
  - Appears after score is submitted.  
  - If wrong: Show “Couldn’t send confirmation.”  

- **F-010: Dispute Flow**  
  - If scores don’t match, mark “No result.”  
  - Appears on mismatch.  
  - If wrong: Show “Couldn’t resolve.”  

- **F-011: Leaderboard**  
  - Ranks players by wins, rating, streak.  
  - Appears on Leaderboard tab.  
  - If wrong: Show “Leaderboard offline.”  

- **F-012: My Stats**  
  - Shows personal record, streak, recent games.  
  - Appears on Profile and Home.  
  - If wrong: Show “Stats not available.”  

- **F-013: Safety Tools**  
  - Block/report users.  
  - Appears in chat and profiles.  
  - If wrong: Show “Couldn’t update.”  

- **F-014: Settings**  
  - Edit account, notifications, dark mode.  
  - Appears on Profile gear icon.  
  - If wrong: Show “Save failed.”  

---

## 5. Screens (S-001, S-002, …)
- **S-001: Welcome / Login** – First screen with “Sign Up,” “Log In.”  
- **S-002: Sign Up** – Form with name, email, password.  
- **S-003: Home** – Quick stats, upcoming games, “Create Challenge.”  
- **S-004: Find Players** – Map/list, search, filters, player cards.  
- **S-005: Player Profile (Other User)** – Shows bio, record, “Challenge” button.  
- **S-006: New Challenge** – Court, date, rules, “Send.”  
- **S-007: Game Details** – Opponent, court, date/time, chat, “Record Score.”  
- **S-008: Chat** – Messages, input box, block/report.  
- **S-009: Record Score** – Fields for final score and winner.  
- **S-010: Confirm Score** – Result with “Confirm” or “Dispute.”  
- **S-011: Leaderboard** – Ranked list with tabs for rating, wins, streak.  
- **S-012: My Profile** – My photo, record, streak, recent games.  
- **S-013: Settings** – Notifications, dark mode, account controls.  

---

## 6. Data (D-001, D-002, …)
- **D-001: User Account** – email, password, created date.  
- **D-002: Player Profile** – name, photo, bio, home court.  
- **D-003: Location** – last known city/coordinates.  
- **D-004: Court List** – courts with name, address, map pin.  
- **D-005: Game** – opponent IDs, court, date/time, rules, status.  
- **D-006: Score** – winner, loser, points, confirm/dispute.  
- **D-007: Stats** – wins, losses, rating, streak, history.  
- **D-008: Leaderboard Snapshot** – cached top players.  
- **D-009: Messages** – chat messages (text + time).  
- **D-010: Safety** – blocked users, reports.  
- **D-011: Settings** – notifications, dark mode, units.  

---

## 7. Extra Details
1. Needs internet for login, finding players, saving scores.  
2. Offline: show cached leaderboard, profile.  
3. Permissions: Location, Notifications, optional photo upload.  
4. Dark Mode: Yes, match system setting + manual toggle.  
5. Safety: Block/report, filter bad words.  
6. Fair play: Both players confirm score; disputes = “No result.”  
7. First version: iPhone only.  

---

## 8. Build Steps (B-001, B-002, …)
- **B-001:** Set up project. Build S-001, S-002 with F-001 (Login/Sign Up). ✅  
- **B-002:** Build S-003 (Home). Add D-005 placeholder. ✅  
- **B-003:** Build S-012 (My Profile) with F-002 (Profile). Save D-002. ✅  
- **B-004:** Add Location (F-003). Build S-004 (Find Players). Save D-003/D-004. ✅  
- **B-005:** Build S-005 + S-006 for challenges (F-005). Save D-005. ✅  
- **B-006:** Build S-007 + S-008 with chat (F-006). Save D-009. ✅  
- **B-007:** Add notifications (F-007). ✅  
- **B-008:** Build S-009 + S-010 with scores (F-008, F-009, F-010). Save D-006. ✅  
- **B-009:** Build leaderboard (S-011) with F-011. Save D-008. ✅  
- **B-010:** Add S-013 (Settings) with F-014 + safety tools F-013. Save D-010/D-011. ✅  
- **B-011:** Add error states for all features. ✅  
- **B-012:** Test: two users → challenge → chat → record score → confirm → leaderboard update. ✅  

**Status:** All build steps completed. See `instructions/B-012-Test-Instructions.md` for how to run the end-to-end test.

---
