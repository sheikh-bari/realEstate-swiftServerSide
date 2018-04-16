
import PerfectLib
import PerfectHTTPServer

// Create server object.
let server = HTTPServer()

// Listen on port 8181.
server.serverPort = 8181

// Add our routes.
let routes = makeURLRoutes()
let advRoutes = advertRoutes()
server.addRoutes(routes)
server.addRoutes(advRoutes)

do {
    // Launch the HTTP server
    try server.start()
} catch PerfectError.networkError(let err, let msg) {
    print("Network error thrown: \(err) \(msg)")
}