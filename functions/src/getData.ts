// import * as functions from "firebase-functions";
import GitHubAPI from "./mod";
import { parse } from "csv";
import * as fs from "fs";

import requests, { AxiosResponse, AxiosResponseHeaders } from "axios";
import { callDB, closePool, executeBatch } from "./db";

interface File {
  name: string | undefined,
  url: string | undefined
}

const isNumber = (str: string) => (/^-?\d+$/.test(str) || str == "" || str == " ") ? true : false;

const underscoreTo_camel = (str: string): string => {
  const spl = str.split("_");
  let cmlc = spl[0];
  for (const part of spl) {
    if (spl.indexOf(part) == 0) continue;
    cmlc += (part.charAt(0).toUpperCase() + part.slice(1));
  }
  return cmlc;
};

const getTableName = (filename: string): string => {
  let tableName = `${filename.split("/")[0]}_${underscoreTo_camel(String(filename.split("/")[1].split(".")[0]))}`;
  if (filename.includes("linelist")) {
    switch (true) {
      case filename.includes("epidemic/linelist/linelist_cases"):
        tableName = "linelist_cases";
        break;
      case filename == "epidemic/linelist/linelist_deaths.csv":
        tableName = "linelist_deaths";
        break;
      case filename == "epidemic/linelist/param_geo.csv":
        tableName = "linelist_paramGeo";
        break;
    }
  } if (filename == "static/population.csv") {
    tableName = "population";
  }
  return tableName;
};

const insertIntoDB = (data: { name: string | undefined, data: any[]}, latest: number) => {
  const tableName = getTableName(data.name!);

  console.log(`Inserting into table: ${tableName}`);

  // Expection for mysejahtera_checkinMalaysiaTime
  let cols: string = Object.keys(data.data[0]).toString();
  if (tableName == "mysejahtera_checkinMalaysiaTime") {
    const colst = Object.keys(data.data[0]);
    for (const col of colst) {
      if (col != "date") {
        colst[colst.indexOf(col)] = `period_${col}`;
      }
    }
    cols = colst.toString();
  }
  let records = [];
  if (latest != 0) {
    console.log(`Updating data from past ${latest} days`);
    records = data.data.slice(Math.max(data.data.length - latest, 0));
  } else {
    console.log("Updating data from all time");
    records = data.data;
  }
  for (const record in records) {
    let vals = "";
    const valsArry: any[] = Object.values(records[record]);
    for (const val in valsArry) {
      let comma = ",";
      if (Number(val) + 1 == valsArry.length) {
        comma = "";
      }
      if (!isNumber(valsArry[val]) && valsArry[val] != null) {
        vals += `"${valsArry[val]}"${comma}`;
      } else if (valsArry[val] == null) {
        vals += `NULL${comma}`;
      } else {
        vals += `${valsArry[val]}${comma}`;
      }
    }

    cols = cols.replace("-", "_");
    const q = `INSERT INTO covidMY.${tableName} (${cols}) VALUES (${vals});`;

    callDB(q, (resp) => {
      process.stdout.write(`${record + 1}/${records.length}: ${resp}\r`);
    });
    break;
    // Errors: vaccination_aefi [duplicate data], vaccination_vaxSchool [incorrect quotes for string], epidemic_clusters [district too small]
  }
  closePool();
};

