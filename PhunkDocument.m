//
//  PhunkDocument.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/02/07.
//  Copyright 2009 7degrees.co.za. All rights reserved.
//

#import "PhunkDocument.h"


@implementation PhunkDocument

- (id)init
{
  [super init];
  if (self) {
    if ([self source] == nil) {
      [self setSource:[[NSString alloc] initWithString:@""]];
    }
  }
  return self;
}


- (NSString *)windowNibName 
{
  return @"PhunkDocument";
}


- (void)windowControllerDidLoadNib:(NSWindowController*)aController
{
  [super windowControllerDidLoadNib:aController];
  [sourceView setAllowsUndo:YES];
  if ([self source] != nil) {
    [sourceView setString: [self source]];
  }
}


- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
  [self setSource:[sourceView string]];
  NSData* data = [[self source] dataUsingEncoding:NSMacOSRomanStringEncoding];
  if (outError != NULL) {
    *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:nil];
  } 
  return data;
}


- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
  NSString* source = [[NSString alloc] initWithData:data encoding:NSMacOSRomanStringEncoding];
  if (!source) {
    return NO;
  }
  [self setSource:source];
  [source release];
  if (outError != NULL) {
    *outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnknownError userInfo:nil];
	}
  return YES;  
}


- (NSString*)source
{ 
  return [[sourceString retain] autorelease]; 
}


- (void)setSource:(NSString*)string  
{
  if (sourceString == string) {
    return;
  }
  if (sourceString) { 
    [sourceString release];
  }
  sourceString = [string copy];
}


- (void) textDidChange: (NSNotification *)notification
{
  [self setSource: [sourceView string]];
}


@end
