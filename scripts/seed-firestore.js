#!/usr/bin/env node

/**
 * Seed Firestore with dummy data for Jelly.
 *
 * Supports both the Firebase emulator suite and live projects.
 * For production projects, provide credentials via GOOGLE_APPLICATION_CREDENTIALS.
 *
 * Usage examples:
 *   node scripts/seed-firestore.js --emulator --fresh
 *   node scripts/seed-firestore.js --project jelly-bde6f --fresh
 *
 * Flags:
 *   --project <id>   Override the Firebase project ID (default: jelly-bde6f or env GCLOUD_PROJECT)
 *   --emulator       Force emulator mode (skips credential lookup)
 *   --fresh          Delete existing seed collections before inserting data
 *   --dry-run        Log the data that would be written without touching Firestore
 */

const admin = require('firebase-admin');
const { parseArgs } = require('node:util');
const { randomUUID } = require('node:crypto');

const args = parseArgs({
  options: {
    project: { type: 'string' },
    emulator: { type: 'boolean', default: false },
    fresh: { type: 'boolean', default: false },
    dryRun: { type: 'boolean', default: false }
  }
});

const projectId =
  args.values.project ||
  process.env.GCLOUD_PROJECT ||
  process.env.GOOGLE_CLOUD_PROJECT ||
  'jelly-bde6f';

const useEmulator =
  args.values.emulator ||
  process.env.FIRESTORE_EMULATOR_HOST != null ||
  process.env.USE_FIREBASE_EMULATOR === 'YES';

function initFirebase() {
  if (args.values.dryRun) {
    console.log('🔥 Running in dry-run mode. No data will be written.');
    return;
  }

  if (useEmulator) {
    if (!process.env.FIRESTORE_EMULATOR_HOST) {
      // Default host for emulator if not already set
      process.env.FIRESTORE_EMULATOR_HOST = 'localhost:8080';
    }
    console.log(`🔥 Connecting to Firestore emulator at ${process.env.FIRESTORE_EMULATOR_HOST}`);
    admin.initializeApp({ projectId });
  } else {
    console.log(`☁️  Connecting to Firebase project "${projectId}"`);
    try {
      admin.initializeApp({
        credential: admin.credential.applicationDefault(),
        projectId
      });
    } catch (error) {
      console.error('Failed to initialize Firebase Admin SDK. Make sure GOOGLE_APPLICATION_CREDENTIALS is set.');
      throw error;
    }
  }
}

const timestamp = () => admin.firestore.Timestamp.now();
const fromDate = (date) => admin.firestore.Timestamp.fromDate(date);

