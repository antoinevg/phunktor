//
//  JSTimeout.h
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/01.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <JavaScriptCore/JSBase.h>
#import <JavaScriptCore/JSObjectRef.h>
#import <JavaScriptCore/JSValueRef.h>
#import <JavaScriptCore/JSStringRef.h>
#import <JavaScriptCore/JSStringRefCF.h>


@interface JSTimeout : NSObject {
  JSGlobalContextRef _context;
  JSObjectRef        _closure;
  NSTimer*           _timer;
}
-(JSTimeout*) initWithContext:(JSGlobalContextRef)context andClosure:(JSObjectRef)closure andDelay:(float)delay;
-(void) call;

@end
