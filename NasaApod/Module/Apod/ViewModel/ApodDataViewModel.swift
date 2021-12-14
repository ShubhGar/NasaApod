//
//  ApodDataViewModel.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation
import AVKit

class ApodDataViewModel: NSObject {
    private var apodData: ApodModel?
    private var dBManager: ApodDBManager?
    //MARK: - initalizer
    override init() {
        dBManager = ApodDBManager()
    }
    //MARK: - set apod for viewmodel
    func setApodData(apodData: ApodModel) {
        self.apodData = apodData
    }
    //MARK: - apod favourite for given apod
    func update(favourite isFav: Bool?) {
        self.apodData?.isfav = isFav
    }
    //MARK: - get title of apod
    func getTitle() -> String {
        self.apodData?.title ?? ""
    }
    //MARK: - get explanation of apod
    func getExplanation() -> String {
        self.apodData?.explanation ?? ""
    }
    //MARK: - get date of apod
    func getDate() -> String {
        self.apodData?.date ?? ""
    }
    //MARK: - get image/video url for apod
    func getURL() -> URL? {
        URL(string: self.apodData?.url ?? self.apodData?.hdurl ?? "")
    }
    //MARK: - is apod video type
    func isVideo() -> Bool {
        self.apodData?.media_type == "video"
    }
    //MARK: - is apod already mark for favourite
    func isFavourite() -> Bool {
        self.apodData?.isfav ?? false
    }
    
    //MARK: - mark faavourite
    func markFavourite() {
        guard apodData != nil else {
            return
        }
        self.apodData = dBManager?.markAsFavourite(date: self.getDate())
    }
    
    func storeApodInDB(model: ApodModel) {
        //Add Data to DB
        dBManager?.addApodDataInDB(model: model)
    }
    
    func fetchData(date: String) -> ApodModel? {
        //fetch from DB
        let model = dBManager?.fetchData(for: date)
        self.apodData = model
        return model
    }
    
    //MARK: - get thumbnail for video/ not working for youtuube url
    func getThumbnailImageForVideo(completion: @escaping ((_ image: UIImage?)->Void)) {
        DispatchQueue.global().async {
            if let url = self.getURL() {
                let asset = AVAsset(url: url)
                let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
                avAssetImageGenerator.appliesPreferredTrackTransform = true
                let thumnailTime = CMTimeMake(value: 2, timescale: 1)
                do {
                    let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                    let thumbNailImage = UIImage(cgImage: cgThumbImage)
                    DispatchQueue.main.async {
                        completion(thumbNailImage)
                    }
                } catch {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
            
        }
    }
}