function buildCourts() {
  return [
    {
      id: 'rucker-park',
      name: 'Rucker Park',
      address: '155th St & Frederick Douglass Blvd, New York, NY 10039',
      latitude: 40.8276,
      longitude: -73.9442
    },
    {
      id: 'the-cage',
      name: 'The Cage',
      address: '6th Ave & W 4th St, New York, NY 10014',
      latitude: 40.7319,
      longitude: -74.0011
    },
    {
      id: 'west-4th-street-courts',
      name: 'West 4th Street Courts',
      address: '6th Ave & W 4th St, New York, NY 10014',
      latitude: 40.7319,
      longitude: -74.0011
    },
    {
      id: 'dyckman-park',
      name: 'Dyckman Park',
      address: 'Dyckman St & Nagle Ave, New York, NY 10040',
      latitude: 40.8653,
      longitude: -73.9265
    },
    {
      id: 'venice-beach-courts',
      name: 'Venice Beach Courts',
      address: '1800 Ocean Front Walk, Venice, CA 90291',
      latitude: 34.0492,
      longitude: -118.4694
    },
    {
      id: 'hoover-street-courts',
      name: 'Hoover Street Courts',
      address: 'Hoover St & 48th St, Los Angeles, CA 90011',
      latitude: 34.0003,
      longitude: -118.2857
    },
    {
      id: 'pan-pacific-park',
      name: 'Pan Pacific Park',
      address: '7600 Beverly Blvd, Los Angeles, CA 90036',
      latitude: 34.074,
      longitude: -118.3618
    },
    {
      id: 'chicago-state-university-courts',
      name: 'Chicago State University Courts',
      address: '9501 S Martin Luther King Dr, Chicago, IL 60628',
      latitude: 41.7209,
      longitude: -87.6068
    },
    {
      id: 'union-park',
      name: 'Union Park',
      address: '1501 W Randolph St, Chicago, IL 60607',
      latitude: 41.8847,
      longitude: -87.6644
    },
    {
      id: 'mallery-playground',
      name: 'Mallery Playground',
      address: '2600 W Thompson St, Philadelphia, PA 19121',
      latitude: 39.9811,
      longitude: -75.1653
    },
    {
      id: 'fairmount-park',
      name: 'Fairmount Park',
      address: 'Fairmount Park, Philadelphia, PA 19130',
      latitude: 39.974,
      longitude: -75.209
    },
    {
      id: 'roxbury-ymca',
      name: 'Roxbury YMCA',
      address: '285 Martin Luther King Blvd, Boston, MA 02119',
      latitude: 42.3292,
      longitude: -71.0795
    },
    {
      id: 'chastain-park',
      name: 'Chastain Park',
      address: 'Chastain Park, Atlanta, GA 30342',
      latitude: 33.8749,
      longitude: -84.3794
    },
    {
      id: 'peachtree-battle-courts',
      name: 'Peachtree Battle Courts',
      address: '2612 Peachtree Rd NW, Atlanta, GA 30305',
      latitude: 33.8431,
      longitude: -84.3919
    },
    {
      id: 'south-beach-courts',
      name: 'South Beach Courts',
      address: 'Ocean Dr & 6th St, Miami Beach, FL 33139',
      latitude: 25.7753,
      longitude: -80.13
    },
    {
      id: 'fonde-recreation-center',
      name: 'Fonde Recreation Center',
      address: '110 Sabine St, Houston, TX 77007',
      latitude: 29.7594,
      longitude: -95.3617
    },
    {
      id: 'golden-gate-park-courts',
      name: 'Golden Gate Park Courts',
      address: 'Golden Gate Park, San Francisco, CA 94117',
      latitude: 37.7694,
      longitude: -122.4862
    },
    {
      id: 'barry-farms',
      name: 'Barry Farms',
      address: 'Sumner Rd SE & Firth Sterling Ave SE, Washington, DC 20020',
      latitude: 38.8483,
      longitude: -76.9883
    },
    {
      id: 'green-lake-community-center',
      name: 'Green Lake Community Center',
      address: '7201 E Green Lake Dr N, Seattle, WA 98115',
      latitude: 47.6817,
      longitude: -122.3302
    },
    {
      id: 'portland-community-center',
      name: 'Portland Community Center',
      address: '740 SE 106th Ave, Portland, OR 97216',
      latitude: 45.5152,
      longitude: -122.561
    }
  ];
}

function buildPlayers(courts) {
  const bios = [
    'Lockdown defender with a deadly mid-range jumper.',
    'Streetball veteran known for flashy handles.',
    'All-around forward that crashes the boards.',
    'Sharpshooter who lives beyond the arc.',
    'Playmaker that runs the pick and roll to perfection.',
    'Defensive anchor who calls out every rotation.',
    'High-energy sixth man with a quick first step.',
    'Floor general and vocal leader on the court.',
    'Rim runner with elite athleticism.',
    'Versatile swingman who guards 1 through 4.'
  ];

  const names = [
    'Marcus Johnson',
    'Jamal Smith',
    'Darius Lee',
    'Andre Clark',
    'Kenny Brown',
    'Chris Taylor',
    'Jordan Davis',
    'Isaiah Walker',
    'Trey Williams',
    'Malik Harris'
  ];

  const players = [];
  for (let index = 0; index < names.length; index += 1) {
    const court = courts[index % courts.length];
    const latOffset = (Math.random() - 0.5) * 0.01;
    const lonOffset = (Math.random() - 0.5) * 0.01;
    const uid = randomUUID();
    const wins = Math.floor(Math.random() * 25) + 10;
    const losses = Math.floor(Math.random() * 15);
    const totalGames = wins + losses;
    const rating = 1000 + wins * 12 - losses * 5 + Math.floor(Math.random() * 60);
    const streakPool = [-3, -2, -1, 0, 1, 2, 3, 4, 5];
    const currentStreak = streakPool[Math.floor(Math.random() * streakPool.length)];
    const bestStreak = Math.max(currentStreak, Math.floor(Math.random() * 6) + 3);

    players.push({
      uid,
      name: names[index],
      email: `${names[index].toLowerCase().replace(/\s+/g, '.')}@example.com`,
      bio: bios[index],
      homeCourtID: court.id,
      photoURL: `https://api.dicebear.com/7.x/initials/svg?seed=${encodeURIComponent(names[index])}`,
      location: {
        latitude: Number((court.latitude + latOffset).toFixed(5)),
        longitude: Number((court.longitude + lonOffset).toFixed(5))
      },
      stats: {
        wins,
        losses,
        currentStreak,
        bestStreak,
        totalGames,
        rating: Number(rating.toFixed(1))
      }
    });
  }

  return players;
}

