import * as mariadb from "mariadb";

// Environmental Variables
import * as dotenv from "dotenv";
dotenv.config({ path: "./.env" });

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
  connectionLimit: 5,
  acquireTimeout: 1200000
});
// const pool = mariadb.createConnection({
//   host: db.host,
//   user: db.user,
//   password: db.pass,
//   port: Number(db.port)
// });


export const callDB = async (query: string, next: (result: any) => void) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const response = await conn.query(query);
    await conn.end();
    next(response);
  } catch (err) {
    errorHandling(err, query);
  } finally {
    if (conn) conn.release();
  }
};

const errorHandling = (err: any, q: string) => {
  const error = {
    "error": err.text,
    "code": err.errno,
    "type": err.code,
    "query": err.sql
  };
  if (error.code != 1062) {
    console.log(error);
  }
  if (err.fatal) {
    console.log("Fatal Error - Exiting...");
    console.log("Query:", q);
    process.exit(1);
  } else {
    error;
  }
};
