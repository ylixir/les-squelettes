import readline from "readline"

console.error(`
Usage:
  cat input.txt | node dist/main.js

  If you don't pipe in a stream, simply press ctrl-D when you are done
`)

const reader = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false,
})

reader.on('line', (line:string)=>{
  console.log(`Hello ${line}`)
})
