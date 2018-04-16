//
//  PerfectHandlers.swift
import PerfectHTTP
import Foundation

func makeURLRoutes() -> Routes {
	
	var routes = Routes()

	routes.add(method: .get, uris: ["/", "index.html"], handler: indexHandler)
	//routes.add(method: .get, uri: "/foo/*/baz", handler: echoHandler)
	routes.add(method: .post, uri: "/api/login", handler: loginHandler)
	routes.add(method: .post, uri: "/api/signup", handler: signupHandler)
	/*routes.add(method: .get, uri: "/foo/bar/baz", handler: echoHandler)
	routes.add(method: .get, uri: "/user/{id}/baz", handler: echo2Handler)
	routes.add(method: .get, uri: "/user/{id}", handler: echo2Handler)
	routes.add(method: .post, uri: "/user/{id}/baz", handler: echo3Handler)*/

	// Test this one via command line with curl:
	// curl --data "{\"id\":123}" http://0.0.0.0:8181/raw --header "Content-Type:application/json"
	//routes.add(method: .post, uri: "/raw", handler: rawPOSTHandler)

	// Trailing wildcard matches any path
	//routes.add(method: .get, uri: "**", handler: echo4Handler)

	// Routes with a base URI
	// Create routes for version 1 API
	var api = Routes()
	api.add(method: .get, uri: "/call1", handler: { _, response in
		response.setBody(string: "API CALL 1")
		response.completed()
	})
	api.add(method: .get, uri: "/call2", handler: { _, response in
		response.setBody(string: "API CALL 2")
		response.completed()
	})

	// API version 1
	var api1Routes = Routes(baseUri: "/v1")
	// API version 2
	var api2Routes = Routes(baseUri: "/v2")

	// Add the main API calls to version 1
	api1Routes.add(routes: api)
	// Add the main API calls to version 2
	api2Routes.add(routes: api)
	// Update the call2 API
	api2Routes.add(method: .get, uri: "/call2", handler: { _, response in
		response.setBody(string: "API v2 CALL 2")
		response.completed()
	})

	// Add both versions to the main server routes
	//routes.add(routes: api1Routes)
	//routes.add(routes: api2Routes)

	// Check the console to see the logical structure of what was installed.
	print("\(routes.navigator.description)")
	return routes
}

func loginHandler(request: HTTPRequest, response: HTTPResponse) {

	let username = request.param(name: "username", defaultValue: "")!
	let password = request.param(name: "password", defaultValue: "")!
	let query = "select * from users where username = '\(username)' AND password = '\(password)'"
	
	let user: [Array<String>] = search(query: query)
	response.setHeader(.contentType, value: "application/json")
	
	if(user.count > 0) {
		do {
		    try response.setBody(json: user)
		} catch {

		} 
	} else {
		do {
		    try response.setBody(json: "Username Or Password Incorrect")
		} catch {

		}
	}

  	// Ensure that response.completed() is called when your processing is done.
	response.completed()
}

func signupHandler(request: HTTPRequest, response: HTTPResponse)  {
	let username = request.param(name: "username", defaultValue: "")!
	let email = request.param(name: "email", defaultValue: "")!
	let password = request.param(name: "password", defaultValue: "")!
	let firstName = request.param(name: "fname", defaultValue: "")!
	let lastName = request.param(name: "lname", defaultValue: "")!
	let mobileNumber = request.param(name: "phone", defaultValue: "")!
	let currentDateTime = Date()
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	let dateTime = formatter.string(from: currentDateTime)

	let query = "select * from users where username ='\(username)' OR email = '\(email)'"

	let user: [Array<String>] = search(query: query);
	response.setHeader(.contentType, value: "application/json")

	if ( user.count > 0 ) {
		do {
	    try response.setBody(json: "username or email already exist")
	  } catch {

	  } 
	} else {	

		let insQuery = "INSERT into users (UserName, Email, Password, FirstName, LastName, MobileNumber, RealEstateCompanyId, UserStatusId, UserTypeId, createdAt, updatedAt) Values('\(username)', '\(email)', '\(password)', '\(firstName)', '\(lastName)', '\(mobileNumber)', 4, 1, 1, '\(dateTime)', '\(dateTime)')"

		let newUser: Int = insert(query: insQuery)
		var Result: String

		if(newUser > 0) {
			Result = "User Added Successfully"
		} else {
			Result = "Error Occured While adding user please try again later"		
		}
		print(newUser);
	  do {
	    try response.setBody(json: Result)
	  } catch {

	  } 
	}

	response.completed()
}

func indexHandler(request: HTTPRequest, _ response: HTTPResponse) {
	response.appendBody(string: "Index handler: You accessed path \(request.path)")
	response.completed()
}

func echoHandler(request: HTTPRequest, _ response: HTTPResponse) {
	response.appendBody(string: "Echo handler: You accessed path \(request.path) with variables \(request.urlVariables)")
	response.completed()
}

func echo2Handler(request: HTTPRequest, _ response: HTTPResponse) {
	response.appendBody(string: "<html><body>Echo 2 handler: You GET accessed path \(request.path) with variables \(request.urlVariables)<br>")
	response.appendBody(string: "<form method=\"POST\" action=\"/user/\(request.urlVariables["id"] ?? "error")/baz\"><button type=\"submit\">POST</button></form></body></html>")
	response.completed()
}

func echo3Handler(request: HTTPRequest, _ response: HTTPResponse) {
	response.appendBody(string: "<html><body>Echo 3 handler: You POSTED to path \(request.path) with variables \(request.urlVariables)</body></html>")
	response.completed()
}

func echo4Handler(request: HTTPRequest, _ response: HTTPResponse) {
    response.appendBody(string: "<html><body>Echo 4 (trailing wildcard) handler: You accessed path \(request.path)</body></html>")
    response.completed()
}

