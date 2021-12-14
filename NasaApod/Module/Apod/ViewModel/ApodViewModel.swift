//
//  ApodViewModel.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import Foundation

protocol ErrorProtocol: AnyObject {
    func showError(message:String)
}

protocol ApodViewerProtocol: ErrorProtocol {
    func apodFetchCompleted()
}

class ApodViewModel: ApodDataViewModel {
    
    private weak var delegate: ApodViewerProtocol?
    private var dataFetcher: DataFetcherProtocol
    
    init(delegate: ApodViewerProtocol) {
        self.delegate = delegate
        dataFetcher = NetworkDataFetcher()
    }
    
    //MARK: - fetch data
    func fetchApod(date: String) {
        //fetch data from local
        let model = self.fetchData(date: date)
        if NetworkManager.sharedInstance.isNetworkConnectionAvailable, let url = URL(string: Urls.apod + date) {
            // fetch data from server
            dataFetcher.requestData(url: url) { (result: ApiResult<ApodModel>) in
                switch result {
                case .success(let returnData) :
                    self.setApodData(apodData: returnData)
                    self.update(favourite: model?.isfav)
                    self.storeApodInDB(model: returnData)
                    self.delegate?.apodFetchCompleted()
                case .failure(let failure) :
                    self.handleFailure(error: failure)
                    break
                }
            }
        } else {
            if model == nil {
                self.delegate?.showError(message: ErrorMessage.noInternet.rawValue)
            }
            else {
                self.delegate?.apodFetchCompleted()
            }
        }
    }
    //MARK: - handle error from server
    private func handleFailure(error: DataError) {
        switch error {
        case .internetError:
            self.delegate?.showError(message: ErrorMessage.noInternet.rawValue)
        case .serverMessage(let errorMsg):
            self.delegate?.showError(message: errorMsg)
        case .unauthorized:
            self.delegate?.showError(message: ErrorMessage.unauthorizedUser.rawValue)
        case .customMessage(let error):
            self.delegate?.showError(message: error.rawValue)
        }
    }
    
    //MARK: - mark apod as favourite
    override func markFavourite() {
        super.markFavourite()
        self.delegate?.apodFetchCompleted()
    }
    
    //MARK: - get webview to play video
    func getVideoPlayer() -> WebViewController? {
        if self.isVideo(), let url = self.getURL() {
            let playerVC = WebViewController.initFromStoryboard(name: .WebView)
            playerVC.url = url
            return playerVC
        }
        return nil
    }
}
