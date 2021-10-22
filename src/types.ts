// Env Variables
import * as dotenv from 'dotenv';
dotenv.config({ path: './.env' });

export const token = process.env.ACCESS_TOKEN;
export const test = process.env;
export interface File {
    name: string | undefined,
    url: string | undefined
}

export type Files = Array<File>

export interface Contents {
    nested: boolean,
    contents: Directory
}

export interface Directory {
    name: string,
    files: Files,
    directories?: Directory[]
}

// {[k: string]: any}