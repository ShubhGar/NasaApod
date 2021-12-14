//
//  FavouriteTableViewCell.swift
//  NasaApod
//
//  Created by Shubham Garg on 14/12/21.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var playVideoBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    private var viewModel: FavouriteViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        playVideoBtn.isUserInteractionEnabled = false
        // Configure the view for the selected state
    }
    
    @IBAction func favBtnAxn(_ sender: UIButton) {
        viewModel?.markFavourite()
    }
    
    //MARK:- setup cell data
    func setupData(viewModel: FavouriteViewModel) {
        self.viewModel = viewModel
        self.titleLbl.text = viewModel.getTitle()
        self.descLbl.text = viewModel.getExplanation()
        self.dateLbl.text = viewModel.getDate()
        if self.viewModel?.isVideo() ?? false {
            self.playVideoBtn.isHidden = false
            self.viewModel?.getThumbnailImageForVideo(completion: { [weak self] image in
                self?.apodImageView.image = image
            })
        }
        else{
            self.playVideoBtn.isHidden = true
            if let url = self.viewModel?.getURL() {
                self.apodImageView.sd_setImage(with: url, completed: nil)
            }
        }
        self.favBtn.isSelected = viewModel.isFavourite()
    }
    
}
