//
//  PhunkController.h
//  phunktor
//
//  Created by Antoine van Gelder on 2009/01/28.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface PhunkController : NSObject {
  WebView* webView;
	WebScriptObject* scriptObject;
  JSClock* jsClock;  
  JSOSC*   jsOSC;

  IBOutlet id sourceView;  
  IBOutlet id consoleView;
}
- (IBAction)evaluate:sender;
- (int)setTimeout:(WebScriptObject*)function:(float)delay;
- (void)print:(NSString*)message;

@end

