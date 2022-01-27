//
//  APODTableViewCell.swift
//  GS-APOD
//
//  Created by Rahul Chaudhary on 26/01/22.
//

import UIKit
import SDWebImage

class APODTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var bgView: UIView!

    let apodTableViewCellVM = APODTableViewCellVM()
    
    /// Cell reuse identifier
    class var identifier: String {
        return String(describing: self)
    }
    
    /// UINib attached with this class
    class var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
        bindViewPropertyWithVM()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    private func setUpUI() {
        bgView.layer.cornerRadius = 10
        bgView.layer.masksToBounds = true
    }
    
    /// Bind the Cell's UI properties (V) with ViewModel (VM)
    private func bindViewPropertyWithVM() {
        apodTableViewCellVM.bindDate = { [weak self] str in
            self?.dateLabel.text = str
        }
        apodTableViewCellVM.bindTitle = { [weak self] str in
            self?.titleLabel.text = str
        }
        apodTableViewCellVM.bindImageUrl = { [weak self] url in
            self?.imgView?.sd_setImage(with: url, completed: nil)
        }
        apodTableViewCellVM.bindExplanation = { [weak self] str in
            self?.explanationLabel.text = str
        }
        apodTableViewCellVM.bindIsFavourite = { [weak self] isFavourite in
            self?.favBtn.isSelected = isFavourite
        }
    }
    
    //MARK: - Btn Action
    
    @IBAction func favBtnAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        apodTableViewCellVM.setAPODFavourite(isFav: sender.isSelected)
    }
}
