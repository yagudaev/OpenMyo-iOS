class DataBuffer<T> {
  var head:Int
  var maxSize:Int
  var array:[T?]
  
  init(maxSize:Int) {
    self.maxSize = maxSize
    self.head = 0
    self.array = [T?](count: maxSize, repeatedValue: nil)
  }
  
  func append(data: T) {
    array[head] = data
    incrementHead()
  }
  
  subscript(index: Int) -> T? {
    get {
      return array[position(index)]
    }
    set(newValue) {
      array[position(index)] = newValue
      incrementHead()
    }
  }
  
  private func position(index:Int) -> Int {
    return (head + index) % maxSize
  }
  
  private func incrementHead() {
    head = (head + 1) % maxSize
  }
}