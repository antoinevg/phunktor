//
//  PhunkDocument.h
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/07.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface PhunkDocument : NSDocument {
  IBOutlet NSTextView* sourceView;
  NSString* sourceString;
}
- (NSString*)source;
- (void)setSource:(NSString*)string;



@end
