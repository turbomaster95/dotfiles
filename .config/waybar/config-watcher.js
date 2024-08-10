const fs = require('fs')
const child = require('child_process')

// watch the target file
const watcher = fs.watch('/home/deva/.config/waybar/config.jsonc')
// create a child process for the target application
let currentChild = Bun.spawn(["waybar"])

watcher.on('change', () => {
  // we assure we have only one child process at time
  if (currentChild) {
    currentChild.kill()
  }
  // reset the child process
  currentChild = Bun.spawn(["waybar"])
  console.log("CHANGED")
})
