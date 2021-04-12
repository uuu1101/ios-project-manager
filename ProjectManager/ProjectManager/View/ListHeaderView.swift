import UIKit

class ListHeaderView: UICollectionReusableView {
    private var stateLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var itemCountView: UIView = {
        // 숫자 두자리 되면 어떻게 되는지..?
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private var itemCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemGray6
        // 숫자 두자리 되면 어떻게 되는지..? 밑에꺼 작동하나??
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var bottomLineView: UIView = {
        // 숫자 두자리 되면 어떻게 되는지..?
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var isUpdated: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setupInfo(state: State, count: Int) {
        stateLabel.text = state.rawValue.uppercased()
        itemCountLabel.text = "\(count)"
        updateConstraints()
    }
    
    func updateCount(_ count: Int) {
        itemCountLabel.text = "\(count)"
        //setNeedsLayout()
    }
    
    private func setupUI() {
        addSubview(stateLabel)
        addSubview(itemCountView)
        addSubview(itemCountLabel)
        addSubview(bottomLineView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        itemCountView.layer.cornerRadius = itemCountView.bounds.height / 2 // 여기서 해줘야하는 이유.. ?
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        // 자주 불려서 -> WWDC 권장?
        if isUpdated == false {
            let lineSpacing = CGFloat(10)
            let separator = CGFloat(1)
            let inset = CGFloat(10)
            
            NSLayoutConstraint.activate([
                stateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
                stateLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset),
                itemCountView.leadingAnchor.constraint(equalTo: stateLabel.trailingAnchor, constant: 10),
                itemCountView.heightAnchor.constraint(equalTo: stateLabel.heightAnchor, multiplier: 1), // 2/3
                itemCountView.widthAnchor.constraint(equalTo: itemCountView.heightAnchor, multiplier: 1),
                itemCountView.centerYAnchor.constraint(equalTo: stateLabel.centerYAnchor),
                itemCountLabel.centerXAnchor.constraint(equalTo: itemCountView.centerXAnchor),
                itemCountLabel.centerYAnchor.constraint(equalTo: itemCountView.centerYAnchor),
                bottomLineView.heightAnchor.constraint(equalToConstant: separator),
                bottomLineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -lineSpacing),
                bottomLineView.leadingAnchor.constraint(equalTo: leadingAnchor),
                bottomLineView.trailingAnchor.constraint(equalTo: trailingAnchor),
                bottomLineView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: inset)
            ])
            isUpdated = true
        }
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let autoLayoutAttributes = super.preferredLayoutAttributesFitting(layoutAttributes)

        // Specify you want _full width_
        // layout.estimatedItemSize 에서 넣어준 width 가 layoutAttributes.frame.width 로 들어옴
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        
        // Calculate the size (height) using Auto Layout
        let autoLayoutSize = systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriority.required, verticalFittingPriority: UILayoutPriority.defaultLow)
        let autoLayoutFrame = CGRect(origin: autoLayoutAttributes.frame.origin, size: autoLayoutSize)

        // Assign the new size to the layout attributes
        autoLayoutAttributes.frame = autoLayoutFrame
        return autoLayoutAttributes
    }
}
