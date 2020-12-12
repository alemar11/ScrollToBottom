import UIKit
import Combine

let animationDuration: TimeInterval = 3.25

class ViewController: UIViewController {
  private var items = [Int]()
  private var cancellable: AnyCancellable?

  lazy var collectionView: UICollectionView = {
    let layout = Layout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.keyboardDismissMode = .interactive
    collectionView.alwaysBounceVertical = true
    collectionView.showsVerticalScrollIndicator = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.allowsSelection = false
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInsetAdjustmentBehavior = .never
    collectionView.backgroundColor = .clear
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .black
    collectionView.contentInset = .init(top: 8, left: 0, bottom: 0, right: 0)
    return collectionView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.register(Cell.self, forCellWithReuseIdentifier: Cell.reusableID)
    view.backgroundColor = .systemBackground
    view.addSubview(collectionView)
    let top = collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
    let bottom = collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    let leading = collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
    let trailing = collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
    NSLayoutConstraint.activate([top, bottom, trailing, leading])


    let plus = UIBarButtonItem(title: "New Item", style: .plain, target: self, action: #selector(addItem))
    navigationItem.rightBarButtonItems = [plus]
  }

  deinit {
    collectionView.delegate = nil
    collectionView.dataSource = nil
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.items = (0..<20).map { $0 }
    collectionView.reloadData()
    collectionView.collectionViewLayout.prepare()
    collectionView.scrollToBottom(animated: false)
  }

  private var shouldScrollToTheBottom = true

  @objc
  private func addItem() {
    UIView.animate(withDuration: animationDuration) {
    self.collectionView.performBatchUpdates {
      var newItem = 0
      if let lastItem = self.items.last {
        newItem = lastItem + 1
      }
      self.items.append(newItem)

      self.collectionView.insertItems(at: [IndexPath(row: newItem, section: 0)])
    } completion: { (_) in

    }
    }

    if self.shouldScrollToTheBottom {
      self.scrollToBottom(animated: true)
      print("scroll to the bottom")
    } else {
      print("keep the current position")

    }
  }

  func scrollToBottom(animated: Bool) {
    // self.collectionView.scrollToItem(at: IndexPath(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
    
    let animationDuration: TimeInterval = animated ? 2 : 0
    //UIView.animate(withDuration: animationDuration) {
    //self.collectionView.setValue(animationDuration, forKey: "contentOffsetAnimationDuration")
      self.collectionView.scrollToItem(at: IndexPath(row: self.items.count - 1, section: 0), at: .bottom, animated: true)
    //}
  }

}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { items.count }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.reusableID, for: indexPath)
    let chatCell = cell as! Cell
    let item = items[indexPath.row]
    chatCell.label.text = "\(item)"
    return chatCell
  }
}

extension ViewController {
  open func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if collectionView.isDragging && !collectionView.isDecelerating {
      shouldScrollToTheBottom = collectionView.isScrolledAtBottomEdge()
    } else {
      //wait for scrollViewDidEndDecelerating
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    shouldScrollToTheBottom = collectionView.isScrolledAtBottomEdge()
  }

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    shouldScrollToTheBottom = collectionView.isScrolledAtBottomEdge()
  }
}


extension UICollectionView {
  var contentVisibleArea: CGRect {
    let rect = CGRect(origin: .zero, size: collectionViewLayout.collectionViewContentSize)
    return rect.intersection(bounds)
  }

  func scrollToBottom(animated: Bool = true) {
    let offsetY = max(-contentInset.top, collectionViewLayout.collectionViewContentSize.height - bounds.height + contentInset.bottom)
    let offset = CGPoint(x: 0, y: offsetY)
    setContentOffset(offset, animated: animated)
  }

  func frameForItem(at indexPath: IndexPath) -> CGRect? {
    collectionViewLayout.layoutAttributesForItem(at: indexPath)?.frame
  }

  func isItemFullyVisibleAtIndexPath(_ indexPath: IndexPath) -> Bool {
    guard let attributes = collectionViewLayout.layoutAttributesForItem(at: indexPath) else { return false }
    let intersection = contentVisibleArea.intersection(attributes.frame)
    return intersection == attributes.frame
  }

  func isScrolledAtBottomEdge() -> Bool {
    guard numberOfSections > 0 && numberOfItems(inSection: 0) > 0 else { return true }

    let sectionIndex = numberOfSections - 1
    let itemIndex = numberOfItems(inSection: sectionIndex) - 1
    let lastIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
    return isItemFullyVisibleAtIndexPath(lastIndexPath)
  }
}
