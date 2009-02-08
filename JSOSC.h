//
//  JSOSC.h
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/01.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <VVOSC/VVOSC.h>

@interface JSOSC : NSObject {
  NSString*   _host;
  int         _port;
  OSCManager* _oscManager;
  OSCOutPort* _oscOutPort;
}
- initWithHost :(NSString*)host andPort:(int)port;
- (void)note_on  :(NSString*)address :(int)channel :(int)key :(int)velocity;
- (void)note_off :(NSString*)address :(int)channel :(int)key;
- (void)play_note_now :(NSString*)address :(int)channel :(int)key :(int)velocity :(int)duration;
- (void)play_note :(int)time :(NSString*)address :(int)channel :(int)key :(int)velocity :(int)duration;

@end
