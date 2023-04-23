
import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {

//    var image: UIImage! {
//        didSet {
//            guard isViewLoaded else {return}
//            imageView.image = image
//            rescaleAndCenterImageInScrollView(image: image)
//        }
//    }
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    var urlImage: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        showImage(largeURL: urlImage!)
//        imageView.image = UIImage(named: "placeholder")
//        imageView.image = image
//        rescaleAndCenterImageInScrollView(image: imageView.image!)
    }
    
    @IBAction func didTapBackButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapShareButton(_ sender: UIButton) {
        let share = UIActivityViewController (activityItems: [imageView.image!], applicationActivities: nil)
        present(share, animated: true, completion: nil)
    }
    
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}


//MARK: - KingFisher largeImage show

extension SingleImageViewController {
    private func showImage(largeURL: URL) {
        guard isViewLoaded else {return}
        let imageView = UIImageView()
        UIBlockingProgressHUD.show()
        imageView.kf.setImage(with: largeURL,
                                    placeholder: UIImage(named: "placeholder")) { [weak self] result in
            UIBlockingProgressHUD.dismiss()
            guard let self else {return}
            switch result {
            case .success(let imageResult):
                self.imageView.image = imageResult.image
                self.rescaleAndCenterImageInScrollView(image: imageResult.image)
            case .failure:
                showError()
            }
        }
    }
    
    private func showError() {
        let alert = UIAlertController(title: "Что-то пошло не так", message: "Попробовать ещё раз?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Отмена", style: .default) { _ in
            alert.dismiss(animated: true)
        }
        let retryAction = UIAlertAction(title: "Повторить",
                                        style: .default) {_ in
            self.showImage(largeURL: self.urlImage!)
            alert.dismiss(animated: true)
            
        }
        alert.addAction(cancelAction)
        alert.addAction(retryAction)
        present(alert, animated: true)
    }
}
