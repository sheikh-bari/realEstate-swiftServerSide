//
//  PerfectHandlers.swift
import PerfectHTTP
import Foundation
import PerfectLib

func advertRoutes() -> Routes {

	var routes = Routes()

	routes.add(method: .post, uri: "/api/listings", handler: getListingsHandler)
	routes.add(method: .get, uri: "/api/listing/{listing_id}", handler: getListingHandler)
	routes.add(method: .post, uri: "/api/listing/create", handler: createNewListingHandler)
	routes.add(method: .put, uri: "/api/updateListing", handler: updateListingHandler)
	routes.add(method: .post, uri: "/api/deleteListing", handler: deleteListingHandler)

	return routes;

}

func getListingsHandler(request: HTTPRequest, response: HTTPResponse) {
	let searchText = request.param(name: "searchText", defaultValue: "")!
	let typeOfAccomodation = request.param(name: "typeOfAccomodation", defaultValue: "")!
	let noOfBedRooms = request.param(name: "noOfBedRooms", defaultValue: "")!
	let squareFeet = request.param(name: "squareFeet", defaultValue: "")!
	let adType = request.param(name: "adType", defaultValue: "")!
	print("here");
	var query: String;

	if (searchText == "" && typeOfAccomodation == "" && noOfBedRooms == "" && squareFeet == "" && adType == "")
	{
		query = "SELECT `RealEstateAd`.`ID`, `RealEstateAd`.`Id`, `RealEstateAd`.`Title`, `RealEstateAd`.`AdDescription`, `RealEstateAd`.`Price`, `RealEstateAd`.`City`, `RealEstateAd`.`State`, `RealEstateAd`.`Address`, `RealEstateAd`.`Latitude`, `RealEstateAd`.`Longitude`, `RealEstateAd`.`BedRooms`, `RealEstateAd`.`Zip`, `RealEstateAd`.`AdStatusId`, `AdMedia`.`Id` AS `AdMedia.Id`, `AdMedia`.`ImagePath` AS `AdMedia.ImagePath`, `AdType`.`Id` AS `AdType.Id`, `AdType`.`AdTypeName` AS `AdType.AdTypeName`, `RealEstateCategory`.`Id` AS `RealEstateCategory.Id`, `RealEstateCategory`.`CategoryName` AS `RealEstateCategory.CategoryName` FROM `realestateads` AS `RealEstateAd` LEFT OUTER JOIN `admedia` AS `AdMedia` ON `RealEstateAd`.`ID` = `AdMedia`.`RealEstateAdID` LEFT OUTER JOIN `adtypes` AS `AdType` ON `RealEstateAd`.`AdTypeId` = `AdType`.`Id` LEFT OUTER JOIN `realestatecategories` AS `realestatecategory` ON `RealEstateAd`.`RealEstateCategoryId` = `RealEstateCategory`.`Id` WHERE `RealEstateAd`.`AdStatusId` != 3 GROUP BY `RealEstateAd`.`Id`, `AdMedia`.`Id` ORDER BY `RealEstateAd`.`createdAt` DESC;"
		
	} else {
		query = "SELECT `RealEstateAd`.`ID`, `RealEstateAd`.`Id`, `RealEstateAd`.`Title`, `RealEstateAd`.`AdDescription`, `RealEstateAd`.`Price`, `RealEstateAd`.`City`, `RealEstateAd`.`State`, `RealEstateAd`.`Address`, `RealEstateAd`.`Latitude`, `RealEstateAd`.`Longitude`, `RealEstateAd`.`BedRooms`, `RealEstateAd`.`Zip`, `RealEstateAd`.`AdStatusId`, `AdMedia`.`Id` AS `AdMedia.Id`, `AdMedia`.`ImagePath` AS `AdMedia.ImagePath`, `AdType`.`Id` AS `AdType.Id`, `AdType`.`AdTypeName` AS `AdType.AdTypeName`, `RealEstateCategory`.`Id` AS `RealEstateCategory.Id`, `RealEstateCategory`.`CategoryName` AS `RealEstateCategory.CategoryName` FROM `realestateads` AS `RealEstateAd` LEFT OUTER JOIN `admedia` AS `AdMedia` ON `RealEstateAd`.`ID` = `AdMedia`.`RealEstateAdID` "


		if (adType == "") {
			query = query + "LEFT OUTER JOIN `adtypes` AS `AdType` ON `RealEstateAd`.`AdTypeId` = `AdType`.`Id` "
		} else {
			query = query + "INNER JOIN `adtypes` AS `AdType` ON `RealEstateAd`.`AdTypeId` = `AdType`.`Id` And `AdType`.`Id` = '\(adType)' "
		}

		if (typeOfAccomodation == "") {
			query = query + "LEFT OUTER JOIN `realestatecategories` AS `RealEstateCategory` ON `RealEstateAd`.`RealEstateCategoryId` = `RealEstateCategory`.`Id` "
		} else {
			query = query + "INNER JOIN `realestatecategories` AS `RealEstateCategory` ON `RealEstateAd`.`RealEstateCategoryId` = `RealEstateCategory`.`Id` AND `RealEstateCategory`.`Id` = '\(typeOfAccomodation)' "
		}

		var sQuery: Bool = false;
		var searchQuery: String = "";

		if (searchText != "") {
			searchQuery = "WHERE (`RealEstateAd`.`city` Like '%\(searchText)%' OR `RealEstateAd`.`state` Like '%\(searchText)%' OR `RealEstateAd`.`zip` Like '\(searchText)') "
			sQuery = true;			
		}

		if (noOfBedRooms != "") {
			if (sQuery) {
				searchQuery = searchQuery + "AND (`RealEstateAd`.`BedRooms` = '\(noOfBedRooms)') "
			} else {
				searchQuery = "WHERE (`RealEstateAd`.`BedRooms` = '\(noOfBedRooms)') "	 
			}
		}
		let groupBy: String = " GROUP BY `RealEstateAd`.`Id`, `AdMedia`.`Id` ORDER BY `RealEstateAd`.`createdAt` DESC;"
		print("printing query")
		
		query = query + searchQuery + groupBy;
		print(query)

	}

	let adverts: [Array<String>] = search(query: query)
	response.setHeader(.contentType, value: "application/json")

	do {
	    try response.setBody(json: adverts)
	} catch {

	} 


	response.completed()
}

