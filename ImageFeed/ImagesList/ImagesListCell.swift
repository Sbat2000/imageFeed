import UIKit
import Kingfisher

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    weak var delegate: ImagesListCellDelegate?
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLikeButton: UIButton!
    @IBOutlet weak var cellDateLabel: UILabel!
    @IBOutlet weak var gradientView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientView.layer.sublayers = nil
        setupGradient()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        gradientView.layer.sublayers = nil
        cellImage.kf.cancelDownloadTask()
    }

    func setupGradient() {
        let colorTop = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 0.0).cgColor
        let colorBot = UIColor(red: 0.1, green: 0.11, blue: 0.13, alpha: 1.0).cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        gradientLayer.cornerRadius = cellImage.layer.cornerRadius
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        gradientLayer.colors = [colorTop, colorBot]
        gradientLayer.locations = [0, 1]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
    }

}

//MARK: - likeButtonClicked
extension ImagesListCell {
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
}

//MARK: - setIsLiked
extension ImagesListCell {
    func setIsLiked(_ likedByUser: Bool) {
        let likeImage = likedByUser ? UIImage(named: "ActiveLikeImage") : UIImage(named: "NoActiveLikeImage")
        if likedByUser {
            cellLikeButton.setImage(likeImage, for: .normal)
        } else if likedByUser == false  {
            cellLikeButton.setImage(likeImage, for: .normal)
        }
    }
}
