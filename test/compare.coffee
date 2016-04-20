glob = require('globby')
fs = require('fs')
path = require('path')

module.exports = (pattern, lhs, rhs) ->
  lhsFiles = null
  rhsFiles = null

  glob(pattern, { cwd: lhs })
  .then((found) ->
    found.sort()
    lhsFiles = found
    return
  )
  .then(() ->
    glob(pattern, { cwd: rhs })
  )
  .then((found) ->
    found.sort()
    rhsFiles = found
    return
  )
  .then(() ->
    lhsOnly = []
    rhsOnly = []
    shared = []

    lhsOnly = lhsFiles.filter((element) -> rhsFiles.indexOf(element) == -1)
    rhsOnly = rhsFiles.filter((element) -> lhsFiles.indexOf(element) == -1)
    shared  = lhsFiles.filter((element) -> rhsFiles.indexOf(element) != -1)

    if lhsOnly.length != 0 or rhsOnly.length != 0
      throw new Error("Folders do not match #{JSON.stringify({ lhsOnly: lhsOnly, rhsOnly: rhsOnly }, null, 2)}")

    promises = Promise.resolve()
    for name in shared
      do (name) ->
        promises = promises.then(() ->
          new Promise((resolve, reject) ->
            fs.readFile(path.join(lhs, name), 'utf8', (err, lhsData) ->
              if err?
                return reject(err)

              fs.readFile(path.join(rhs, name), 'utf8', (err, rhsData) ->
                if err?
                  return reject(err)

                # normalise newlines
                lhsData = lhsData.replace(/\r\n/g, '\n')
                rhsData = rhsData.replace(/\r\n/g, '\n')

                if lhsData != rhsData
                  reject(new Error("""
                    Files do not match:
                      #{path.join(lhs, name)}
                      #{path.join(rhs, name)}
                  """))
                else
                  resolve(null)

                return
              )
              return
            )
            return
        ))

    return promises
  )