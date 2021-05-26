//
//  ViewController.swift
//  TwitchCategories
//
//  Created by ADMIN ODoYal on 23.05.2021.
//

import UIKit
import Network
import Alamofire

class TopCategoriesViewController: UIViewController {
    private var categories: [CategoryDetails] = [CategoryDetails]()
    fileprivate var categoryNumbers: Int = 0
    final let categoryEntityManager = CategoryEntityCoreDataManager.shared
    private let API: String = "https://api.twitch.tv/kraken/games/top?client_id=sd4grh0omdj9a31exnpikhrmsu3v46&api_version=5&limit=100"
    fileprivate let monitor = NWPathMonitor()
    
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let queue = DispatchQueue.global(qos: .background)
        
        configureTableView()
        monitor.pathUpdateHandler = { [self] path in
            if NetworkConnection.isConnectedToInternet {
                fetchAllTopCategories()
                print("We're connected!")
            } else {
                if categories.count == 0 {
                    DispatchQueue.main.async {
                        setTopCategories()
                    }
                }
                print("No connection")
            }
        }
        monitor.start(queue: queue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
    }
}

// MARK: Internal func
extension TopCategoriesViewController {
    @objc func checkNetworkConnection() {
    }
    func fetchAllTopCategories() {
        AF.request(API, method: .get).responseJSON { [self] (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    return
                }
                do {
                    let jsonData = try JSONDecoder().decode(Categories.self, from: data)
                    clearTableView()
                    for entity in jsonData.top {
                        categoryEntityManager.add(entity)
                    }
                    DispatchQueue.main.async {
                        setTopCategories()
                    }
                } catch  {
                    print(error)
                }
                
            case .failure(let err):
                print(err.errorDescription!)
            }
        }
    }
    
    private func clearTableView() {
        categoryEntityManager.clear()
        categoryNumbers = 0
        categories = []
        scrollToFirstCell()
        tableView.reloadData()
    }
    
    private func scrollToFirstCell(){
        if categories.count - 1 > 0 {
            let indexPath = IndexPath.init(row: categories.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    private func setTopCategories() {
        categories += categoryEntityManager.all(with: categoryNumbers)
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TopCategoryTableViewCell.nib, forCellReuseIdentifier: TopCategoryTableViewCell.identifier)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
}

// MARK: UITableViewDelegate
extension TopCategoriesViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height {
            guard categories.count >= categoryNumbers + 10 else {
                print("There are no categories for fetch")
                return
            }
            categoryNumbers += 10
            setTopCategories()
        }
    }
}

// MARK: UITableViewDataSource
extension TopCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TopCategoryTableViewCell.identifier, for: indexPath) as! TopCategoryTableViewCell
        cell.category = categories[indexPath.row]
        
        return cell
    }
}
