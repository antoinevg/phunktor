//
//  JSClock.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/07.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <CoreAudio/CoreAudio.h>

#import "AudioDevices.h"

#import "JSClock.h"


@implementation JSClockCallback
- (id) initWithTime:(Float64)time andClosure:(JSObjectRef)closure
{
  self = [super init];
  if (self) {
    _time = time;
    _closure = closure;
  }
  return self;
}

- (bool) triggered:(Float64)time
{
  return (time >= _time);
}

- (JSObjectRef) closure 
{
  return _closure;
}
@end



@implementation JSClock

//
// Utility wrapper to translate a CoreAudioClock callback to an Objective-C message
//
static void ClockListener(void* userData, CAClockMessage message, const void* param)
{
  [(id)userData clockListener:message parameter:param];
}


//
// Construction
//
- (id)initWithContext:(JSGlobalContextRef)context;
{
  self = [super init];
  if (self) {
    _context = context;

    UInt32 sync_mode = kCAClockSyncMode_Internal;      
    //CAClockTimebase timebase = kCAClockTimebase_HostTime; 
    CAClockTimebase timebase = kCAClockTimebase_AudioDevice;
    AudioDeviceID timebase_source = [AudioDevices device:@"Built-in Output"];    
    verify_noerr(CAClockNew(0, &_clock));
    verify_noerr(CAClockSetProperty(_clock, kCAClockProperty_SyncMode, sizeof(sync_mode), &sync_mode));
    verify_noerr(CAClockSetProperty(_clock, kCAClockProperty_InternalTimebase, sizeof(timebase), &timebase));
    verify_noerr(CAClockSetProperty(_clock, kCAClockProperty_TimebaseSource, sizeof(timebase_source), &timebase_source));
    verify_noerr(CAClockAddListener(_clock, ClockListener, self));
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(callbackProcessor:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSEventTrackingRunLoopMode];
    
    _callbacks       = [[NSMutableArray alloc] init];
    _fired_callbacks = [[NSMutableArray alloc] init];
  }
  return self;
fatal:
  NSLog(@"JSClock - Fatal error initializing CoreAudioClock - exiting");
  [NSApp terminate:self];
  return self;
}


- (void) dealloc
{
  [_timer invalidate];
  verify_noerr(CAClockDisarm(_clock));
  verify_noerr(CAClockDispose(_clock));
  [super dealloc];
}


- (Float64)now
{
  CAClockTime samples; 
  verify_noerr(CAClockGetCurrentTime(_clock, kCAClockTimeFormat_Samples, &samples));
  return samples.time.samples;  
}


- (void)callback:(Float64)time :(WebScriptObject*)closure;
{
  if (closure) {
    [_callbacks addObject:[[JSClockCallback alloc] initWithTime:time andClosure:[closure JSObject]]];
  } else {
    NSLog(@"JSClock - Error attempting to add null closure");
  }
}


- (IBAction)start:(id)sender
{
  verify_noerr(CAClockStart(_clock));
}


- (IBAction)stop:(id)sender
{
  verify_noerr(CAClockStop(_clock));
}


- (IBAction)reset:(id)sender
{
  [self stop:nil];
  CAClockTime secondTime;
  secondTime.format = kCAClockTimeFormat_Seconds;
  secondTime.time.seconds = 0.0;
  verify_noerr(CAClockSetCurrentTime(_clock, &secondTime));
  [self start:nil];
}


- (void)callbackProcessor:(NSTimer*)timer
{
  /*
  CAClockTime beats;  
  verify_noerr(CAClockTranslateTime(_clock, &time, kCAClockTimeFormat_Beats, &beats));
  CABarBeatTime bars;
  verify_noerr(CAClockBeatsToBarBeatTime(_clock, beats.time.beats, 4, &bars));  
  if (_last_beat != bars.beat) {
    NSString* s = [NSString stringWithFormat:@"%d:%d:%d/%d    beats=%f    samples=%f",  
                   bars.bar, bars.beat, bars.subbeat, bars.subbeatDivisor, 
                   beats.time.beats,
                   [self now] / 1000.0];
    NSLog(@"%@", s);
    _last_beat = bars.beat;
  }*/
  
  if ([_callbacks count]) {
    for (JSClockCallback* callback in _callbacks) {
      if ([callback triggered:[self now]]) {
        [_fired_callbacks addObject:callback];    
      }
    }
  }
  
  if ([_fired_callbacks count]) { 
    for (JSClockCallback* callback in _fired_callbacks) {      
      // TODO - take this code from here and JSTImeout and put it all in as class methods on a JSUtilities
      JSStringRef jsString = JSStringCreateWithCFString((CFStringRef)@"a random argument");
      JSValueRef jsArgs[1];
      jsArgs[0] = JSValueMakeString(_context, jsString);
      JSValueRef ret = JSObjectCallAsFunction(_context, [callback closure], NULL, 1, jsArgs, NULL);
      JSStringRelease(jsString);  
      jsString = JSValueToStringCopy(_context, ret, NULL);  
      NSString* s = (NSString*)JSStringCopyCFString(NULL, jsString); 
      NSLog(@"JSClock:callback -> %@", s);
      JSStringRelease(jsString);
    }    
    [_callbacks removeObjectsInArray:_fired_callbacks];
    [_fired_callbacks removeAllObjects];
  }
}


- (void) clockListener:(CAClockMessage)message parameter:(const void *)param
{
  switch (message) {
    case kCAClockMessage_Started:
      NSLog(@"JSClock - started");      
      break;
    case kCAClockMessage_Stopped:
      NSLog(@"JSClock - stopped");
      break;
  }
}


+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name  { return NO; }
+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	if (sel == @selector(now)) { return @"now"; }
  else if (sel == @selector(callback::)) { return @"callback";  }
	return nil;
}
+ (NSString *)webScriptNameForKey:(const char *)name
{
  return nil; 
}


@end
