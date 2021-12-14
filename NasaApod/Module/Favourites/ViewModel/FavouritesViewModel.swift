//
//  FavouritesViewModel.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

protocol FavouritesViewerProtocol : ErrorProtocol {
    func favouritesFetchCompleted()
    func updateFavItem(at index:Int)
}

class FavouritesViewModel {
    private weak var delegate: FavouritesViewerProtocol?
    private var adpods: [ApodModel] = []
    private var dBManager: ApodDBManager
    
    init(delegate: FavouritesViewerProtocol) {
        dBManager = ApodDBManager()
        self.delegate = delegate
    }
    
    //MARK:- fetch favourite from local DB
    func fetchFavourites() {
        adpods = dBManager.fetchFavourites()
        delegate?.favouritesFetchCompleted()
    }
    
    //MARK:- get total number of favourite items
    func getNumberOfRows() -> Int {
        adpods.count
    }
    
    //MARK:- get view model to present data on given index
    func getViewModel(for index: Int) -> FavouriteViewModel {
        FavouriteViewModel(apodData: adpods[index], cellIndex: index) { [weak self] index in
            // handle favourite axn
            self?.fetchFavourites()
        }
    }
    
    //MARK:- Create View controller to show detail
    func getDetailVC(for index: Int) -> ApodViewController {
        let vc = ApodViewController.initFromStoryboard()
        vc.selectedDate = adpods[index].date
        return vc
    }
    
}
