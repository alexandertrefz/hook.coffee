fs     = require "fs"
{exec} = require "child_process"

appFiles = [
    "event"
    "namespacedHandler"
    "handle"
    "hook"
]

jsify = ( string ) ->
    string.replace(".coffee", ".js")

option "-v", "--version [VERSION]", "Defines the Version."

option "-w", "--watch", "Watches for changes."

task "build", "Build everything", (options) ->
    invoke("build:source")
    invoke("build:test")
    if options.watch
        options.watch = false
        for file in appFiles
            fs.watchFile "src/#{file}.coffee", (curr, prev) ->
                if (new Date curr.mtime).getTime() isnt (new Date prev.mtime).getTime()
                    invoke("build:source")
            
            fs.watchFile "test/#{file}.coffee", (curr, prev) ->
                if (new Date curr.mtime).getTime() isnt (new Date prev.mtime).getTime()
                    invoke("build:test")
        
    


task "build:source", "Build hook.js from source", (options) ->
    
    options.version ?= "debug"
    appContents = []
    readFileCount = 0
    
    for file, index in appFiles then do (file, index) ->
        fs.readFile "src/#{file}.coffee", "utf8", (err, fileContents) ->
            throw err if err
            
            appContents[index] = fileContents
            readFileCount++
            
            compile() if readFileCount is appFiles.length
        
    
            
    compile = ->
        filename = "hook-#{options.version}.coffee"
        path = "lib/#{filename}"
        content = appContents.join("\n\n")
        content = content.replace /<VERSION>/g, options.version
        fs.writeFile path, content, "utf8", (err) ->
            throw err if err
            exec "coffee --compile #{path}", (err, stdout, stderr) ->
                if err
                    console.log stdout + stderr
                    throw err
                    
                fs.unlink path, (err) ->
                    throw err if err
                    
                    console.log "#{jsify(filename)} build done."
                
            
        
    



task "build:test", "Build tests.js for hook.js", (options) ->
    
    appContents = []
    readFileCount = 0
    
    for file, index in appFiles then do (file, index) ->
        fs.readFile "test/#{file}.coffee", 'utf8', (err, fileContents) ->
            throw err if err
            
            fileContents = "module \"#{file.slice(0, 1).toUpperCase() + file.slice(1)}\"\n\n#{fileContents}"
            
            appContents[index] = fileContents
            readFileCount++
            
            compile() if readFileCount is appFiles.length
        
    
            
    compile = ->
        filename = "test.coffee"
        path = "test/#{filename}"
        fs.writeFile path, appContents.join('\n\n'), 'utf8', (err) ->
            throw err if err
            exec "coffee --bare --compile #{path}", (err, stdout, stderr) ->
                if err
                    console.log stdout + stderr
                    throw err
                    
                fs.unlink path, (err) ->    
                    
                    console.log "#{jsify(filename)} build done."




