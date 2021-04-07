import UIKit

class ItemListCell: UICollectionViewCell {
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    private var bodyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = .systemGray
        return label
    }()
    private var deadlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption1)
        label.textColor = .systemRed
        return label
    }()
    private var bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var id: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        id = nil
        titleLabel.text = nil
        bodyLabel.text = nil
        deadlineLabel.text = nil
    }
    
    func setItem(_ item: Item) {
        id = item.id
        titleLabel.text = item.title
        bodyLabel.text = item.body
        deadlineLabel.text = "\(item.deadline)"
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)
        contentView.addSubview(deadlineLabel)
        contentView.addSubview(bottomLineView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            deadlineLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            deadlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            deadlineLabel.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 5),
            bottomLineView.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor, constant: 10),
            bottomLineView.heightAnchor.constraint(equalToConstant: 1),
            bottomLineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomLineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomLineView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // Specify you want _full width_
        // layout.estimatedItemSize 에서 넣어준 width 가 layoutAttributes.frame.width 로 들어옴
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        
        // Calculate the size (height) using Auto Layout
        let autoLayoutSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

        // Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
}
