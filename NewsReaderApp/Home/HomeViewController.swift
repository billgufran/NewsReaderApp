//
//  HomeViewController.swift
//  NewsReaderApp
//
//  Created by Muhammad Fikri Bill Gufran on 28/4/23.
//

import UIKit

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "news_cell", for: indexPath)
        let news = latestNewsList[indexPath.row]
        
        cell.textLabel?.text =  "\(indexPath.row + 1).  \(news.title)"
        
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
