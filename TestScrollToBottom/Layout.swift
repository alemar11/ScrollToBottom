import UIKit

class Layout: UICollectionViewLayout {
  private var cache: [UICollectionViewLayoutAttributes] = []

  private var contentWidth: CGFloat{
    guard let collectionView = collectionView else { return .zero
    }
    return collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
  }

  private var contentHeight : CGFloat = 0

  override var collectionViewContentSize: CGSize{
    return CGSize(width: contentWidth, height: contentHeight)
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []
    for attributes in cache {
      if attributes.frame.intersects(rect) {
        visibleLayoutAttributes.append(attributes)
      }
    }
    return visibleLayoutAttributes
  }

  override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    cache[indexPath.item]
  }

  override func prepare() {
    guard let collectionView = collectionView else {
      return
    }

    cache.removeAll()

    let vSpacing: CGFloat = 10
    var yOrigin: CGFloat = 0
    contentHeight = 0

    for item in 0..<collectionView.numberOfItems(inSection: 0) {
      let indexPath = IndexPath(item: item, section: 0)
      let itemHeight: CGFloat = 80

      let frame = CGRect(x: 0, y: yOrigin, width: contentWidth, height: itemHeight)
      yOrigin += itemHeight + vSpacing

      let attributes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
      attributes.frame = frame

      cache.append(attributes)
      contentHeight = max(contentHeight, yOrigin)
    }
  }

//  override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//    let attr = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
//    attr?.alpha = 1.0
//    return attr
//  }
}