// todo upload media
func createNewListingHandler(request: HTTPRequest, response: HTTPResponse) { 
	let AgentId = request.param(name: "AgentId", defaultValue: "")!
	let BedRooms = request.param(name: "BedRooms", defaultValue: "")!
	let BathRooms = request.param(name: "BathRooms", defaultValue: "")!
	let Kitchen = request.param(name: "Kitchen", defaultValue: "")!
	let SquareFeet = request.param(name: "SquareFeet", defaultValue: "")!
	let Price = request.param(name: "Price", defaultValue: "")!
	let Address = request.param(name: "Address", defaultValue: "")!
	let Zip = request.param(name: "Zip", defaultValue: "")!
	let State = request.param(name: "State", defaultValue: "")!
	let City = request.param(name: "City", defaultValue: "")!
	let AdDescription = request.param(name: "AdDescription", defaultValue: "")!
	let Parking = request.param(name: "Parking", defaultValue: "")!
	let AdTypeName = request.param(name: "AdTypeName", defaultValue: "")!
	let real_estate_category_id = request.param(name: "real_estate_category_id", defaultValue: "")!
	let Title = request.param(name: "Title", defaultValue: "")!
	let LivingRooms = request.param(name: "LivingRooms", defaultValue: "")!


	let NumOfFloors = request.param(name: "NumOfFloors", defaultValue: "")!
	let LotArea = request.param(name: "LotArea", defaultValue: "")!
	let Latitude = request.param(name: "Latitude", defaultValue: "")!
	let Longitude = request.param(name: "Longitude", defaultValue: "")!
	let AdStatusId = 1
	

	let currentDateTime = Date()
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	let createdAt = formatter.string(from: currentDateTime)


	response.setHeader(.contentType, value: "application/json")

	if (AgentId == "") {
		do {
			try response.setBody(json: "Access Denied")
		} catch {}
		response.completed()
	} else {
		if (BedRooms == "" || BathRooms == "" || Kitchen == "" || SquareFeet == "" || Price == "" || Address == "" ||
			Zip == "" || State == "" || City == "" || AdDescription == "" || Parking == "" || AdTypeName == "" ||
			real_estate_category_id == "" || Title == "") {

			do {
				try response.setBody(json: "Insufficient Data")
			} catch {}
			response.completed()
		} else {

			let AdTypeId = Int(AdTypeName)!
			let query = """
				INSERT INTO `realestateads` (`ID`, `AgentId`, `LivingRooms`, `BedRooms`, `BathRooms`, `Kitchen`, `SquareFeet`, `Price`, `Address`, `Zip`, `State`, `City`, `AdDescription`, `Parking`, `NumOfFloors`, `LotArea`, `Title`, `Latitude`, `Longitude`, `createdAt`, `updatedAt`, `AdStatusId`, `AdTypeId`, `RealEstateCategoryId`) VALUES
				(DEFAULT, '\(AgentId)', '\(LivingRooms)','\(BedRooms)','\(BathRooms)','\(Kitchen)','\(SquareFeet)','\(Price)','\(Address)','\(Zip)','\(State)','\(City)','\(AdDescription)','\(Parking)','\(NumOfFloors)','\(LotArea)','\(Title)','\(Latitude)','\(Longitude)','\(createdAt)','\(createdAt)','\(AdStatusId)','\(AdTypeId)','\(real_estate_category_id)' )
				"""
			print(query)

			let newAd: Int = insert(query: query)
			print(newAd);

			var result: String
			
			if(newAd > 0) {
				if let uploads = request.postFileUploads, uploads.count > 0 {
					
					let fileDir = Dir("./Resources/fileuploads")
					var fileNames = [String]()
					print("fileDir - \(fileDir)")
					do {
						try fileDir.create()
					}
					catch {
						print(error)
					}


					var ary = [[String:Any]]()

					for upload in uploads {
						ary.append([
							"fieldName": upload.fieldName,
							"contentType": upload.contentType,
							"fileName": upload.fileName,
							"fileSize": upload.fileSize,
							"tmpFileName": upload.tmpFileName
						])
						let thisFile = File(upload.tmpFileName)
						do {
							print(fileDir.path + upload.fileName)
							let _ = try thisFile.moveTo(path: fileDir.path + upload.fileName, overWrite: true)
							fileNames.append(fileDir.path + upload.fileName)
						}
						catch {
							print(error)
						}
					}

					for var i in 0..<fileNames.count {

						let insertFilequery = """
							INSERT INTO `admedia` (`ID`, `ImagePath`, `createdAt`, `updatedAt`, `RealEstateAdID`) VALUES 
							(DEFAULT, '\(fileNames[i])', '\(createdAt)', '\(createdAt)', '\(newAd)' )
							"""
						var mediaId: Int = insert(query: insertFilequery)
					}

				}
				result = "New Ad Created Successfully"
			} else {
				result = "Error Occur while creating Ad"	
			}

			do {
				try response.setBody(json: result)
			} catch { }
			response.completed()
		}
	}
}


