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

let pool: mariadb.Pool;

const connectToDB = () => {
  pool = mariadb.createPool({
    host: db.host,
    user: db.user,
    password: db.pass,
    port: Number(db.port),
    connectionLimit: 5,
    acquireTimeout: 1200// 000
  });
};

export const closePool = () => {
  if (pool) pool.end();
  else console.log("No pool connection to close");
};
// const pool = mariadb.createConnection({
//   host: db.host,
//   user: db.user,
//   password: db.pass,
//   port: Number(db.port)
// });
export const executeBatch = async (query: string, values: any[], next: (result: any) => void) => {
  if (!pool) connectToDB();
  let conn;
  try {
    conn = await pool.getConnection();
    const response = await conn.batch(query, values);
    conn.release();
    next(response);
  } catch (err) {
    errorHandling(err, query);
  } finally {
    if (conn) conn.end();
  }
};

export const callDB = async (query: string, next: (result: any) => void) => {
  if (!pool) {
    connectToDB();
  }
  let conn;
  try {
    conn = await pool.getConnection();
    const response = await conn.query(query);
    conn.release();
    next(response);
  } catch (err) {
    errorHandling(err, query);
  } finally {
    if (conn) conn.end();
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
