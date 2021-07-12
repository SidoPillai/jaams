
const axios = require("axios")
const async = require("async")
const textToSpeech = require('@google-cloud/text-to-speech')
const client = new textToSpeech.TextToSpeechClient()
const fs = require('fs')
const util = require('util')
const path = require("path")
const { result } = require("lodash")

let cachedResults = new Object()

class JaamsController {

    constructor(app) {
        this.app = app
        this.getStories()
        this.addStory()
        this.removeStory()
        this.getAudioFile()
    }

    getStories() {
        this.app.get("/stories/all", (req, res) => {
            var data = []
            for (var key in cachedResults) {
                data.push(cachedResults[key])
            }
            res.send(data)
        })
    }

    getAudioFile() {
        this.app.get("/stories/audio", (req, res) => {
            const storymapId = req.query.id
            if (storymapId !== undefined) {
                if (storymapId in cachedResults) {
                    res.sendFile(path.posix.join(process.cwd(), `${storymapId}.mp3`)) 
                } else {
                    res.send("Story not found")
                }
            } else {
                res.send("invalid id")
            }
        })
    }

    addStory() {
        this.app.post("/stories/add", (req, res) => {
            const storyMapUrl = req.query.storymapsUrl            
            if (storyMapUrl === undefined) {
                res.send("Invalid request")
            } else {
                console.log("Story Map Url: ", storyMapUrl)
                const storymapId = storyMapUrl.substring(storyMapUrl.lastIndexOf('/') + 1)
                this.getItemData(storymapId).then((result) => {
                    this.getStoryMapMetaData(storymapId, result).then((result) => {
                        console.log(result)
                        cachedResults[storymapId] = result
                        res.send(result)
                    }).catch((err) => {
                        Promise.reject("Something went wrong in the server")
                    })
                }).catch((err) => {
                    res.send(err)
                })
            }
        })
    }

    removeStory() {
        this.app.post("/stories/remove", (req, res) => {
            const storymapId = req.query.id
            if (storymapId === undefined) {
                res.send("Invalid request")
            } else {
                delete cachedResults[storymapId]
                res.send("Success")
            }
        })
    }

    // https://www.arcgis.com/sharing/rest/content/items/b22a6a09bb2344ff845d9efd3e4152f7/data?f=json
    async getItemData(storymapId) {
        const res = await axios.get(`https://www.arcgis.com/sharing/rest/content/items/${storymapId}/data?f=json`)
        let data = res.data
        let rootNode = data.root
        let allNodes = data.nodes
        let children = data.nodes[rootNode].children

        var file = fs.createWriteStream(`${storymapId}.txt`);
        var str = ""

        file.on('error', function(err) {
            return Promise.reject("Error while opening the file")
        });


        children.forEach(element => {
            let nodeType = allNodes[element].type            
            if (nodeType === "storycover") {
                console.log(allNodes[element].data.title)
                str = str.concat(allNodes[element].data.title + '\n')
                file.write(allNodes[element].data.title + '\n')
            } else if (nodeType === "text") {
                if (allNodes[element].data.type === "paragraph") {
                    file.write(allNodes[element].data.text + '\n')
                    if (str.length + allNodes[element].data.text.length < 5000) {
                        str = str.concat(allNodes[element].data.text + '\n')
                    }
                }
            }
        });
        
        file.end()
        return this.convertToAudio(storymapId, str)
    }

    // https://www.arcgis.com/sharing/rest/content/items/${itemId}?f=json
    async getStoryMapMetaData(storymapId, audio) {
        const res = await axios.get(`https://www.arcgis.com/sharing/rest/content/items/${storymapId}?f=json`)
        let data = res.data
        let id = data.id
        let thumbnailUrl = `https://www.arcgis.com/sharing/rest/content/items/${id}/info/${data.thumbnail}`
        let metaData = {}
        metaData.id = data.id
        metaData.storyMapsUrl = data.url
        metaData.thumbnailUrl = thumbnailUrl
        metaData.title = data.title
        metaData.snippet = data.snippet
        metaData.edited = data.modified
        metaData.audio = path.posix.join(__dirname, audio)
        return Promise.resolve(metaData)
    }

    async convertToAudio(storymapId, contents) {
        const request = {
          input: {text: contents},
          voice: {languageCode: 'en-US', ssmlGender: 'NEUTRAL'},
          audioConfig: {audioEncoding: 'MP3'},
        };
      
        const [response] = await client.synthesizeSpeech(request);
        const writeFile = util.promisify(fs.writeFile);
        await writeFile(`${storymapId}.mp3`, response.audioContent, 'binary');
        return Promise.resolve(`${storymapId}.mp3`)
    }
}

module.exports = (app) => { return new JaamsController(app) }
