import UIKit

class ListTableViewCell: UITableViewCell{
    @IBOutlet  var labelTitle: UILabel!
    @IBOutlet  var labelSynopsis: UILabel!
    @IBOutlet  var imgPosterThumbnail: UIImageView!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
