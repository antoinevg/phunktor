//
//  JSOSC.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/01.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import "JSOSC.h"


@implementation JSOSC

- initWithHost:(NSString*)host andPort:(int)port
{
  self = [super init];
  if (self) {
    _oscManager = [[OSCManager alloc] init];
    [_oscManager setDelegate:self];
    _oscOutPort = [_oscManager createNewOutputToAddress:host atPort:port];
  }
  return self;
}


- (void)note_on:(NSString*)address:(int)channel:(int)key:(int)velocity
{
  NSLog(@"note_on(%@, %d, %d, %d)", address, channel, key, velocity);
  OSCMessage* oscMessage = [OSCMessage createMessageToAddress:address];
  [oscMessage addInt:(144 + channel)];
  [oscMessage addInt:key];
  [oscMessage addInt:velocity];
  [_oscOutPort sendThisMessage:oscMessage];
}


- (void)note_off:(NSString*)address:(int)channel:(int)key
{
  OSCMessage* note_off = [OSCMessage createMessageToAddress:address];
  [note_off addInt:(128 + channel)];
  [note_off addInt:key];
  [note_off addInt:0];
  [_oscOutPort sendThisMessage:note_off];  
}


- (void)play_note_now:(NSString*)address:(int)channel:(int)key:(int)velocity:(int)duration
{
}


- (void)play_note :(int)time :(NSString*)address :(int)channel :(int)key :(int)velocity :(int)duration
{
}


+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name  { return NO; }
+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	if (sel == @selector(play_note::::)) { return @"play:note"; }
  else if (sel == @selector(note_on::::)) { return @"note:on";  }
  else if (sel == @selector(note_off:::)) { return @"note:off"; }
	return nil;
}



@end
