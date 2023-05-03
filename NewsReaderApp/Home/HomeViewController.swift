//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import UIKit
import SDWebImage
import SafariServices

// MARK: - UIViewController
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    weak var refreshControl: UIRefreshControl!
    
    weak var collectionView: UICollectionView?
    weak var pageControl: UIPageControl?
    
    var latestNewsList: [News] = []
    var topNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // register NewsViewCell.xib
        tableView.register(UINib(nibName: "NewsViewCell", bundle: nil), forCellReuseIdentifier: "custom_news_cell")
        
        // setup data source
        tableView.dataSource = self
        
        // setup delegate
        tableView.delegate = self
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        self.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.readingListDeleted(_:)), name: .deleteReadingList, object: nil)
        
        refreshControl.beginRefreshing()
        loadLatestNews()
        loadTopNews()
    }
    
    @objc func readingListDeleted(_ sender: Any) {
        tableView.reloadData()
    }
    
    @objc func refresh(_ sender: Any) {
        loadLatestNews()
        loadTopNews()
    }
    
    // MARK: - Helpers
    func loadLatestNews() {
        ApiService.shared.loadLatestNews { [weak self] result in
            guard let `self` = self else { return }
            
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let newsList):
                self.latestNewsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func loadTopNews() {
        ApiService.shared.loadTopNews { [weak self] result in
            guard let `self` = self else { return }
            
            self.refreshControl.endRefreshing()
            switch result {
            case .success(let newsList):
                self.topNewsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return topNewsList.count > 0 ? 1 : 0
        } else {
            return latestNewsList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "top_news_list_cell", for: indexPath) as! TopNewsListViewCell
            
            cell.titleLabel.text = "News For You"
            cell.subtitleLabel.text = "Top \(topNewsList.count) News For You"
            cell.pageControl.numberOfPages = topNewsList.count
            self.pageControl = cell.pageControl
            
            cell.collectionView.dataSource = self
            cell.collectionView.delegate = self
            self.collectionView = cell.collectionView
            cell.collectionView.reloadData()
            
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsViewCell
            
            let news = latestNewsList[indexPath.row]
            
            cell.titleLabel.text = news.title
            cell.dateLabel.text = "\(news.publishDate) • \(news.section)"
            
            // fill the bookmark button if the news is already added
            if CoreDataStorage.shared.isAddedToReadingList(newsId: news.id) {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                cell.bookmarkButton.isEnabled = false
            } else {
                if #available(iOS 13.0, *) {
                    cell.bookmarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                cell.bookmarkButton.isEnabled = true
            }
            
            cell.delegate = self
            
            // access image url from news
            if let url = news.media.first?.metadata.last?.url{
                
                // manually handling image
                /**
                     ApiService.shared.downloadImage(url: url) { result in
                         switch result {
                         case .success(let image):
                             cell.thumbImageView.image = image
                         case .failure:
                             cell.thumbImageView.image = nil
                         }
                     }
                 */

                
                // handling image with SDWebImage
                cell.thumbImageView.sd_setImage(with: URL(string: url))
            }
            else {
                cell.thumbImageView.image = nil
            }
            
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section == 1 else {
            return
        }
        
        let news = latestNewsList[indexPath.row]
        
        if let url = URL(string: news.url) {
            let controller = SFSafariViewController(url: url)
            present(controller, animated: true)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topNewsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "top_news_cell", for: indexPath) as! TopNewsViewCell
        
        let news = topNewsList[indexPath.item]
        
        if let urlString = news.media.first?.metadata.last?.url {
            cell.thumbImageView.sd_setImage(with: URL(string: urlString))
        } else {
            cell.thumbImageView.image = nil
        }
        
        cell.titleLabel.text = news.title
        cell.subtitleLabel.text = "\(news.publishDate) • \(news.section)"
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: 256)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView != self.tableView {
            let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
            pageControl?.currentPage = page
        }
    }
}

// MARK: - NewsViewCellDelegate
extension HomeViewController: NewsViewCellDelegate {
    func newsViewCellBookmarkButtonTapped(_ cell: NewsViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let news = latestNewsList[indexPath.row]
            
            CoreDataStorage.shared.addReadingList(news: news)
            
            let readingList = CoreDataStorage.shared.getReadingList()
            print(readingList.count)
            
            if #available(iOS 13.0, *) {
                cell.bookmarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            } else {
                // Fallback on earlier versions
            }
            cell.bookmarkButton.isEnabled = false
        }
    }
}

// MARK: - TopNewsListViewCellDelegate
extension HomeViewController: TopNewsListViewCellDelegate {
    func topNewsListViewCellPageControlValueChanged(_ cell: TopNewsListViewCell) {
        let page = cell.pageControl.currentPage
        collectionView?.scrollToItem(at: IndexPath(item: page, section: 0), at: .centeredHorizontally, animated: true)
    }
}
