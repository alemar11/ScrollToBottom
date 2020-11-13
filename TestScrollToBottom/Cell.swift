import UIKit

class Cell: UICollectionViewCell {
  static let reusableID = "CellID"

  public lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var background: UIView = {
    let background = UIView()
    background.translatesAutoresizingMaskIntoConstraints = false
    background.backgroundColor = .gray
    return background
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
    contentView.addSubview(background)

    let topBackground = background.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0)
    let bottomBackground  = background.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
    let leadingBackground  = background.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    let trailingBackground  = background.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)

    NSLayoutConstraint.activate([topBackground, bottomBackground, leadingBackground, trailingBackground])

    background.addSubview(label)
    let topLabel = label.topAnchor.constraint(equalTo: background.topAnchor, constant: 20)
    let bottomLabel = label.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20)
    let leadingLabel = label.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 20)
    let trailingLabel = label.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -20)
    NSLayoutConstraint.activate([topLabel , bottomLabel,  trailingLabel, leadingLabel])
  }

}
