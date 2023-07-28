// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import topbar from "../vendor/topbar"
import JSZip from "../vendor/jszip"


const Hooks = {}
Hooks.ZipUpload = {
  mounted() {
    this.el.addEventListener("input", e => {
      e.preventDefault()
      let zip = new JSZip()
      Array.from(e.target.files).forEach(file => {
        this.maybeZip(zip, file.webkitRelativePath || file.name, file)
      })
      this.uploadZip(zip)
    })
    window.addEventListener("drop", e => {
      readDirFiles(e.dataTransfer.items).then(filesWithEntries => {
        let zip = new JSZip()
        filesWithEntries.forEach(([file, entry]) => {
          let fullPath = entry.fullPath.replace(/^\//, "") // drop "/" prefix
          this.maybeZip(zip, fullPath, file)
        })
        this.uploadZip(zip)
      })
    })
  },

  maybeZip(zip, fullPath, file) {
    if (!/\.git\/|node_modules|_build\/|^cover\/|deps|^doc\/|\.fetch|erl_crash.dump|.*\.log/.test(fullPath)) {
      zip.file(fullPath, file, { binary: true })
    }
  },

  uploadZip(zip) {
    zip.generateAsync({ type: "blob" }).then(blob => this.upload("dir", [blob]))
  }
}

// Adapted from https://stackoverflow.com/a/53058574
async function readDirFiles(dataTransferItemList) {
  let fileEntries = []
  let queue = []
  for (let i = 0; i < dataTransferItemList.length; i++) {
    queue.push(dataTransferItemList[i].webkitGetAsEntry())
  }
  while (queue.length > 0) {
    let entry = queue.shift()
    if (entry.isFile) {
      await entry.file(f => fileEntries.push([f, entry]), (err) => { throw new Error(err) })
    } else if (entry.isDirectory) {
      queue.push(...await readAllDirectoryEntries(entry.createReader()))
    }
  }
  return fileEntries
}

// Get all the entries (files or sub-directories) in a directory
// by calling readEntries until it returns empty array
async function readAllDirectoryEntries(directoryReader) {
  let entries = [];
  let readEntries = await readEntriesPromise(directoryReader)
  while (readEntries.length > 0) {
    entries.push(...readEntries)
    readEntries = await readEntriesPromise(directoryReader)
  }
  return entries
}

// Wrap readEntries in a promise to make working with readEntries easier
// readEntries will return only some of the entries in a directory
// e.g. Chrome returns at most 100 entries at a time
async function readEntriesPromise(directoryReader) {
  try {
    return await new Promise((resolve, reject) => {
      directoryReader.readEntries(resolve, reject)
    })
  } catch (err) { console.log(err) }
}

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}, hooks: Hooks})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

