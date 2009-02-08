//
//  JSTimeout.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/01.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import "JSTimeout.h"


@implementation JSTimeout

-(JSTimeout*) initWithContext:(JSGlobalContextRef)context andClosure:(JSObjectRef)closure andDelay:(float)delay
{
  self = [super init];
  
  if (self) {
    NSLog(@"Starting timer with delay %f", delay);
    _context = context;
    _closure = closure;
    _timer = [NSTimer scheduledTimerWithTimeInterval:delay target:self selector:@selector(call) userInfo:nil repeats:NO];
  }
  
  return self;
}


-(void) call
{ 
  NSLog(@"JSTimer:call");
  JSStringRef jsString = JSStringCreateWithCFString((CFStringRef)@"a random argument");
  JSValueRef jsArgs[1];
  jsArgs[0] = JSValueMakeString(_context, jsString);
  JSValueRef ret = JSObjectCallAsFunction(_context, _closure, NULL, 1, jsArgs, NULL);
  JSStringRelease(jsString);  
  jsString = JSValueToStringCopy(_context, ret, NULL);  
  NSString* s = (NSString*)JSStringCopyCFString(NULL, jsString); 
  NSLog(@"JSTimer:call returned: %@", s);
  JSStringRelease(jsString);
}



@end