function buildGames(players, courts) {
  const now = new Date();
  const games = [
    {
      challengerIndex: 0,
      opponentIndex: 1,
      courtID: 'rucker-park',
      scheduledDate: new Date(now.getTime() + 2 * 24 * 60 * 60 * 1000),
      rules: 'First to 21 straight up',
      status: 'accepted',
      isConfirmed: false
    },
    {
      challengerIndex: 2,
      opponentIndex: 3,
      courtID: 'venice-beach-courts',
      scheduledDate: new Date(now.getTime() - 5 * 24 * 60 * 60 * 1000),
      rules: 'Best of 3 to 15',
      status: 'completed',
      challengerScore: 21,
      opponentScore: 16,
      winnerIndex: 2,
      loserIndex: 3,
      isConfirmed: true
    },
    {
      challengerIndex: 4,
      opponentIndex: 5,
      courtID: 'union-park',
      scheduledDate: new Date(now.getTime() + 7 * 24 * 60 * 60 * 1000),
      rules: 'Ones, win by 2',
      status: 'pending',
      isConfirmed: false
    },
    {
      challengerIndex: 6,
      opponentIndex: 7,
      courtID: 'south-beach-courts',
      scheduledDate: new Date(now.getTime() - 1 * 24 * 60 * 60 * 1000),
      rules: 'Make it, take it to 21',
      status: 'disputed',
      challengerScore: 19,
      opponentScore: 21,
      isConfirmed: false
    },
    {
      challengerIndex: 8,
      opponentIndex: 9,
      courtID: 'green-lake-community-center',
      scheduledDate: new Date(now.getTime() + 3 * 24 * 60 * 60 * 1000),
      rules: 'Half-court, win by 2',
      status: 'accepted',
      isConfirmed: false
    }
  ];

  return games.map((game) => {
    const id = randomUUID();
    const challenger = players[game.challengerIndex];
    const opponent = players[game.opponentIndex];
    const court = courts.find((c) => c.id === game.courtID) || courts[0];

    const base = {
      id,
      challengerID: challenger.uid,
      opponentID: opponent.uid,
      courtID: court.id,
      scheduledDate: fromDate(game.scheduledDate),
      rules: game.rules,
      status: game.status,
      isConfirmed: game.isConfirmed,
      createdAt: timestamp(),
      updatedAt: timestamp()
    };

    if (typeof game.challengerScore === 'number') {
      base.challengerScore = game.challengerScore;
    }
    if (typeof game.opponentScore === 'number') {
      base.opponentScore = game.opponentScore;
    }
    if (typeof game.winnerIndex === 'number') {
      base.winnerID = players[game.winnerIndex].uid;
    }
    if (typeof game.loserIndex === 'number') {
      base.loserID = players[game.loserIndex].uid;
    }

    return base;
  });
}

function buildMessages(games, players) {
  const messages = [];
  games.forEach((game) => {
    const challenger = players.find((p) => p.uid === game.challengerID);
    const opponent = players.find((p) => p.uid === game.opponentID);
    if (!challenger || !opponent) {
      return;
    }

    const conversation = [
      {
        sender: challenger,
        text: 'Yo, looking forward to this matchup.'
      },
      {
        sender: opponent,
        text: 'Same here! Let’s run it back from last time.'
      },
      {
        sender: challenger,
        text: 'I’ll bring the ball. See you at the court.'
      }
    ];

    conversation.forEach((entry, idx) => {
      messages.push({
        id: randomUUID(),
        gameID: game.id,
        senderID: entry.sender.uid,
        senderName: entry.sender.name,
        text: entry.text,
        timestamp: fromDate(new Date(Date.now() - (conversation.length - idx) * 60 * 60 * 1000)),
        isRead: {
          [challenger.uid]: true,
          [opponent.uid]: idx < conversation.length - 1
        }
      });
    });
  });

  return messages;
}

function buildReports(players) {
  if (players.length < 4) {
    return [];
  }

  return [
    {
      id: randomUUID(),
      reporterID: players[0].uid,
      reportedID: players[3].uid,
      reason: 'Unsportsmanlike conduct',
      description: 'Player called multiple questionable fouls and refused to shake hands.',
      status: 'pending',
      createdAt: timestamp()
    },
    {
      id: randomUUID(),
      reporterID: players[5].uid,
      reportedID: players[4].uid,
      reason: 'No-show',
      description: 'Opponent did not show up for the scheduled game.',
      status: 'resolved',
      createdAt: fromDate(new Date(Date.now() - 7 * 24 * 60 * 60 * 1000))
    }
  ];
}

