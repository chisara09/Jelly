# Key Development Steps
- Environment setup
- Build basic UI using dummy data
- Data structure and backend
- Connect both UI and backend
- UI polishing
- Deployment & testing

## Firestore Dummy Data
- Install tooling once: `npm install`
- Start emulators (optional): `firebase emulators:start`
- Seed data (emulator): `npm run seed:firestore -- --emulator --fresh`
- Seed data (live project): `GOOGLE_APPLICATION_CREDENTIALS=/path/to/serviceAccount.json npm run seed:firestore -- --project jelly-bde6f --fresh`
- Preview changes without writing: `npm run seed:firestore -- --dry-run`