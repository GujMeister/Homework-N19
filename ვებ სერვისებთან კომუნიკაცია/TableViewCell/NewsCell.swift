import UIKit

class NewsCell: UITableViewCell {
    
    // MARK: - Properties
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont(name: "FiraGO-Bold", size: 12)
        label.textColor = .white
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont(name: "FiraGO-Bold", size: 14)
        label.textColor = .white
        
        //სურათი თუ თეთრია და ტექსტიც თეთრია არ ჩანდა და ტექსტს outline დავადე ადვილად საკიტხავი რო იყოს
        let strokeTextAttributes = [
          NSAttributedString.Key.strokeColor : UIColor.black,
          NSAttributedString.Key.foregroundColor : UIColor.white,
          NSAttributedString.Key.strokeWidth : -3.0,
          NSAttributedString.Key.font : UIFont(name: "FiraGO-Bold", size: 14)!]
          as [NSAttributedString.Key : Any]

        label.attributedText = NSMutableAttributedString(string: "Your outline text", attributes: strokeTextAttributes)
        
        return label
    }()
    
    let bulliedView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 5
        
        stackView.addArrangedSubview(timeLabel)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(bulliedView)
        
        return stackView
    }()
    
    let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 7.5, left: 0, bottom: 7.5, right: 0))
    }
    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: "NewsCell")
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        
        contentView.addSubview(newsImageView)
        contentView.addSubview(stackView)
        
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            newsImageView.topAnchor.constraint(equalTo: topAnchor),
            newsImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 23.5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -23.5),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Function
    func configureCell(with time: String, description: String, imageUrl: String?) {
        timeLabel.text = time
        descriptionLabel.text = description
        
        if let imageUrlString = imageUrl, let imageUrl = URL(string: imageUrlString) {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        self.newsImageView.image = UIImage(data: data)
                    }
                } else {
                    print("Error downloading image: \(error?.localizedDescription ?? "Unknown error")")
                }
            }.resume()
        } else {
            self.newsImageView.image = UIImage(named: "placeholderImage")
        }
    }
}

#Preview() {
    ViewController()
}
