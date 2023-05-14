//
//  ViewController.swift
//  ImageFeed
//
//  Created by Александр Гарипов on 17.02.2023.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
  
    @IBOutlet private weak var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    private let imageListService = ImagesListService.shared
    private var photos: [Photo] = []
    private var imagesListServiceServiceObserver: NSObjectProtocol?
    internal var presenter: ImagesListPresenterProtocol?
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    internal func configure(_ presenter: ImagesListPresenterProtocol) {
        self.presenter = presenter
        self.presenter?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        imagesListServiceServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.DidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            presenter?.updateTableViewAnimated()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        imageListService.fetchPhotosNextPage()
        presenter?.updateTableViewAnimated()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            guard let stringLargeImageURL = presenter?.photos[indexPath.row].largeImageURL else { return }
            if let urlLargeImage = URL(string: stringLargeImageURL) {
                viewController.urlImage = urlLargeImage
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        if let date = presenter?.photos[indexPath.row].createdAt {
            cell.cellDateLabel.text = dateFormatter.string(from: date)
        }
        cell.delegate = self
        guard let isLiked = presenter?.photos[indexPath.row].isLiked else { return }
        let likeImage = isLiked ? UIImage(named: "ActiveLikeImage") : UIImage(named: "NoActiveLikeImage")
        cell.cellLikeButton.setImage(likeImage, for: .normal)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        presenter?.needsNewPhoto(indexPath: indexPath)
    }
}

//MARK: - UITableViewDelegate

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight: CGFloat?
        
        if let imageSize = presenter?.photos[indexPath.row].size {
            let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
            let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
            let imageWidth = imageSize.width
            let scale = imageViewWidth / imageWidth
            cellHeight = imageSize.height * scale + imageInsets.top + imageInsets.bottom
        }
        return cellHeight!
    }
}

//MARK: - UITableViewDataSource

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = presenter?.photos.count else { return 0 }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        imageListCell.delegate = self
        if let stringPhotoThumbURL = presenter?.photos[indexPath.row].thumbImageURL {
            if let photoThumbURL = URL(string: stringPhotoThumbURL) {
                imageListCell.cellImage.kf.setImage(with: photoThumbURL, placeholder: UIImage(named: "placeholder")) { _ in
                    imageListCell.cellImage.kf.indicatorType = .activity
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
    
}

//MARK: - ImagesListCellDelegate
extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter?.imageListCellDidTapLike(indexPath: indexPath)
    }
}


//MARK: - ImagesListPresenterDelegate

extension ImagesListViewController: ImagesListPresenterDelegate {
    func blockUI() {
        UIBlockingProgressHUD.show()
    }
    
    func unblockUI() {
        UIBlockingProgressHUD.dismiss()
    }
    
    func updateLikeStatus(_ indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell else { return }
        guard let photo = presenter?.photos[indexPath.row] else { return }
        cell.setIsLiked(photo.isLiked)
    }
    
    func updateTableViewAnimated(indexPaths: [IndexPath]) {
        tableView.performBatchUpdates {
            tableView.insertRows(at: indexPaths, with: .automatic)
        } completion: { _ in }
    }
}
