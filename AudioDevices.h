//
//  AudioDevices.h
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/08.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface AudioDevices : NSObject {

}
+ (AudioDeviceID) device:(NSString*)name;
@end
