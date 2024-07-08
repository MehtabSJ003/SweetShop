import UIKit

class PickerRowView: UIView {
    
    // UIImageView to display the donut image
    let donutImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // UILabel to display the product name and price
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Initializer when creating the view programmatically
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView() // Setup the view layout and constraints
    }
    
    // Initializer when creating the view from a storyboard or XIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView() // Setup the view layout and constraints
    }
    
    // Private method to setup the view layout and constraints
    private func setupView() {
        addSubview(donutImageView)
        addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            // Constraints for donutImageView
            donutImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            donutImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            donutImageView.widthAnchor.constraint(equalToConstant: 40),
            donutImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Constraints for nameLabel
            nameLabel.leadingAnchor.constraint(equalTo: donutImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    // Method to configure the nameLabel and donutImageView with product details
    func configure(with product: Donut) {
        nameLabel.text = "\(product.shortName) - $\(product.price)"
        donutImageView.image = UIImage(named: product.imageName)
    }
}
