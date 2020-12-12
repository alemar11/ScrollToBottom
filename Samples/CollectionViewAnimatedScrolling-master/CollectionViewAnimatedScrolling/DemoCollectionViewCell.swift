//  Created by dasdom on 28.08.20.
//  Copyright © 2020 dasdom. All rights reserved.
//

import UIKit

class DemoCollectionViewCell: UICollectionViewCell {
  
  let label: UILabel
  
  override init(frame: CGRect) {
    
    label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .preferredFont(forTextStyle: .footnote)
    label.textColor = .white
    
    super.init(frame: frame)
    
    contentView.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ])
  }
  
  required init?(coder: NSCoder) { fatalError() }
}

extension DemoCollectionViewCell {
  func update(with number: Int) {
    label.text = "\(number)"
    contentView.backgroundColor = .init(hue: CGFloat(number)/CGFloat(1000), saturation: 1, brightness: 1, alpha: 1)
  }
}
