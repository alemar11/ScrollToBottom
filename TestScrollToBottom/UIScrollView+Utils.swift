import UIKit

public typealias InterpolationFunction = (_ startValue: CGFloat, _ endValue: CGFloat, _ duration: CGFloat, _ currentTime: CGFloat) -> CGFloat

// linear interpolation method
public func lerp(startValue: CGFloat, endValue: CGFloat, duration: CGFloat, currentTime: CGFloat) -> CGFloat {
  let progress = currentTime/duration
  return (endValue - startValue) * progress + startValue
}

public extension UIScrollView {
  func setContentOffset(_ contentOffset: CGPoint, duration: TimeInterval, interpolationFunction: @escaping InterpolationFunction = lerp, completion: (() -> Void)? = nil) {
    if contentOffsetAnimator == nil {
      contentOffsetAnimator = ContentOffsetAnimator(scrollView: self, interpolationFunction: interpolationFunction)
    }
    contentOffsetAnimator!.completion = { [weak self] in
      guard let self = self else { return }
      dispatchPrecondition(condition: .onQueue(.main))
      self.contentOffsetAnimator = nil
      completion?()
    }
    contentOffsetAnimator!.setContentOffset(contentOffset, duration: duration)
  }
}


extension UIScrollView {
  private enum AssociatedKeys {
    static var contentOffsetAnimator: String = "contentOffsetAnimator"
  }

  private var contentOffsetAnimator: ContentOffsetAnimator? {
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.contentOffsetAnimator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    get {
      objc_getAssociatedObject(self, &AssociatedKeys.contentOffsetAnimator) as? ContentOffsetAnimator
    }
  }
}

extension UIScrollView {
  private final class ContentOffsetAnimator {
    var completion: (() -> Void)?
    private weak var scrollView: UIScrollView?
    private let interpolationFunction: InterpolationFunction
    private var startOffset: CGPoint = .zero
    private var destinationOffset: CGPoint = .zero
    private var duration: TimeInterval = .zero
    private var runTime: TimeInterval = .zero
    private var displayLink: CADisplayLink?

    init(scrollView: UIScrollView, interpolationFunction: @escaping InterpolationFunction) {
      self.scrollView = scrollView
      self.interpolationFunction = interpolationFunction
    }

    func setContentOffset(_ contentOffset: CGPoint, duration: TimeInterval) {
      guard let scrollView = scrollView else { return }

      startOffset = scrollView.contentOffset
      destinationOffset = contentOffset
      self.duration = duration
      runTime = 0
      guard self.duration > 0 else {
        scrollView.contentOffset = contentOffset
        return
      }
      if displayLink == nil {
        displayLink = CADisplayLink(target: self, selector: #selector(updateContentOffset))
        displayLink?.add(to: .main, forMode: .default) // .common to avoid user interruption
      }
    }

    @objc
    func updateContentOffset() {
      guard let displayLink = displayLink else { return }
      guard let scrollView = scrollView else { return }

      runTime += displayLink.duration

      if runTime >= duration {
        // animation is finished
        scrollView.contentOffset = destinationOffset
        displayLink.invalidate()
        self.displayLink = nil
        completion?()
      } else {
        // calculate offset for this frame of the animation
        var offset = CGPoint.zero
        print(destinationOffset.y - startOffset.y)
        offset.x = interpolationFunction(startOffset.x, destinationOffset.x, CGFloat(duration), CGFloat(runTime))
        offset.y = interpolationFunction(startOffset.y, destinationOffset.y, CGFloat(duration), CGFloat(runTime))
        scrollView.contentOffset = offset
      }
    }

  }
}
