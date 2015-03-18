//
//  MIDI2ColorPlugIn.h
//  MIDI2Color
//
//  Created by Eddie Hillenbrand on 3/18/15.
//  Copyright (c) 2015 Eddie Hillenbrand. All rights reserved.
//

#import <Quartz/Quartz.h>

@interface MIDI2ColorPlugIn : QCPlugIn
{
    CGColorSpaceRef colorSpace;
}

@property NSUInteger inputValue;
@property(assign) CGColorRef outputColor;

@end
