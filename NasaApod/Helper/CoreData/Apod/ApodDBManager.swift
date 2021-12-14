//
//  ApodDBManager.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import CoreData

class ApodDBManager {
    //MARK: - Add Data in DB
    func addApodDataInDB(model:ApodModel)  {
        //check for data if not there then add else update
        if let date = model.date, let cdApod = fetchData(date: date) {
            let fav = cdApod.isFavourite
            cdApod.insert(newValue: model)
            cdApod.isFavourite = fav
            CoreDataStack.saveContext()
        }
        else if let cdApod = CoreDataStack.object(for: "CDApod") as? CDApod {
            cdApod.insert(newValue: model)
            CoreDataStack.saveContext()
        }
    }
    
    //MARK: - Update Favourite Data
    func markAsFavourite(date: String) -> ApodModel? {
        //check if its already favourite then remove it else add it
        if let cdApod = fetchData(date: date) {
            cdApod.isFavourite = !cdApod.isFavourite
            CoreDataStack.saveContext()
            return ApodModel(newValue: cdApod)
        }
        return nil
    }
    
    //MARK: - Fetch data from DB
    func fetchData(for date: String) -> ApodModel? {
        // fetch apod for give date
        guard let data = self.fetchData(date: date) else {
            return nil
        }
        return ApodModel(newValue: data)
    }
    
    private func fetchData(date: String) -> CDApod? {
        let predicate = NSPredicate(format: "date=%@", date)
        let fetchResults = CoreDataStack.loadData(entityName: "CDApod", predicate: predicate) as [CDApod]
        return fetchResults.first
    }
    
    //fetch favourites APod
    func fetchFavourites() -> [ApodModel] {
        let predicate = NSPredicate(format: "isFavourite=%@", NSNumber(value: true))
        return fetchAllDataFromDB(predicate: predicate)
    }
    
    //fetch all APod using predicate
    func fetchAllDataFromDB(predicate: NSPredicate?) -> [ApodModel] {
        var apodModels = [ApodModel] ()
        let fetchResults = CoreDataStack.loadData(entityName: "CDApod", predicate: predicate) as [CDApod]
        if fetchResults.count > 0 {
            for data in fetchResults {
                let apodModel = ApodModel(newValue: data)
                apodModels.append(apodModel)
            }
        }
        return apodModels
    }
    //MARK: - delete all data from DB
    func deleteAllDataFromDB() {
        CoreDataStack.delete(entityName: "CDApod", predicate: nil)
    }
    
}

extension CDApod {
    //MARK: - Inset new item
    func insert(newValue: ApodModel) {
        self.copyright = newValue.copyright
        self.date = newValue.date
        self.explanation = newValue.explanation
        self.hdurl = newValue.hdurl
        self.media_type = newValue.media_type
        self.title = newValue.title
        self.service_version = newValue.service_version
        self.url = newValue.url
        self.isFavourite = newValue.isfav ?? false
    }
}
