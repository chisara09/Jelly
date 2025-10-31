# 🏀 App Screens Overview

Your app includes **12 total screens**, divided into two main categories:  
**Authentication** (user access) and **Main App** (core functionality).  
General updates are summarized at the end.

---

## 🔐 Authentication Screens

1. **WelcomeView** — Initial landing screen  

2. **LoginView** — User login screen  

3. **SignUpView** — User registration screen  

---

## 🏆 Main App Screens

4. **HomeView** — Main dashboard / user stats hub  
   > - Clicking any **stat box** opens a screen showing **previous matches**, including stats *before* and *after* each game.  
   > - **Create Challenge** button leads to the **NewChallengeView**, where users can **search for players** and set up a match.  
   > - Include **nearby players** and **recent opponents** for quick selection.

5. **ProfileView** ✅ — Current user's personal profile  
   > - ✅ Clicking on any **stat box** navigates to a **history view** (previous matches + outcomes).  
   > - ✅ Remove about section.
   > - **Status**: COMPLETE - See `/dev-files/updates/PROFILEVIEW-UPDATES-COMPLETE.md`

6. **FindPlayersView** ✅ — Map and nearby player discovery  
   > - ✅ Show **courts as small dots** on the map for clarity.  
   > - ✅ Clicking a court should open **Google Maps** with that location pinned.
   > - **Status**: COMPLETE - See `/dev-files/updates/FINDPLAYERSVIEW-UPDATES-COMPLETE.md`  

7. **LeaderboardView** ✅ — Player rankings and stats overview  
   > - ✅ Add a **toggle button** for **local leaderboard view** to see nearby players' ratings.  
   > - ✅ Include global leaderboard by default.
   > - **Status**: COMPLETE - See `/dev-files/updates/LEADERBOARDVIEW-UPDATES-COMPLETE.md`  

8. **ChatView** ✅ — Messaging and chat system  
   > - ✅ Displays all user conversations.  
   > - ✅ Add a **chat icon to the navigation bar** for quick access.  
   > - ✅ Include unread message indicators.
   > - **Status**: COMPLETE - See `/dev-files/updates/CHATVIEW-UPDATES-COMPLETE.md`

9. **GameDetailsView** — Match summary and analytics  
   > - Show player names, score breakdown, and match date/time.  
   > - Include post-match ratings and stat comparison.

10. **NewChallengeView** — Challenge creation screen  
   > - When selecting a court, give players the option to select either of their homecourts and a searchbar for other courts. 

11. **ConfirmScoreView** — Final score submission  
   > - Both players confirm final result.  
   > - Display pending confirmation if only one side submits.  
   > - Lock record once confirmed.

12. **OtherPlayerProfileView** — View another user’s profile  
   > - Show player’s rating, match history, and mutual games.  
   > - Option to **send challenge** or **message** directly.

---

## ⚙️ General App-Wide Updates

- **Remove player levels** (e.g., “Advanced,” “Intermediate”).  
  → Use **numerical ratings** exclusively to represent skill.