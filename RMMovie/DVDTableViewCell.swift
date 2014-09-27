import UIKit

class DVDTableViewCell: UITableViewCell {
    @IBOutlet  var labelTitle: UILabel!
    @IBOutlet  var labelSynopsis: UILabel!
    @IBOutlet  var imgPosterThumbnail: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
