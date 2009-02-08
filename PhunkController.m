//
//  PhunkController.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/01/28.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import "JSTimeout.h"
#import "JSOSC.h"
#import "JSClock.h"

#import "PhunkController.h"



/** 
 * Read: http://lipidity.com/apple/javascript-cocoa-webkit/
 *       http://parmanoir.com/Mixing_WebView_and_JavascriptCore
 *       
 */


@implementation PhunkController

- (id)init
{
  [super init];
  webView = [[WebView alloc] init];
  jsClock = [[JSClock alloc] initWithContext:[[webView mainFrame] globalContext]];    
  jsOSC   = [[JSOSC   alloc] initWithHost:@"127.0.0.1" andPort:7009];
  return self;
}


- (void)awakeFromNib
{
  [[webView mainFrame] loadHTMLString:@"" baseURL:NULL];
  
  [sourceView  setFont:[NSFont fontWithName:@"Monaco" size:10.0]];
  [consoleView setFont:[NSFont fontWithName:@"Monaco" size:10.0]];
  [consoleView setString:@"Welcome to phunktor 0.1!\n"];

	scriptObject = [webView windowScriptObject];
  [scriptObject setValue:self        forKey:@"controller"];    
  [scriptObject setValue:consoleView forKey:@"console"];
  [scriptObject setValue:jsClock     forKey:@"clock"];    
  [scriptObject setValue:jsOSC       forKey:@"osc"];  
  
  [jsClock start:self];
}


- (IBAction) evaluate: sender
{
  //[jsClock reset:self];
  
  [consoleView setString:@"\n"];
  [consoleView setFont:[NSFont fontWithName:@"Monaco" size:10.0]]; // it forgets!
  
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  NSString* script = [[NSString alloc] initWithFormat:@"try { %@ } catch (e) { e.toString() }", [sourceView string]];
	id data = [scriptObject evaluateWebScript:script];
	if(![data isMemberOfClass:[WebUndefined class]]) {
		NSLog(@"%@", data);
    NSString* output = [[NSString alloc] initWithFormat:@"%@\n", data];
    [[[consoleView textStorage] mutableString] appendString: output];
    [output release];
  }	
	[script release];
  [pool release];  
}


- (int)setTimeout:(WebScriptObject*)closure:(float)delay
{
  NSString* s = [[NSString alloc] initWithFormat:@"setTimeout(%@, %f)\n", [closure stringRepresentation], delay]; 
  [[[consoleView textStorage] mutableString] appendString: s];

  JSTimeout* timeout = [[JSTimeout alloc] initWithContext:[[webView mainFrame] globalContext] andClosure:[closure JSObject] andDelay:delay];
  
  return (int)timeout;
}


- (void)print:(NSString*)message
{
  [consoleView print:message];
}



+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	if (sel == @selector(setTimeout::)) { return @"setTimeout"; }
	else if (sel == @selector(print:))  { return @"print";      }
	return nil;
}
+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name  { return NO; }

@end
