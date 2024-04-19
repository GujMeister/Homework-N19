import UIKit

class DetailsViewController: UIViewController {
    
    // MARK: - Properties
    var newsArticle: List?
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .center
        label.font = UIFont(name: "SpaceGrotesk-Regular", size: 24)
        label.text = "Details"
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "wifi.exclamationmark.circle")
        image.contentMode = .scaleAspectFill
        image.backgroundColor = .secondarySystemBackground
        image.layer.cornerRadius = 21
        image.layer.masksToBounds = true
        return image
    }()
    
    private lazy var infoStacKview: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5

        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(infoTextView)
        
        return stackView
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.textAlignment = .right
        label.font = UIFont(name: "FiraGO-Bold", size: 16)
        label.text = newsArticle?.time ?? "აქ იქნება დრო"
        return label
    }()
    
    private lazy var infoTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = .label
        textView.textAlignment = .left
        textView.font = UIFont(name: "FiraGO-Bold", size: 14)
        textView.text = newsArticle?.title ?? "აქ იქნება ინფო"
        return textView
    }()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadImage()
    }
    
    // MARK: - UI
    func setupUI() {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .systemBackground
        
        view.addSubview(detailsLabel)
        view.addSubview(imageView)
        view.addSubview(infoStacKview)
        infoStacKview.addSubview(timeLabel)
        
        detailsLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        infoStacKview.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            detailsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            imageView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 10),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 190/812),
            
            infoStacKview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 36),
            infoStacKview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -36),
            infoStacKview.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            infoStacKview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 100),
            
            timeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    // MARK: - Helper Functions
    func loadImage() {
        guard let imageUrlString = newsArticle?.photoUrl, let imageUrl = URL(string: imageUrlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { [weak self] (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self?.imageView.image = image
            }
        }.resume()
    }
}

#Preview() {
    DetailsViewController()
}
