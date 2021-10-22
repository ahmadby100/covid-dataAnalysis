// Imports
import requests from 'axios';
import { AxiosRequestConfig } from 'axios';

// Types 
import { Contents, token, Directory, Files } from './types';

class GitCovid {
    
    private baseUrl: string;
    private rawUrl: string;
    private contentsUrl: string;
    private repoUrl: string;
    private repo: string;

    constructor() {
        this.baseUrl = "https://api.github.com";
        this.rawUrl = "https://raw.githubusercontent.com"
        this.repo = "MoH-Malaysia/covid19-public";
        this.repoUrl = `${this.baseUrl}/repos/${this.repo}`;
        this.contentsUrl = `${this.baseUrl}/repos/${this.repo}/contents/`;
        
    }

    private callGitAPI = async (url: string, options?: AxiosRequestConfig): Promise<any> => {
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
        return this.callGitAPI(this.repoUrl)
    };

    getRepoFile = (path: string | null): Promise<string> => {
        if (!path) throw new Error("Path is empty");
        return this.callGitAPI(`${this.baseUrl}/${this.repo}/main/${path}`);
    }
    
    getRepoDirectories = async (nested: boolean): Promise<Contents> => {
        if (!nested) nested = true;
        const rootContentsResponse = await this.callGitAPI(this.contentsUrl);
        let dir: Contents = {
            nested: false,
            contents: {
                name: "covid19-public",
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
            let z: Array<Directory> = [];
            for (const j in rootDirectories) {
                let obj: Directory = {
                    name: "",
                    files: []
                };
                obj.name = rootDirectories[j];
                let nestedDirFiles: Files = [];
                let nestedDirDirectories: Array<string> = [];
                const nestedDirResponse = await this.callGitAPI(`${this.contentsUrl}/${rootDirectories[j]}`);
            
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
                    let m = await recurse(nestedDirDirectories);
                    obj["directories"] = m;
                }
                z.push(obj);
            }
            return z;
        }
        let r = await recurse(rootDirectories);
        dir.contents.directories = r;
        return dir;
    }
}




const main = async () => {
    const covid = new GitCovid();
    const content = await covid.getRepoDirectories(true);
    
    console.log('\x1b[36m%s\x1b[0m',`${content.contents.name}\n---------------`)
    for (let i in content.contents.files) {
        console.log(content.contents.files[i].name)
    }
    const recurseLog = (curr: Directory[], recursed: number) => {
        let thisTab = "    ".repeat(recursed);
        for (let j in curr) {
            let i = Number(j)
            console.log('\x1b[36m%s\x1b[0m',`${thisTab.slice(0, -2)}${curr[i].name}`);
            if (curr[i].directories) {
                recurseLog(curr[i].directories!, ++recursed);
            }
            for (let l in curr[i].files) {
                if (curr[i].files[l].name) {
                    console.log(`${thisTab}${curr[i].files[l].name}`)
                    // console.log(`${thisTab}  ${curr[i].files[l].url}`)
                }
                else 
                    continue;
            }
            
        }
    }
    recurseLog(content.contents.directories!, 1);
}

main()