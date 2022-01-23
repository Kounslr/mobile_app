const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();
const db = admin.firestore();
exports.updateSchoolsDaily = functions
  .runWith({ memory: '2GB' })
  .pubsub.schedule('0 0 * * *')
  .onRun(async function () {
    const lcpsString = 'http://www.lcps.org';

    // Checks if school is in LCPS
    const query = db
      .collection('schools')
      .where('websiteUrl', '>=', lcpsString)
      .where('websiteUrl', '<=', lcpsString + '\uf8ff');

    const schools = await query.get();

    const jobs = [];

    for (const element in schools) {
      const now = admin.firestore.Timestamp.now();

      const seconds = now.seconds;

      const dayType = function () {
        if (snapshot.data()['currentDay']['dayType'] == 'A') {
          return 'B';
        }
        return 'A';
      };

      const periodOne = function () {
        if (snapshot.data()['currentDay']['blocks'][0]['period'] == 1) {
          return 5;
        }
        return 1;
      };

      const periodTwo = function () {
        if (snapshot.data()['currentDay']['blocks'][1]['period'] == 2) {
          return 6;
        }
        return 2;
      };

      const periodThree = function () {
        if (snapshot.data()['currentDay']['blocks'][2]['period'] == 3) {
          return 7;
        }
        return 3;
      };

      const periodFour = function () {
        if (snapshot.data()['currentDay']['blocks'][3]['period'] == 4) {
          return 8;
        }
        return 4;
      };

      const job = snapshot.ref.update({
        currentDay: {
          blocks: [
            {
              period: periodOne(),
              time: new admin.firestore.Timestamp(33300 + seconds, 0),
            },
            {
              period: periodTwo(),
              time: new admin.firestore.Timestamp(40500 + seconds, 0),
            },
            {
              period: periodThree(),
              time: new admin.firestore.Timestamp(47700 + seconds, 0),
            },
            {
              period: periodFour(),
              time: new admin.firestore.Timestamp(52500 + seconds, 0),
            },
          ],
          date: now,
          startingTime: new admin.firestore.Timestamp(33300 + seconds, 0),
          endingTime: new admin.firestore.Timestamp(57780 + seconds, 0),
          dayType: dayType(),
        },
      });

      jobs.push(job);
    }

    return await Promise.all(jobs);
  });