function buildBlocked(players) {
  if (players.length < 2) {
    return [];
  }
  return [
    {
      blockerID: players[2].uid,
      blockedID: players[5].uid,
      createdAt: timestamp()
    }
  ];
}

async function wipeCollections(db) {
  const collections = ['courts', 'users', 'profiles', 'stats', 'games', 'messages', 'reports'];

  for (const name of collections) {
    const snapshot = await db.collection(name).get();
    if (snapshot.empty) {
      continue;
    }
    console.log(`🧹 Clearing ${snapshot.size} document(s) from "${name}"`);
    const deletions = snapshot.docs.map((doc) => doc.ref.delete());
    await Promise.all(deletions);
  }

  const blockedParents = await db.collection('blocked').get();
  for (const parent of blockedParents.docs) {
    const nested = await parent.ref.collection('blocked').get();
    const nestedDeletes = nested.docs.map((doc) => doc.ref.delete());
    await Promise.all(nestedDeletes);
    await parent.ref.delete();
  }
}

async function seed() {
  const emulatorInfo = useEmulator ? '(emulator)' : '(live project)';
  console.log(`🚀 Starting Firestore seed ${emulatorInfo}`);

  const courts = buildCourts();
  const players = buildPlayers(courts);
  const games = buildGames(players, courts);
  const messages = buildMessages(games, players);
  const reports = buildReports(players);
  const blocked = buildBlocked(players);

  if (args.values.dryRun) {
    console.dir(
      {
        projectId,
        useEmulator,
        counts: {
          courts: courts.length,
          players: players.length,
          games: games.length,
          messages: messages.length,
          reports: reports.length,
          blocked: blocked.length
        }
      },
      { depth: null }
    );
    return;
  }

  initFirebase();
  const db = admin.firestore();

  if (args.values.fresh) {
    await wipeCollections(db);
  }

  const batch = db.batch();

  courts.forEach((court) => {
    batch.set(db.collection('courts').doc(court.id), {
      name: court.name,
      address: court.address,
      latitude: court.latitude,
      longitude: court.longitude,
      createdAt: timestamp()
    });
  });

  players.forEach((player) => {
    const userRef = db.collection('users').doc(player.uid);
    batch.set(userRef, {
      email: player.email,
      name: player.name,
      createdAt: timestamp(),
      lastLoginAt: timestamp()
    });

    const profileRef = db.collection('profiles').doc(player.uid);
    batch.set(profileRef, {
      name: player.name,
      bio: player.bio,
      homeCourtID: player.homeCourtID,
      photoURL: player.photoURL,
      location: {
        latitude: player.location.latitude,
        longitude: player.location.longitude,
        lastUpdated: timestamp()
      },
      lastUpdated: timestamp(),
      settings: {
        notificationsEnabled: true,
        darkMode: false
      }
    });

    const statsRef = db.collection('stats').doc(player.uid);
    batch.set(statsRef, {
      wins: player.stats.wins,
      losses: player.stats.losses,
      currentStreak: player.stats.currentStreak,
      bestStreak: player.stats.bestStreak,
      totalGames: player.stats.totalGames,
      rating: player.stats.rating,
      lastGameDate: timestamp()
    });
  });

  games.forEach((game) => {
    batch.set(db.collection('games').doc(game.id), {
      challengerID: game.challengerID,
      opponentID: game.opponentID,
      courtID: game.courtID,
      scheduledDate: game.scheduledDate,
      rules: game.rules,
      status: game.status,
      challengerScore: game.challengerScore ?? null,
      opponentScore: game.opponentScore ?? null,
      winnerID: game.winnerID ?? null,
      loserID: game.loserID ?? null,
      isConfirmed: game.isConfirmed,
      createdAt: game.createdAt,
      updatedAt: game.updatedAt
    });
  });

  messages.forEach((message) => {
    batch.set(db.collection('messages').doc(message.id), {
      gameID: message.gameID,
      senderID: message.senderID,
      senderName: message.senderName,
      text: message.text,
      timestamp: message.timestamp,
      isRead: message.isRead
    });
  });

  reports.forEach((report) => {
    batch.set(db.collection('reports').doc(report.id), report);
  });

  blocked.forEach((entry) => {
    const blockedRef = db
      .collection('blocked')
      .doc(entry.blockerID)
      .collection('blocked')
      .doc(entry.blockedID);
    batch.set(blockedRef, {
      createdAt: entry.createdAt
    });
  });

  await batch.commit();
  console.log('✅ Seed data written successfully.');
}

seed()
  .then(() => {
    console.log('✨ Done');
    process.exit(0);
  })
  .catch((error) => {
    console.error('❌ Seeding failed', error);
    process.exit(1);
  });

