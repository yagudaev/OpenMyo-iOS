#import <Foundation/Foundation.h>
#import "GLKitPolyfill.h"

@implementation GLKitPolyfill

+ (AccelerationData *) getAcceleration:(TLMAccelerometerEvent *)accelerometerEvent {
  AccelerationData *result = [AccelerationData new];

  // Get the acceleration vector from the accelerometer event.
  GLKVector3 accelerationVector = accelerometerEvent.vector;

  // Calculate the magnitude of the acceleration vector.
  result.magnitude = GLKVector3Length(accelerationVector);
  result.x = accelerationVector.x;
  result.y = accelerationVector.y;
  result.z = accelerationVector.z;

  return result;
}

+ (OrientationData *) getOrientation:(TLMOrientationEvent *)orientationEvent {
  TLMEulerAngles *angles = [TLMEulerAngles anglesWithQuaternion:orientationEvent.quaternion];
  
  OrientationData *result = [OrientationData new];
  result.pitch = angles.pitch;
  result.yaw = angles.yaw;
  result.roll = angles.roll;
  
  return result;
}

+ (GyroData *) getGyro:(TLMGyroscopeEvent *)gyroEvent {
  GLKVector3 vector = gyroEvent.vector;
  GyroData *result = [GyroData new];
  result.x = vector.x;
  result.y = vector.y;
  result.z = vector.z;
  
  return result;
}

@end