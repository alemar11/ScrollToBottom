//  Created by dasdom on 28.08.20.
//  Copyright © 2020 dasdom. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class DemoCollectionViewController: UICollectionViewController {
  
  private var displayLink: CADisplayLink?
  private var startTimestamp: TimeInterval = 0
  lazy private var maxOffset = collectionView.contentSize.height - collectionView.frame.size.height
  private let duration: Double = 2
  private var startOffset: CGFloat = 0
  private var previousFraction = 0.0
  private var items = [Int]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.items = (0..<1000).map { $0 }
    self.collectionView!.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "animator", style: .plain, target: self, action: #selector(scrollDownAnimator))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "CADisplayLink", style: .plain, target: self, action: #selector(scrollDownDisplayLink))
  }
  
  // MARK: UICollectionViewDataSource
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return self.items.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    print("indexPath.row: \(indexPath.row)")
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DemoCollectionViewCell
    cell.update(with: indexPath.row)
    return cell
  }
}

extension DemoCollectionViewController {
  @objc func scrollDownAnimator() {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
      self.collectionView.contentOffset.y = self.maxOffset
    }, completion: nil)
  }
  
  @objc func scrollDownDisplayLink() {
    let last = self.items.last!
    let new1 = last+1
    let new2 = new1+1
    collectionView.performBatchUpdates {
      self.items.append(new1)
      self.items.append(new2)
      print(maxOffset)
      collectionView.insertItems(at: [
        IndexPath(item: new1, section: 0),
        IndexPath(item: new2, section: 0)
      ])
      self.maxOffset = collectionView.collectionViewLayout.collectionViewContentSize.height - collectionView.frame.size.height
      print(maxOffset)
    } completion: { (_) in

    }


    if displayLink == nil {
      displayLink = CADisplayLink(target: self, selector: #selector(updateScrollPosition))
      displayLink?.add(to: .current, forMode: .default)
    }
  }
  
  @objc func updateScrollPosition() {
    guard let displayLink = displayLink else {
      return
    }
    
    // Get timestamp at start of animation
    if startTimestamp < 1 {
      startTimestamp = displayLink.timestamp
      startOffset = collectionView.contentOffset.y
      return
    }
    
    // Calculate fraction of animation; 0: start; 1: end
    let fraction = (displayLink.targetTimestamp - startTimestamp) / duration
    if fraction > 1 || previousFraction > fraction {
      // animation is finished
      displayLink.invalidate()
      self.displayLink = nil
      startTimestamp = 0
      previousFraction = 0
      // scroll to final point just to make sure
      collectionView.setContentOffset(CGPoint(x: 0, y: maxOffset), animated: false)
    } else {
      // calculate offset for this frame of the animation
      let offset = (maxOffset - startOffset) * CGFloat(easeInOut(for: fraction)) + startOffset
      collectionView.contentOffset.y = offset
      previousFraction = fraction
    }
  }
  
  // https://stackoverflow.com/a/25730573/498796
  private func easeInOut(for fraction: Double) -> Double {
    return fraction * fraction * (3.0 - 2.0 * fraction)
  }
}
