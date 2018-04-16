import MySQL

let host = "127.0.0.1"
let user = "root"
let password = ""
let database = "realestate_swift"
let tsocket = "/Applications/MAMP/tmp/mysql/mysql.sock"

func search(query: String)-> [Array<String>] {

	let mysql = MySQL()

	let connected = mysql.connect(host: host, user: user, password: password, db: database, port: 3306, socket: tsocket)

	var ary = [Array<String>]()
  guard connected else {
    // verify we connected successfully
    print(mysql.errorMessage())
    return ary
  }

  let stmt = MySQLStmt(mysql)
  defer {
    mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
  }

  //var prep = try stmt.prepare(statement:"INSERT into users (UserName, Email, Password, FirstName, LastName, MobileNumber, RealEstateCompanyId, UserStatusId, UserTypeId, createdAt, updatedAt) Values('abdulbariaa2', 'abcaa2.abc@gmail.com', '', '', '', '', 4, 1, 1, '2017-11-21 21:20:37', '2017-11-21 21:20:37')")
  var prep = try stmt.prepare(statement: query)
  var querySuccess = stmt.execute()

  // make sure the query worked
  guard querySuccess else {
  	return ary
  }

  // Save the results to use during this session
  let results = stmt.results() //We can implicitly unwrap because of the guard on the querySuccess. You’re welcome to use an if-let here if you like. 

  results.forEachRow { row in
    var data = [String]()
    for var i in 0..<row.count {
      let fieldname = stmt.fieldInfo(index: i)!.name
    	
      if(row[i] != nil) {
    		data.append("\(fieldname): \(row[i]!)")
    	} else  {
    		data.append("\(fieldname): null")
    	}
      
    }
    ary.append(data)
  } 
  return ary;

}

func insert(query: String) -> Int {


	let mysql = MySQL()
	

	let connected = mysql.connect(host: host, user: user, password: password, db: database, port: 3306, socket: tsocket)

  var result: Int = 0
	var ary = [Array<String>]()
  guard connected else {
    // verify we connected successfully
    print(mysql.errorMessage())
    return result
  }
  let stmt = MySQLStmt(mysql)
  defer {
    mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
  }

  //var prep = try stmt.prepare(statement:"INSERT into users (UserName, Email, Password, FirstName, LastName, MobileNumber, RealEstateCompanyId, UserStatusId, UserTypeId, createdAt, updatedAt) Values('abdulbariaa2', 'abcaa2.abc@gmail.com', '', '', '', '', 4, 1, 1, '2017-11-21 21:20:37', '2017-11-21 21:20:37')")
  var prep = try stmt.prepare(statement: query)
  var querySuccess = stmt.execute()
  print("printing")
  print(stmt.insertId())
  result = Int(exactly: stmt.insertId())!

  print(result);
  // make sure the query worked
  guard querySuccess else {
  	print(mysql.errorMessage())
  	return result
  }
 
  // Save the results to use during this session

  return result
}

func update(query: String) -> Int {
    let mysql = MySQL()
  

  let connected = mysql.connect(host: host, user: user, password: password, db: database, port: 3306, socket: tsocket)

  var result: Int = 0
  var ary = [Array<String>]()
  guard connected else {
    // verify we connected successfully
    print(mysql.errorMessage())
    return result
  }
  let stmt = MySQLStmt(mysql)
  defer {
    mysql.close() //This defer block makes sure we terminate the connection once finished, regardless of the result
  }

  //var prep = try stmt.prepare(statement:"INSERT into users (UserName, Email, Password, FirstName, LastName, MobileNumber, RealEstateCompanyId, UserStatusId, UserTypeId, createdAt, updatedAt) Values('abdulbariaa2', 'abcaa2.abc@gmail.com', '', '', '', '', 4, 1, 1, '2017-11-21 21:20:37', '2017-11-21 21:20:37')")
  var prep = try stmt.prepare(statement: query)
  var querySuccess = stmt.execute()

  print(stmt.affectedRows())
  result = Int(exactly: stmt.affectedRows())!

  print(result);
  // make sure the query worked
  guard querySuccess else {
    print(mysql.errorMessage())
    return result
  }
 
  // Save the results to use during this session

  return result
}