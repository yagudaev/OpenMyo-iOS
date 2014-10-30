import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var helloLabel: UILabel!
  @IBOutlet weak var armLabel: UILabel!
  
  var currentPose: TLMPose!
  @IBOutlet weak var accelerationGraphView: AccelerationGraphView!
  @IBOutlet weak var orientationGraphView: OrientationGraphView!
  @IBOutlet weak var gyroscopeGraphView: GyroscopeGraphView!
  var deviceConnected = false
  var timer:Timer!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    timer = Timer.repeat(after: 0.10, updateGraphs)
    
    bindToMyoEvents()
  }
  
  func bindToMyoEvents() {
    let notifer = NSNotificationCenter.defaultCenter()
    
    // Data notifications are received through NSNotificationCenter.
    notifer.addObserver(self, selector: "didConnectDevice:", name: TLMHubDidConnectDeviceNotification, object: nil)
    notifer.addObserver(self, selector: "didDisconnectDevice:", name: TLMHubDidDisconnectDeviceNotification, object: nil)
    // Posted whenever the user does a Sync Gesture, and the Myo is calibrated
    notifer.addObserver(self, selector: "didRecognizeArm:", name: TLMMyoDidReceiveArmRecognizedEventNotification, object: nil)
    // Posted whenever Myo loses its calibration (when Myo is taken off, or moved enough on the user's arm)
    notifer.addObserver(self, selector: "didLoseArm:", name: TLMMyoDidReceiveArmLostEventNotification, object: nil)

    // Posted when one of the pre-configued geatures is recognized (e.g. Fist, Wave In, Wave Out, etc)
    notifer.addObserver(self, selector: "didChangePose:", name: TLMMyoDidReceivePoseChangedNotification, object: nil)
  }
  
  func updateGraphs() {
    if (deviceConnected) {
      accelerationGraphView.reloadData()
      orientationGraphView.reloadData()
      gyroscopeGraphView.reloadData()
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func didTapSettings(sender: AnyObject) {
    // Settings view must be in a navigation controller when presented
    let controller = TLMSettingsViewController.settingsInNavigationController()
    presentViewController(controller, animated: true, completion: nil)
  }
  
  func didConnectDevice(notification: NSNotification) {
    helloLabel.center = self.view.center
    
    armLabel.text = "Perform the Sync Gesture"
    helloLabel.text = "Hello Myo"
    
    deviceConnected = true
  }

  func didDisconnectDevice(notification: NSNotification) {
    helloLabel.text = ""
    armLabel.text = ""
    deviceConnected = false
  }

  func didRecognizeArm(notification: NSNotification) {
    let eventData = notification.userInfo as Dictionary<NSString, TLMArmRecognizedEvent>
    let armEvent = eventData[kTLMKeyArmRecognizedEvent]!
    
    var arm = armEvent.arm == .Right ? "Right" : "Left"
    var direction = armEvent.xDirection == .TowardWrist ? "Towards Wrist" : "Toward Elbow"
    armLabel.text = "Arm: \(arm) X-Direction: \(direction)"
    helloLabel.textColor = UIColor.blueColor()
    
    armEvent.myo.vibrateWithLength(.Short)
  }

  func didLoseArm(notification: NSNotification) {
    armLabel.text = "Perform the Sync Gesture"
    helloLabel.text = "Hello Myo"
    helloLabel.textColor = UIColor.blackColor()
    
    let eventData = notification.userInfo as Dictionary<NSString, TLMArmLostEvent>
    let armEvent = eventData[kTLMKeyArmLostEvent]!
    armEvent.myo.vibrateWithLength(.Short)
  }

  func didChangePose(notification: NSNotification) {
    let eventData = notification.userInfo as Dictionary<NSString, TLMPose>
    currentPose = eventData[kTLMKeyPose]!
    
    switch (currentPose.type) {
    case .Fist:
      helloLabel.text = "Fist"
      helloLabel.font = UIFont(name: "Noteworthy", size: 50)
      helloLabel.textColor = UIColor.greenColor()
    case .WaveIn:
      helloLabel.text = "Wave In"
      helloLabel.font = UIFont(name: "Courier New", size: 50)
      helloLabel.textColor = UIColor.greenColor()
    case .WaveOut:
      helloLabel.text = "Wave Out";
      helloLabel.font = UIFont(name: "Snell Roundhand", size: 50)
      helloLabel.textColor = UIColor.greenColor()
    case .FingersSpread:
      helloLabel.text = "Fingers Spread";
      helloLabel.font = UIFont(name: "Chalkduster", size: 50)
      helloLabel.textColor = UIColor.greenColor()
    case .ThumbToPinky:
      self.helloLabel.text = "Thumb to Pinky";
      self.helloLabel.font = UIFont(name: "Georgia", size: 50)
      self.helloLabel.textColor = UIColor.greenColor()
    default: // .Rest or .Unknown
      helloLabel.text = "Hello Myo"
      helloLabel.font = UIFont(name: "Helvetica Neue", size: 50)
      helloLabel.textColor = UIColor.blackColor()
    }
  }
}

