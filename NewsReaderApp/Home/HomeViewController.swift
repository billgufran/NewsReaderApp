//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import UIKit
import SDWebImage

// MARK: - UIViewController
class HomeViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var latestNewsList: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // setup data source
        tableView.dataSource = self
        
        // setup delegate
        tableView.delegate = self
        
        
        loadLatestNews()
    }
    

    func loadLatestNews() {
        ApiService.shared.loadLatestNews { result in
            switch result {
            case .success(let newsList):
                self.latestNewsList = newsList
                self.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}


// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return latestNewsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "custom_news_cell", for: indexPath) as! NewsViewCell
        
        let news = latestNewsList[indexPath.row]
        
        cell.titleLabel.text = news.title
        cell.dateLabel.text = "\(news.publishDate) • \(news.section)"
        
        // access image url from news
        if let url = news.media.first?.metadata.last?.url{
            
            // manually handling image
//            ApiService.shared.downloadImage(url: url) { result in
//                switch result {
//                case .success(let image):
//                    cell.thumbImageView.image = image
//                case .failure:
//                    cell.thumbImageView.image = nil
//                }
//            }
            
            // handling image with SDWebImage
            cell.thumbImageView.sd_setImage(with: URL(string: url))
        }
        else {
            cell.thumbImageView.image = nil
        }
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = latestNewsList[indexPath.row]
        
        let alert = UIAlertController(title: news.title, message: news.url, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default))
        
        present(alert, animated: true)
    }
}
