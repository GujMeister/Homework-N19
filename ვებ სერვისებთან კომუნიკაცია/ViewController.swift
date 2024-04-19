import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var newsData: ImediNewsModel?
    
    private let newsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 24)
        label.text = "Panicka News"
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.register(NewsCell.self, forCellReuseIdentifier: "NewsCell")
        tableView.separatorInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchData()
    }
    
    // MARK: - UI setup
    func setupUI() {
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        view.addSubview(newsLabel)
        view.addSubview(tableView)
        
        newsLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            newsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            newsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            tableView.topAnchor.constraint(equalTo: newsLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK: - Helper Functions
    func fetchData() {
        Task {
            do {
                let data = try await getImediData()
                self.newsData = data
                DispatchQueue.main.async {
                    self.updateUI()
                }
            } catch {
                print("Error fetching data: \(error)")
            }
        }
    }
    
    func updateUI() {
        tableView.reloadData()
    }
}

     // MARK: - Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = newsData?.list?.count {
            return data
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        if let newsItem = newsData?.list?[indexPath.row] {
            cell.configureCell(with: newsItem.time ?? "", description: newsItem.title ?? "", imageUrl: newsItem.photoUrl)
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
}

      // MARK: - Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        return screenHeight / 5.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let newsData = newsData, let article = newsData.list?[indexPath.row] {
            let detailsVC = DetailsViewController()
            detailsVC.newsArticle = article
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}

#Preview() {
    ViewController()
}
