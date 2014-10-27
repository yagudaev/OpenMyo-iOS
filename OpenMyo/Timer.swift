import Foundation

class Timer {
  
  let name: String?
  
  let delay: Double
  
  let handler: Void -> Void
  
  let repeats = false
  
  convenience init (_ delay: Double, _ handler: Void -> Void) {
    self.init(NSUUID().UUIDString, delay, handler)
  }
  
  init (_ name: String, _ delay: Double, _ handler: Void -> Void) {
    timers[name]?.kill()
    
    self.name = name
    self.delay = delay
    self.handler = handler
    
    timers[name] = self
    start()
  }
  
  class func repeat (before delay: Double, _ handler: Void -> Void) -> Timer {
    handler()
    return Timer(repeat: delay, handler)
  }
  
  class func repeat (after delay: Double, _ handler: Void -> Void) -> Timer {
    return Timer(repeat: delay, handler)
  }
  
  class func named (name: String) -> Timer? {
    return timers[name]
  }
  
  func start () {
    if nsTimer != nil { return }
    nsTimer = NSTimer(timeInterval: delay, target: self, selector: "execute", userInfo: nil, repeats: repeats)
    NSRunLoop.currentRunLoop().addTimer(nsTimer!, forMode: NSRunLoopCommonModes)
  }
  
  func stop () {
    if nsTimer == nil { return }
    nsTimer!.invalidate()
    nsTimer = nil
  }
  
  func fire () {
    handler()
    kill()
  }
  
  func kill () {
    stop()
    if name != nil { timers[name!] = nil }
  }
  
  private var nsTimer: NSTimer?
  
  @objc private func execute () {
    handler()
    if !repeats { kill() }
  }
  
  private init (repeat delay: Double, _ handler: Void -> Void) {
    repeats = true
    
    self.delay = delay
    self.handler = handler
    
    start()
  }
}

// Retains non-repeating timers
private var timers = [String:Timer]()