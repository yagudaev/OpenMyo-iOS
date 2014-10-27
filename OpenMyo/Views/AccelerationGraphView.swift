import UIKit

let MAX_ARRAY_SIZE = 1500

class AccelerationGraphView : JBLineChartView, JBLineChartViewDataSource, JBLineChartViewDelegate {
  
  var accelerationData = [AccelerationData]() //(count: MAX_ARRAY_SIZE, repeatedValue: 0.0)
  var accelerationIndex = MAX_ARRAY_SIZE - 1
  
  override init(frame aRect: CGRect) {
    super.init(frame: aRect)
    dataSource = self
    delegate = self
    
    let notifer = NSNotificationCenter.defaultCenter()
    // Notifications accelerometer event are posted at a rate of 50 Hz.
    notifer.addObserver(self, selector: "didRecieveAccelerationEvent:", name: TLMMyoDidReceiveAccelerometerEventNotification, object: nil)
  }

  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func didRecieveAccelerationEvent(notification: NSNotification) {
    let eventData = notification.userInfo as Dictionary<NSString, TLMAccelerometerEvent>
    let accelerometerEvent = eventData[kTLMKeyAccelerometerEvent]!
    
    let acceleration = GLKitPolyfill.getAcceleration(accelerometerEvent)
    
    accelerationData.append(acceleration)
//    accelerationData[accelerationIndex] = Double(acceleration.magnitude)
//    
//    accelerationIndex -= 1
//    if accelerationIndex < 0 {
//      accelerationIndex = MAX_ARRAY_SIZE - 1
//    }
    
    println("acceleration (\(acceleration.x), \(acceleration.y), \(acceleration.z), \(acceleration.magnitude))")
  }
  
  func numberOfLinesInLineChartView(lineChartView: JBLineChartView) -> UInt {
    return 4
  }
  
  /**
  *  Vertical value for a line point at a given index (left to right). There is no ceiling on the the height;
  *  the chart will automatically normalize all values between the overal min and max heights.
  *
  *  @param lineChartView    The line chart object requesting this information.
  *  @param horizontalIndex  The 0-based horizontal index of a selection point (left to right, x-axis).
  *  @param lineIndex        An index number identifying the closest line in the chart to the current touch point.
  *
  *  @return The y-axis value of the supplied line index (x-axis)
  */
  func lineChartView(lineChartView:JBLineChartView, verticalValueForHorizontalIndex horizontalIndex:UInt, atLineIndex lineIndex:UInt) -> CGFloat {
    let acceleration = accelerationData[Int(horizontalIndex)]
    var value:Float
    switch(lineIndex) {
    case 0:
      value = acceleration.x + 4
    case 1:
      value = acceleration.y + 4
    case 2:
      value = acceleration.z + 4
    case 3:
      value = acceleration.magnitude + 2
    default:
      value = 0.0
    }
    
    return CGFloat(value)
  }
  
  /**
  *  Returns the number of vertical values for a particular line at lineIndex within the chart.
  *
  *  @param lineChartView    The line chart object requesting this information.
  *  @param lineIndex        An index number identifying a line in the chart.
  *
  *  @return The number of vertical values for a given line in the line chart.
  */
  func lineChartView(lineChartView: JBLineChartView, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
    return UInt(accelerationData.count)
  }
  
  /**
  *  Returns the width of particular line at lineIndex within the chart.
  *
  *  Default: 5 points.
  *
  *  @param lineChartView    The line chart object requesting this information.
  *  @param lineIndex        An index number identifying a line in the chart.
  *
  *  @return The width to be used to draw a line in the chart.
  */
  func lineChartView(lineChartView:JBLineChartView, widthForLineAtLineIndex lineIndex:UInt) -> CGFloat {
    return CGFloat(1.0)
  }
  
  func lineChartView(lineChartView:JBLineChartView, colorForLineAtLineIndex lineIndex:UInt) -> UIColor {
    switch(lineIndex) {
    case 0:
      return UIColor.redColor()
    case 1:
      return UIColor.greenColor()
    case 2:
      return UIColor.blueColor()
    case 3:
      return UIColor.purpleColor()
    default:
      return UIColor.blackColor()
    }
  }
}
