//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Гарипов on 17.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet  var likeButton: UIButton!
    
    @IBAction func tap(_ sender: UIButton) {
        imageListService.changeLike(photoId: ImagesListService.shared.photos[0].id, isLike: false) { _ in
            }
    }
    
    @IBAction func tap2(_ sender: UIButton) {
        imageListService.changeLike(photoId: ImagesListService.shared.photos[0].id, isLike: true) { _ in
            }
    }
    
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImagesListService.shared
    private var photos: [Photo] = []
    private var imagesListServiceServiceObserver: NSObjectProtocol?
    
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                self.updateTableViewAnimated()
            }
        imageListService.fetchPhotosNextPage()
        updateTableViewAnimated()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            let image = UIImage(named: photosName[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        //guard let image = UIImage(named: photosName[indexPath.row]) else {return}
        
        //cell.cellImage.image = image
        cell.cellDateLabel.text = dateFormatter.string(from: Date())
        //cell.delegate = self
//        let isLiked = indexPath.row % 2 == 0
//        let likeImage = isLiked ? UIImage(named: "ActiveLikeImage") : UIImage(named: "NoActiveLikeImage")
//        cell.cellLikeButton.setImage(likeImage, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("indexPath.row")
        if indexPath.row + 1 == photos.count {
            self.imageListService.fetchPhotosNextPage()
        }    
    }
}

//MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        guard let image = UIImage(named: photosName[indexPath.row]) else { return 0 }
//        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
//        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
//        let imageWidth = image.size.width
//        let scale = imageViewWidth / imageWidth
//        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        
        let imageSize = photos[indexPath.row].size
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = imageSize.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    

}

//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        let stringPhotoThumbURL = photos[indexPath.row].thumbImageURL
        if let photoThumbURL = URL(string: stringPhotoThumbURL) {
            imageListCell.cellImage.kf.setImage(with: photoThumbURL, placeholder: UIImage(named: "placeholder")) { _ in
                imageListCell.cellImage.kf.indicatorType = .activity
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }

}

// MARK: updateTableViewAnimated

extension ImagesListViewController {
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imageListService.photos.count
        photos = imageListService.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imageListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { result in
            switch result {
            case .success():
                print("OK")
                self.photos = self.imageListService.photos
                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
            }
        }
    }
    
    
}