const handleLargeFile = async (obj: File, latest: number): Promise<void> => {
  let downloaded = 0;
  let percentage = 0;

  const tableName = getTableName(obj.name!);

  const records: any[] = [];

  console.log(`Handling large file: ${obj.name}`);
  const parser = parse({
    delimiter: ","
  });

  const { data, headers }: { data: any, headers: AxiosResponseHeaders } = await requests.get(String(obj.url), {
    responseType: "stream"
  });
  const fileSize = Number(headers["content-length"]);


  parser.on("readable", () => {
    let record;
    while (record = parser.read()) {
      records.push(record);
    }
  });

  parser.on("error", (error) => {
    console.log("Parser error:", error.message);
  });

  data.on("data", async (chnk: any) => {
    downloaded += Buffer.byteLength(chnk);
    percentage = Math.floor((downloaded / fileSize) * 100);
    process.stdout.write(`Downloading: ${percentage}% - ${Math.floor(downloaded / 1000) / 1000} MB\r`);
    parser.write(chnk);

    if (percentage == 100) {
      console.log("");
      const values: any[] = [];

      const cols: string = records[0].toString();
      const q = `INSERT IGNORE INTO covidMY.${tableName} (${cols}) VALUES (${("?,".repeat(records[0].length).slice(0, -1))});`;
      // const q = `INSERT IGNORE INTO covidMY.templinelist_cases (${cols}) VALUES (${("?,".repeat(records[0].length).slice(0, -1))});`;

      for (const record of records) {
        if (records.indexOf(record) == 0) continue;

        const d: any[] = [];
        records[records.indexOf(record)].forEach((v: string) => (!isNumber(v)) ? d.push(v) : d.push(Number(v)));
        values.push(d);

        process.stdout.write(`Processing: ${Math.floor(records.indexOf(record) / records.length * 100)}% - ${records.indexOf(record)}/${records.length}\r`);

        if (values.length % 10000 == 0 || records.indexOf(record) == records.length - 1) console.log(values); // await executeBatch(q, values, () => values.length = 0);
      }
      closePool();
      return;
    }
  });
  return;
};

const exportDataToFile = async (obj: File, outputToFile: boolean, latest: number): Promise<void> => {
  if (obj.url === undefined) return;
  if (!obj.url.endsWith(".csv")) return;

  const head: AxiosResponse = await requests.head(obj.url);
  const fileSize = Number(head.headers["content-length"]);

  // if (fileSize > 5000000) {
  await handleLargeFile(obj, latest);
  return;

  // } else {
  //   console.warn(`Exporting ${obj.name}`);

  //   const resp: AxiosResponse = await requests.get(obj.url);
  //   const file = String(resp.data);
  //   console.log(`${obj.name} Downloaded`);

  //   let columns: string[] = [];
  //   const data: any = [];

  //   parse(file, {}, (err, records) => {
  //     if (err) {
  //       console.log(err);
  //     } else {
  //       columns = records[0];
  //       // console.log(columns[1]);
  //       for (const record of records) {
  //         if (records.indexOf(record) == 0) continue;
  //         const tempObj: any = {};
  //         for (const header of columns) {
  //           const curr = record[columns.indexOf(header)];
  //           if (isNumber(curr)) tempObj[header] = Number(curr);
  //           else if (curr == "" || curr == " ") tempObj[header] = null;
  //           else tempObj[header] = record[columns.indexOf(header)];
  //         }
  //         data.push(tempObj);
  //       }
  //       console.log(data);
  //       // insertIntoDB({
  //       //   "name": obj.name,
  //       //   "data": data
  //       // }, latest);
  //       outputToFile ? fs.writeFileSync(`data/${obj.name}`, JSON.stringify(data, null, 2), { flag: "w+" }) : true;
  //     }
  //   });
  // }
};

const main = async (): Promise<void> => {
  const covid = new GitHubAPI();
  const content = await covid.getRepoDirectories(true);
  const test = true;
  if (test) {
    console.log("Testing");
    console.log(await exportDataToFile(content.contents.directories![0].directories![0].files[6], false, 5));
    // for (const file of content.contents.directories![0].directories![0].files) {
    //   exportDataToFile(file, false, 0);
    // }
  } else {
    for (const folder of content.contents.directories!) {
      if (folder.directories) {
        console.log("Nested Directory");
        for (const obj of folder.directories[0].files) {
          if (obj.name?.includes("linelist_cases")) await exportDataToFile(obj, false, 0);
        }
      }
      // for (const obj of folder.files) {
      //   await exportDataToFile(obj, false, 5);
      // }
    }
  }
};

main();

//  TODO
// get linelist
// setup autmation
// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
