import UIKit


final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLikeButton: UIButton!
    @IBOutlet weak var cellDateLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellImage.layer.sublayers = nil
        setupGradient()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.layer.sublayers = nil
    }
    
    func setupGradient() {
        let height = bounds.height
        let width = bounds.width
        let heightGradient: CGFloat = 30
        
        let colorTop = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.0).cgColor
        let colorBot = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1.0).cgColor
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: height - heightGradient, width: width, height: heightGradient)
        gradientLayer.colors = [colorTop, colorBot]
        cellImage.layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
