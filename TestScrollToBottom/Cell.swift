import UIKit

class Cell: UICollectionViewCell {
  static let reusableID = "CellID"

  public lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  public override init(frame: CGRect) {
      super.init(frame: frame)
      setup()
  }

  required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      setup()
  }

  private func setup() {
    contentView.addSubview(label)
    let top = label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20)
    let bottom = label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
    let leading = label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
    let trailing = label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
    NSLayoutConstraint.activate([top, bottom, trailing, leading])
  }
}
