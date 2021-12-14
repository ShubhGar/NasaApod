//
//  FavouritesViewController.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import UIKit

class FavouritesViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: FavouritesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = FavouritesViewModel(delegate: self)
        tableView.delegate = self
        tableView.dataSource  = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData()
    }
    
    //MARK:- Get list of favourites
    private func getData() {
        self.view.showProgressIndicator()
        viewModel?.fetchFavourites()
    }
    
}
//MARK:- setup tableview
extension FavouritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getNumberOfRows() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FavouriteTableViewCell.identifier, for: indexPath) as! FavouriteTableViewCell
        if let vm = viewModel?.getViewModel(for: indexPath.row) {
            cell.setupData(viewModel: vm)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let playerVC = viewModel?.getDetailVC(for: indexPath.row) {
            self.navigationController?.pushViewController(playerVC, animated: true)
        }
    }
    
}

extension FavouritesViewController: FavouritesViewerProtocol {
    //MARK:- update single cell
    func updateFavItem(at index: Int) {
        DispatchQueue.main.async {
            self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
        }
    }
    //MARK:- update tableview after getting all the data
    func favouritesFetchCompleted() {
        DispatchQueue.main.async {
            self.view.hideProgressIndicator()
            self.tableView.reloadData()
        }
    }
    //MARK:- Show error alert
    func showError(message: String) {
        DispatchQueue.main.async {
            self.view.hideProgressIndicator()
            self.showAlert(withMessage: message)
        }
    }
}

