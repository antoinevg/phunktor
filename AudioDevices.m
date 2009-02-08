//
//  AudioDevices.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/08.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#include <CoreServices/CoreServices.h>
#include <CoreAudio/CoreAudio.h>

#import "AudioDevices.h"


@implementation AudioDevices


+ (AudioDeviceID) device:(NSString*)name  
{
  UInt32 propsize;
	verify_noerr(AudioHardwareGetPropertyInfo(kAudioHardwarePropertyDevices, &propsize, NULL));
	int num_devices = propsize / sizeof(AudioDeviceID);	
  AudioDeviceID device_ids[num_devices];
	verify_noerr(AudioHardwareGetProperty(kAudioHardwarePropertyDevices, &propsize, device_ids));
	for (int i = 0; i < num_devices; ++i) {
    UInt32 buffer_length = 256;
    char buffer[buffer_length];    
    verify_noerr(AudioDeviceGetProperty(device_ids[i], 0, false, kAudioDevicePropertyDeviceName, &buffer_length, buffer));
    NSString* device_name = [[NSString alloc] initWithCString:buffer length:buffer_length];
    NSLog(@"Device is: %d %@", device_ids[i], device_name);
    if ([name caseInsensitiveCompare:device_name] == NSOrderedAscending) {
      NSLog(@"GOT IT");
      return device_ids[i];
    }
	}
  return -1;
}


@end
