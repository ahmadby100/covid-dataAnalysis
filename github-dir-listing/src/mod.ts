// Imports
import requests from 'axios';

// Env Variables
import * as dotenv from 'dotenv';
dotenv.config({ path: './.env' });
const token = process.env.ACCESS_TOKEN;

// Types 
import { AxiosRequestConfig } from 'axios';
type Files = Array<{
    name: string | undefined,
    url: string | undefined
}>

interface Contents {
    nested: boolean,
    contents: Directory
}

interface Directory {
    name: string,
    files: Files,
    directories?: Directory[]
}
// Types End

class GitHubAPI {
    
    private baseUrl: string;
    private rawUrl: string;
    private contentsUrl: string;
    private repoUrl: string;
    private repo: string;

    constructor(newRepo?: string) {
        newRepo ? this.repo = newRepo : this.repo = "MoH-Malaysia/covid19-public";        
        this.baseUrl = "https://api.github.com";
        this.rawUrl = "https://raw.githubusercontent.com"
        this.repoUrl = `${this.baseUrl}/repos/${this.repo}`;
        this.contentsUrl = `${this.baseUrl}/repos/${this.repo}/contents/`;
        
    }

    private callAPI = async (url: string, options?: AxiosRequestConfig): Promise<any> => {
        let config: AxiosRequestConfig;
        if (!options) {
            config = {
                method: "GET",
                headers: {
                    "Authorization": `Bearer ${token}`
                }
            }
        } else {
            config = options;
        }
        return await requests.get(url, config);
    }

    getRepoInfo = (): Promise<any> => {
        return this.callAPI(this.repoUrl)
    };

    getRepoFile = (path: string | null): Promise<string> => {
        if (!path) throw new Error("Path is empty");
        return this.callAPI(`${this.baseUrl}/${this.repo}/main/${path}`);
    }
    
    getRepoDirectories = async (nested: boolean): Promise<Contents> => {
        if (!nested) nested = true;
        const rootContentsResponse = await this.callAPI(this.contentsUrl);
        let dir: Contents = {
            nested: false,
            contents: {
                name: this.repo,
                files: [],
            }
        };
        let rootDirectories: Array<string> = [];
        for (const i in rootContentsResponse.data) {
            if (rootContentsResponse.data[i].type == "file") 
                dir.contents.files.push({name: rootContentsResponse.data[i].path, url: rootContentsResponse.data[i].download_url})
                
            if (rootContentsResponse.data[i].type == "dir") {
                dir.nested = true;
                rootDirectories.push(rootContentsResponse.data[i].path);
            }
        }
        const recurse = async (rootDirectories: Array<string>) => {
            let temp: Array<Directory> = [];
            for (const j in rootDirectories) {
                let obj: Directory = {
                    name: "",
                    files: []
                };
                obj.name = rootDirectories[j];
                let nestedDirFiles: Files = [];
                let nestedDirDirectories: Array<string> = [];
                const nestedDirResponse = await this.callAPI(`${this.contentsUrl}/${rootDirectories[j]}`);
            
                for (const k in nestedDirResponse.data) {
                    if (nestedDirResponse.data[k].type == "dir") {
                        nestedDirDirectories.push(nestedDirResponse.data[k].path)
                    }
                    if(nestedDirResponse.data[k].type == "file") {
                        nestedDirFiles.push({name: nestedDirResponse.data[k].path, url: nestedDirResponse.data[k].download_url});
                    }
                }
                obj["files"] = nestedDirFiles
                if (nestedDirDirectories.length != 0) {
                    obj["directories"] = await recurse(nestedDirDirectories);
                }
                temp.push(obj);
            }
            return temp;
        }
        dir.contents.directories = await recurse(rootDirectories);
        return dir;
    }
    logContents = (content: Contents) => {
        console.log('\x1b[36m%s\x1b[0m',`${content.contents.name}\n---------------`)
        for (let i in content.contents.files) {
            console.log(content.contents.files[i].name)
        }
        const recurseLog = (curr: Directory[], recursed: number) => {
            let thisTab = "    ".repeat(recursed);
            for (let j in curr) {
                let i = Number(j)
                console.log('\x1b[36m%s\x1b[0m',`${thisTab.slice(0, -2)}${curr[i].name}`);
                for (let l in curr[i].files) {
                    if (curr[i].files[l].name) {
                        console.log(`${thisTab}${curr[i].files[l].name}`)
                        // console.log(`${thisTab}  ${curr[i].files[l].url}`)
                    }
                    else 
                    continue;
                }
                if (curr[i].directories) {
                    recurseLog(curr[i].directories!, ++recursed);
                }
                
            }
        }
        recurseLog(content.contents.directories!, 1);
    }
}




const main = async () => {
    let user = "ahmadby100";
    let repo = "lastspotify";
    const alt = `${user}/${repo}`;
    const covid = new GitHubAPI();
    const content = await covid.getRepoDirectories(true);
    covid.logContents(content);
    
}

main()