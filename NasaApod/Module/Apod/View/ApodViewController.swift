//
//  ApodViewController.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import UIKit
import SDWebImage

class ApodViewController: UIViewController, StoryboardInitializable {
    
    @IBOutlet weak var selectDateTf: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var playVideoBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    private var viewModel: ApodViewModel?
    var selectedDate: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addDatePicker()
        viewModel = ApodViewModel(delegate: self)
        self.setupRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.getData(date: selectDateTf.text ?? "")
    }
    
    //MARK: - add datepicker on textfield click
    private func addDatePicker() {
        let datePicker = UIDatePicker()
        //Format Date
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        //ToolBar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Constants.DONE, style: .plain, target: self, action: #selector(doneDatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: Constants.CANCEL, style: .plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        selectDateTf.inputAccessoryView = toolbar
        selectDateTf.inputView = datePicker
    }
    
    //MARK: - set up right bar button according to screen
    func setupRightBarButton() {
        selectDateTf.text = selectedDate ?? Date().toString()
        if selectedDate != nil {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    //MARK: - get data from server
    private func getData(date: String) {
        self.view.showProgressIndicator()
        viewModel?.fetchApod(date: date)
    }
    
    //MARK: - setup view data
    private func setupData() {
        self.titleLbl.text = self.viewModel?.getTitle()
        self.descLbl.text = self.viewModel?.getExplanation()
        self.dateLbl.text = self.viewModel?.getDate()
        if self.viewModel?.isVideo() ?? false {
            self.playVideoBtn.isHidden = false
            self.viewModel?.getThumbnailImageForVideo(completion: { [weak self] image in
                self?.imageView.image = image
            })
        }
        else{
            self.playVideoBtn.isHidden = true
            if let url = self.viewModel?.getURL() {
                self.imageView.sd_setImage(with: url, completed: nil)
            }
        }
        self.favBtn.isSelected = self.viewModel?.isFavourite() ?? false
    }
    
    //MARK: - done click after date selection
    @objc private func doneDatePicker() {
        let picker = selectDateTf.inputView as? UIDatePicker
        selectDateTf.text = picker?.date.toString()
        self.getData(date: selectDateTf.text ?? "")
        self.view.endEditing(true)
    }
    
    //MARK: - cancel button click
    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
    }
    
    //MARK: - play video on player
    @IBAction func playVideoBtnAxn(_ sender: Any) {
        if let playerVC = viewModel?.getVideoPlayer() {
            self.navigationController?.pushViewController(playerVC, animated: true)
        }
    }
    
    //MARK: - mark favourite axn
    @IBAction func favBtnAxn(_ sender: UIButton) {
        viewModel?.markFavourite()
    }
    
    
}

extension ApodViewController : ApodViewerProtocol {
    //MARK: - update screen after getting data
    func apodFetchCompleted() {
        DispatchQueue.main.async {
            self.view.hideProgressIndicator()
            self.setupData()
        }
    }
    
    //MARK: - show error alert
    func showError(message: String) {
        DispatchQueue.main.async {
            self.view.hideProgressIndicator()
            self.showAlert(withMessage: message)
        }
    }
}
