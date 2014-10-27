import UIKit

class OrientationGraphView: JBLineChartView, JBLineChartViewDelegate, JBLineChartViewDataSource {
  
  var data = [OrientationData]() //(count: MAX_ARRAY_SIZE, repeatedValue: 0.0)
  
  override init(frame aRect: CGRect) {
    super.init(frame: aRect)
    dataSource = self
    delegate = self
    
    let notifer = NSNotificationCenter.defaultCenter()
    // Notifications for orientation event are posted at a rate of 50 Hz.
    notifer.addObserver(self, selector: "didRecieveOrientationEvent:", name: TLMMyoDidReceiveOrientationEventNotification, object: nil)
  }
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func didRecieveOrientationEvent(notification: NSNotification) {
    let eventData = notification.userInfo as Dictionary<NSString, TLMOrientationEvent>
    let orientationEvent = eventData[kTLMKeyOrientationEvent]!
    
    let angles = GLKitPolyfill.getOrientation(orientationEvent)
    
    data.append(angles)
    
    println("Orientation (\(angles.pitch.radians), \(angles.yaw.radians), \(angles.roll.radians))")
  }
  
  func numberOfLinesInLineChartView(lineChartView: JBLineChartView) -> UInt {
    return 3
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
    let orientation = data[Int(horizontalIndex)]
    var value:Double
    let PI = 3.14
    switch(lineIndex) {
    case 0:
      value = orientation.pitch.radians + PI + 0.5
    case 1:
      value = orientation.yaw.radians + PI + 0.5
    case 2:
      value = orientation.roll.radians + PI + 0.5
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
    return UInt(data.count)
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
    default:
      return UIColor.blackColor()
    }
  }
}