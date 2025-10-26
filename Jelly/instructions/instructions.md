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
  - **What it does:** Lets a user create an account (email + password) or sign in.  
  - **When it appears:** On first launch or when logged out.  
  - **If something goes wrong:** Show “Check your email or password.” Offer “Try again.”  

- **F-002: Profile**  
  - **What it does:** Shows name, photo (optional), home court, bio, record, streak.  
  - **When it appears:** From the tab bar (“Profile”) or after sign up.  
  - **If something goes wrong:** Show “Couldn’t load profile.” Add a “Reload” button.  

- **F-003: Location + Nearby Players**  
  - **What it does:** Uses location to list players and courts near you.  
  - **When it appears:** On the “Find Players” tab.  
  - **If something goes wrong:** Show “Turn on Location in Settings.” Allow manual court search.  

- **F-004: Search & Filters**  
  - **What it does:** Search players by name/court; filter by skill or distance.  
  - **When it appears:** On “Find Players.”  
  - **If something goes wrong:** Show “No matches found.” Suggest clearing filters.  

- **F-005: Create Challenge**  
  - **What it does:** Send a challenge with court, date, time, and rules.  
  - **When it appears:** From a player profile or “New Game” button.  
  - **If something goes wrong:** Show “Couldn’t send. Try again.” Keep the form filled.  

- **F-006: Game Chat**  
  - **What it does:** 1-to-1 messages for a planned game.  
  - **When it appears:** After a challenge is created.  
  - **If something goes wrong:** Show “Message not sent.” Allow resend.  

- **F-007: Reminders & Notifications**  
  - **What it does:** Notifies users of new challenges, chat messages, and upcoming games.  
  - **When it appears:** Background alerts and in-app banners.  
  - **If something goes wrong:** Show “Notifications are off.” Link to Settings.  

- **F-008: Record Score**  
  - **What it does:** After the game, either player enters final score and winner.  
  - **When it appears:** On the game details screen after game time passes.  
  - **If something goes wrong:** Show “Couldn’t save score.” Keep inputs for retry.  

- **F-009: Score Confirmation**  
  - **What it does:** Other player confirms or disputes result.  
  - **When it appears:** After a score is submitted.  
  - **If something goes wrong:** Show “Couldn’t send confirmation.” Retry later.  

- **F-010: Dispute Flow**  
  - **What it does:** If scores don’t match, re-enter or mark as “No result.”  
  - **When it appears:** When there’s a mismatch.  
  - **If something goes wrong:** Show “Couldn’t resolve.” Escalate to “No result.”  

- **F-011: Leaderboard**  
  - **What it does:** Ranks players by rating, wins, or streak.  
  - **When it appears:** On the “Leaderboard” tab.  
  - **If something goes wrong:** Show “Leaderboard offline.” Show last known list.  

- **F-012: My Stats**  
  - **What it does:** Shows personal record, streak, recent games.  
  - **When it appears:** On “Profile” and “Home.”  
  - **If something goes wrong:** Show “Stats not available.” Try again.  

- **F-013: Safety Tools**  
  - **What it does:** Block/report users. Hides chats/challenges from blocked users.  
  - **When it appears:** In chat and on profiles.  
  - **If something goes wrong:** Show “Couldn’t update safety setting.”  

- **F-014: Settings**  
  - **What it does:** Edit account, notifications, dark mode, sign out, delete account.  
  - **When it appears:** From “Profile” gear icon.  
  - **If something goes wrong:** Show “Save failed.” Keep old settings.  

---

## 5. Screens (S-001, S-002, …)

- **S-001: Welcome / Login**  
  - **What’s on it:** App name, logo, “Sign Up,” “Log In.”  
  - **How to get here:** First open or after sign out.  

- **S-002: Sign Up**  
  - **What’s on it:** Name, email, password, “Create Account.”  
  - **How to get here:** Tap “Sign Up” on S-001.  

- **S-003: Home**  
  - **What’s on it:** Quick stats, upcoming games, “Create Challenge” button.  
  - **How to get here:** After login (tab 1).  

- **S-004: Find Players**  
  - **What’s on it:** Map/list, search bar, filters, player cards.  
  - **How to get here:** Tab 2.  

- **S-005: Player Profile (Other User)**  
  - **What’s on it:** Photo, bio, record, “Challenge,” “Message.”  
  - **How to get here:** Tap a player from S-004.  

- **S-006:
