//
//  JSTextView.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/01/29.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import "JSTextView.h"


@implementation JSTextView

- (void)print:(NSString*)message
{
  [[[self textStorage] mutableString] appendString: message];
  [[[self textStorage] mutableString] appendString: @"\n"];
}


+ (NSString *)webScriptNameForSelector:(SEL)sel
{
	if (sel == @selector(print:)) { return @"print"; }
	return nil;
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }
+ (BOOL)isKeyExcludedFromWebScript:(const char *)name  { return NO; }

@end
