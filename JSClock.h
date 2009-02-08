//
//  JSClock.h
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/07.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <AudioToolbox/CoreAudioClock.h>
#import <JavaScriptCore/JSBase.h>
#import <JavaScriptCore/JSObjectRef.h>
#import <JavaScriptCore/JSValueRef.h>
#import <JavaScriptCore/JSStringRef.h>
#import <JavaScriptCore/JSStringRefCF.h>


// See: http://objective-audio.jp/2008/05/core-audio-clock.html
//      http://objective-audio.jp/2008/06/core-audio-clock-mtc.html
//      http://developer.apple.com/documentation/musicaudio/reference/CAAudioTooboxRef/CoreAudioClock/index.html



@interface JSClockCallback : NSObject {
  Float64     _time;
  JSObjectRef _closure;
}
- (id) initWithTime:(Float64)time andClosure:(JSObjectRef)closure;
- (bool) triggered:(Float64)time;
- (JSObjectRef) closure;
@end


@interface JSClock : NSObject {
  JSGlobalContextRef _context;
  CAClockRef         _clock;
  NSTimer*           _timer;
  UInt16             _last_beat;
  NSMutableArray*    _callbacks;
  NSMutableArray*    _fired_callbacks;
}
- (id) initWithContext:(JSGlobalContextRef)context;
- (IBAction) start:(id)sender;
- (IBAction) stop:(id)sender;
- (IBAction) reset:(id)sender;
- (Float64) now;
- (void) callback:(Float64)time :(WebScriptObject*)closure;

- (void) callbackProcessor:(NSTimer*)timer;
- (void) clockListener:(CAClockMessage)message parameter:(const void*)param;

@end
