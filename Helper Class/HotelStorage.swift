//
//  HotelStorage.swift
//  My Hotels
//
//  Created by My Hotels on 6/12/22.
//

import Foundation
import UIKit
import CoreData

class HotelStorage {

    let urlSession: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    //MARK: - Fetching data from json server -
    func fetchAllHotels(completion: @escaping([ModelHotel]?) -> Void) {
        let urlComponent = URLComponents(string: "http://localhost:3000/hotels")
        let url = urlComponent?.url
        let urlRequest = URLRequest(url: url!)
        let task1 = urlSession.dataTask(with: urlRequest) { data, response, error in
            if let jsonData = data {
                do {
                    let model = try JSONDecoder().decode([ModelHotel].self, from: jsonData)
                    self.retriveData(isFavorite: false) { result in
                        if result?.count == 0 {
                            self.createData(results: model)
                        }
                    }
                    completion(model)
                } catch {
                  debugPrint(error)
                }
                
            } else if let err = error {
                print("Error fetching photos: \(err)")
                completion(nil)
            } else {
                print("Something went wrong!")
            }
        }
        task1.resume()
    }
    
    func retriveData(isFavorite: Bool, completion: @escaping([ModelHotel]?) -> Void) {
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
            let managedContext = appDelegate.persistentContainer.viewContext
            let  fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Hotel")
            if isFavorite == true {
                fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
            }

            do {
                guard let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
                var arrHotels = [ModelHotel]()
                for data in result {
                    var hotel = ModelHotel()
                    hotel.id = data.value(forKey: "id") as? String ?? ""
                    hotel.name = data.value(forKey: "name") as? String ?? ""
                    hotel.media = (data.value(forKey: "media") as? String ?? "").components(separatedBy: ",")
                    hotel.categories = (data.value(forKey: "categories") as? String ?? "").components(separatedBy: ",")
                    hotel.cat_spanish = (data.value(forKey: "cat_spanish") as? String ?? "").components(separatedBy: ",")
                    hotel.desc = data.value(forKey: "desc") as? String ?? ""
                    hotel.desc_spanish = data.value(forKey: "desc_spanish") as? String ?? ""


                    var location = LocationDetail()
                    location.countryName = data.value(forKey: "countryName") as? String ?? ""
                    location.name = data.value(forKey: "locationName") as? String ?? ""
                    hotel.locationDetail = location
                    
                    var geoLocation = GeoLocation()
                    geoLocation.longitude = Double(data.value(forKey: "long") as? String ?? "")
                    geoLocation.latitude = Double(data.value(forKey: "lat") as? String ?? "")
                    hotel.geoLocation = geoLocation
                    
                    hotel.propertyType = data.value(forKey: "propertyType") as? String ?? ""
                    hotel.starRating = Int(data.value(forKey: "starRating") as? String ?? "")
                    hotel.isFavorite = data.value(forKey: "isFavorite") as? Bool ?? false
                    
                    debugPrint(data.value(forKey: "isFavorite") as? String ?? "")
                    arrHotels.append(hotel)
                }
                completion(arrHotels)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
    }
    
    func createData(results: [ModelHotel]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let userEntity = NSEntityDescription.entity(forEntityName: "Hotel", in: managedContext) else { return }
        
        for hotel in results {
            let objHotel =  NSManagedObject(entity: userEntity, insertInto: managedContext)
            objHotel.setValue(hotel.id ?? "", forKey: "id")
            objHotel.setValue(hotel.name ?? "", forKey: "name")
            objHotel.setValue(hotel.desc ?? "", forKey: "desc")
            objHotel.setValue(hotel.desc_spanish ?? "", forKey: "desc_spanish")
            objHotel.setValue(hotel.propertyType ?? "", forKey: "propertyType")
            objHotel.setValue("\(hotel.starRating ?? 0)", forKey: "starRating")
            objHotel.setValue(hotel.locationDetail?.name ?? "", forKey: "locationName")
            objHotel.setValue(hotel.locationDetail?.countryName ?? "", forKey: "countryName")
            objHotel.setValue("\(hotel.geoLocation?.longitude ?? 0)", forKey: "long")
            objHotel.setValue("\(hotel.geoLocation?.latitude ?? 0)", forKey: "lat")
            objHotel.setValue(false, forKey: "isFavorite")

            let mediaString = (hotel.media?.map({$0}) ?? []).joined(separator: ",")
            let categoryString = (hotel.categories?.map({$0}) ?? []).joined(separator: ",")
            
            let categorySpanish = (hotel.cat_spanish?.map({$0}) ?? []).joined(separator: ",")
            
            objHotel.setValue(mediaString, forKey: "media")
            objHotel.setValue(categorySpanish, forKey: "cat_spanish")
            
            objHotel.setValue(categoryString, forKey: "categories")
            
        }
        do {
            try managedContext.save()
            debugPrint("Data saved")
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
}
