//
//  main.m
//  phunktor
//
//  Created by Antoine van Gelder on 2009/01/27.
//  Copyright 7degrees.co.za 2009. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
  NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
  int ret = NSApplicationMain(argc,  (const char **) argv);
  [pool release];
  return ret;
}
