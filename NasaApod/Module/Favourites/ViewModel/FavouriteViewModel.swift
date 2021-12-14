//
//  FavouriteViewModel.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

class FavouriteViewModel: ApodDataViewModel {
    private var update: (_ index: Int)->()
    private var cellIndex: Int
    
    init(apodData: ApodModel, cellIndex: Int, update: @escaping (_ index:Int)->()) {
        self.cellIndex = cellIndex
        self.update = update
        super.init()
        self.setApodData(apodData: apodData)
    }
    
    //MARK:- update on favourite click
    override func markFavourite() {
        super.markFavourite()
        self.update(cellIndex)
    }
    
}
