//
//  NoteCellTableViewCell.swift
//  MoveoTest
//
//  Created by Ruben Mimoun on 12/11/2021.
//

import UIKit

class NoteCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var loadingImageView: LoadingImageView!
    
    var viewModel : NoteCellViewModel? {
        didSet{
            viewModel?.bind(noteCell: self)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        loadingImageView.imageHolder.image = UIImage(systemName: "questionmark.circle")
    }
}
