// import * as functions from "firebase-functions";
import GitHubAPI from "./mod";
import * as mariadb from "mariadb";

// ENV
import * as dotenv from "dotenv";
dotenv.config({path: "./.env"});

const db = {
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  pass: process.env.DB_PASS,
  port: process.env.DB_PORT
};

const pool = mariadb.createPool({
  host: db.host,
  user: db.user,
  password: db.pass,
  port: Number(db.port),
  connectionLimit: 5
});

const callDB = async (query: string) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const rows = await conn.query(query);
    console.log(rows);
  } catch (err) {
    console.error("Error running query: ", err);
  } finally {
    if (conn) conn.release();
  }
};

const main = async (): Promise<number> => {
  // const covid = new GitHubAPI();
  // const ls = await covid.getRepoDirectories(true);
  // covid.logContents(ls);
  callDB("SELECT title from mediaServer.movies limit 10");
  return 0;
};

main();


// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