func updateListingHandler(request: HTTPRequest, response: HTTPResponse) {
	let AgentId = request.param(name: "AgentId", defaultValue: "")!
	let ID = request.param(name: "ID", defaultValue: "")!
	let BedRooms = request.param(name: "BedRooms", defaultValue: "")!
	let BathRooms = request.param(name: "BathRooms", defaultValue: "")!
	let Kitchen = request.param(name: "Kitchen", defaultValue: "")!
	let SquareFeet = request.param(name: "SquareFeet", defaultValue: "")!
	let Price = request.param(name: "Price", defaultValue: "")!
	let Address = request.param(name: "Address", defaultValue: "")!
	let Zip = request.param(name: "Zip", defaultValue: "")!
	let State = request.param(name: "State", defaultValue: "")!
	let City = request.param(name: "City", defaultValue: "")!
	let AdDescription = request.param(name: "AdDescription", defaultValue: "")!
	let Parking = request.param(name: "Parking", defaultValue: "")!
	let real_estate_category_id = request.param(name: "real_estate_category_id", defaultValue: "")!
	let LivingRooms = request.param(name: "LivingRooms", defaultValue: "")!
	let Title = request.param(name: "Title", defaultValue: "")!

	let NumOfFloors = request.param(name: "NumOfFloors", defaultValue: "")!
	let LotArea = request.param(name: "LotArea", defaultValue: "")!
	let Latitude = request.param(name: "Latitude", defaultValue: "")!
	let Longitude = request.param(name: "Longitude", defaultValue: "")!
	let AdStatus = request.param(name: "AdStatusId", defaultValue: "")!
	let AdStatusId: Int = AdStatus == "" ? 0 : Int(AdStatus)!
	

	let currentDateTime = Date()
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
	let createdAt = formatter.string(from: currentDateTime)

	let query = """
		UPDATE `realestateads` SET `BedRooms` = '\(BedRooms)', `BathRooms` = '\(BathRooms)', `Kitchen` = '\(Kitchen)', 
		`SquareFeet` = '\(SquareFeet)', `Price` = '\(Price)', `Address` = '\(Address)', `Zip` = '\(Zip)',
		`State` = '\(State)', `City` = '\(City)', `AdDescription` = '\(AdDescription)', `Parking` = '\(Parking)', 
		`RealEstateCategoryId` = '\(real_estate_category_id)', `LivingRooms` = '\(LivingRooms)', `Title` = '\(Title)', 
		`NumOfFloors` = '\(NumOfFloors)', `LotArea` = '\(LotArea)', `Latitude` = '\(Latitude)', `Longitude` = '\(Longitude)', 
		`AdStatusId` = '\(AdStatusId)', `updatedAt` = '\(createdAt)' 
		WHERE `ID` = '\(ID)' AND `AgentId` = '\(AgentId)'
		"""

	print(query)

	let updateAd: Int = update(query: query)
	print(updateAd);

	var result: String
	
	if(updateAd > 0) {
		result = "Ad Updated Successfully"
	} else {
		result = "You donot have permission to update this Ad"	
	}

	do {
		try response.setBody(json: result)
	} catch { }
	response.completed()

}

