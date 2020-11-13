import Foundation 

final class SerialTaskQueue {
  typealias Completion = () -> Void
  typealias Task = (@escaping Completion) -> Void

  var isEmpty: Bool { tasks.isEmpty }
  private(set) var isBusy = false
  private(set) var isStopped = true
  private(set) var tasks = [Task]()

  init() { }

  let lock = NSLock() // TODO: lock public APIs?

  func addTask(_ task: @escaping Task) {
    tasks.append(task)
    runNextTask()
  }

  func start() {
    isStopped = false
    runNextTask()
  }

  func stop() {
    isStopped = true
  }

  func flush() {
    tasks.removeAll()
  }

  private func runNextTask() {
    if isStopped || isBusy || isEmpty { return }

    let firstTask = tasks.removeFirst()
    isBusy = true
    firstTask { [weak self] () -> Void in
      
      self?.isBusy = false
      self?.runNextTask()
    }
  }
}
