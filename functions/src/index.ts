// import * as functions from "firebase-functions";
import GitHubAPI from "./mod";
import { parse } from "csv";
import * as fs from "fs";

import requests, { AxiosResponse } from "axios";
import { callDB } from "./db";

interface File {
  name: string | undefined,
  url: string | undefined
}

const isNumber = (string: string) => /^-?\d+$/.test(string);

const underscoreTo_camel = (str: string): string => {
  const spl = str.split("_");
  let cmlc = spl[0];
  for (const part of spl) {
    if (spl.indexOf(part) == 0) continue;
    cmlc += (part.charAt(0).toUpperCase() + part.slice(1));
  }
  return cmlc;
};

const exportDataToFile = async (obj: File, outputToFile: boolean, latest: number): Promise<any> => {
  if (obj.url === undefined) return 0;
  if (!obj.url.endsWith(".csv")) return 0;

  console.warn(`Exporting ${obj.name}`);

  const resp: AxiosResponse = await requests.get(obj.url);
  const file = String(resp.data);

  let columns: string[] = [];
  const data: any = [];

  // const toJSON = (records: any[]) => {

  // };

  if (obj.name?.includes("linelist")) {
    console.warn("Skipping for now");
    // const parser = parse({
    //   delimiter: ","
    // });
    // parser.on("readable", () => {
    //   let record;
    //   while (record = parser.read()) {
    //     columns.push(record);
    //   }
    // });
    // parser.on("error", (err) => {
    //   console.log(err);
    // });
    // parser.on("end", () => {
    //   // console.log(columns);
    //   const newcol = [columns[0], columns[1]];
    //   toJSON(newcol);
    // });
    // parser.write(file);
    // parser.end();
  } else {
    parse(file, {}, (err, records) => {
      if (err) {
        console.log(err);
      } else {
        columns = records[0];
        // console.log(columns[1]);
        for (const record of records) {
          if (records.indexOf(record) == 0) continue;
          const tempObj: any = {};
          for (const header of columns) {
            const curr = record[columns.indexOf(header)];
            if (isNumber(curr)) tempObj[header] = Number(curr);
            else if (curr == "" || curr == " ") tempObj[header] = null;
            else tempObj[header] = record[columns.indexOf(header)];
          }
          data.push(tempObj);
        }
        insertIntoDB({
          "name": obj.name,
          "data": data
        }, latest);
        outputToFile ? fs.writeFileSync(`data/${obj.name}`, JSON.stringify(data, null, 2), { flag: "w+" }) : true;
      }
    });
  }


  return {
    "name": obj.name,
    "data": data
  };
};

const insertIntoDB = (data: { name: string | undefined, data: any[]}, latest: number) => {
  let tableName: string;
  data.name == "static/population.csv" ?
  tableName = "population" :
  tableName = `${data.name?.split("/")[0]}_${underscoreTo_camel(String(data.name?.split("/")[1].split(".")[0]))}`;

  console.log(`Inserting into table: ${tableName}`);

  let cols: string = Object.keys(data.data[0]).toString();
  // Expection for mysejahtera_checkinMalaysiaTime
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
    // Errors: vaccination_aefi [duplicate data], vaccination_vaxSchool [incorrect quotes for string], epidemic_clusters [district too small]
  }
};

const main = async (): Promise<void> => {
  const covid = new GitHubAPI();
  const content = await covid.getRepoDirectories(true);
  const test = true;
  if (test) {
    console.log("Testing");
    await exportDataToFile(content.contents.directories![0].files[3], false, 5);
  } else {
    for (const folder of content.contents.directories!) {
      if (folder.directories) {
        for (const obj of folder.directories[0].files) {
          console.log("Skipping for now", obj.name);
          // await exportDataToFile(obj, false);
        }
      }
      for (const obj of folder.files) {
        await exportDataToFile(obj, false, 5);
      }
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