func deleteListingHandler(request: HTTPRequest, response: HTTPResponse) {
	let AgentId = request.param(name: "AgentId", defaultValue: "")!
	let ID = request.param(name: "ID", defaultValue: "")!

	let query = """
		UPDATE `realestateads` SET `AdStatusId` = 3
		WHERE `ID` = '\(ID)' AND `AgentId` = '\(AgentId)'
		"""

	let deletedAd : Int = update(query: query)

	var result: String
	
	if(deletedAd > 0) {
		result = "Ad Deleted Successfully"
	} else {
		result = "You donot have permission to delete this Ad"	
	}

	do {
		try response.setBody(json: result)
	} catch { }
	response.completed()
}

func getListingHandler(request: HTTPRequest, response: HTTPResponse) {
	print("here")
	let listingId = request.urlVariables["listing_id"]!

	let query = """
		SELECT `RealEstateAd`.*, `adtypes`.`Id` As `AdType,Id`, `adtypes`.`AdTypeName` AS `AdType.AdTypeName`, `adstatuses`.`Id` AS `AdStatus.Id`, `adstatuses`.`AdStatusName` As `AdStatus.AdStatusName`,
		`realestatecategories`.`Id` As `RealEstateCategory.Id`, `realestatecategories`.`CategoryName` As `RealEstateCategory.CategoryName`  
		FROM (Select * From `realestateads` As `RealEstateAd` 
		WHERE ( `RealEstateAd`.`ID` = '\(listingId)' AND `RealEstateAd`.`AdStatusId` != 3) Limit 1  ) AS `RealEstateAd`
		left outer join adtypes On adtypes.Id = RealEstateAd.AdTypeId 
		left outer join adstatuses on adstatuses.Id = RealEstateAd.AdStatusId
		left outer join realestatecategories on realestatecategories.Id = RealEstateAd.RealEstateCategoryId
		"""
		print(query)
	let adverts: [Array<String>] = search(query: query)

	response.setHeader(.contentType, value: "application/json")

	do {
	    try response.setBody(json: adverts)
	} catch {

	} 


	response.completed()

}
