//
//  MIDI2ColorPlugIn.m
//  MIDI2Color
//
//  Created by Eddie Hillenbrand on 3/18/15.
//  Copyright (c) 2015 Eddie Hillenbrand. All rights reserved.
//

// It's highly recommended to use CGL macros instead of changing the current context for plug-ins that perform OpenGL rendering
#import <OpenGL/CGLMacro.h>

#import "MIDI2ColorPlugIn.h"

#define	kQCPlugIn_Name				@"MIDI2Color"
#define	kQCPlugIn_Description		@"Converts a MIDI value to a color with transparency."

@implementation MIDI2ColorPlugIn

@dynamic inputValue, outputColor;

+ (NSDictionary *)attributes
{
    return @{
             QCPlugInAttributeNameKey:kQCPlugIn_Name,
             QCPlugInAttributeDescriptionKey:kQCPlugIn_Description
    };
}

+ (NSDictionary *)attributesForPropertyPortWithKey:(NSString *)key
{
    if ([key isEqualToString:@"inputValue"])
        return @{
                 QCPortAttributeNameKey:@"Input Value",
                 QCPortAttributeDefaultValueKey:@(64),
                 QCPortAttributeMinimumValueKey:@(0),
                 QCPortAttributeMaximumValueKey:@(127)
        };
    
    if ([key isEqualToString:@"outputColor"])
        return @{
                 QCPortAttributeNameKey:@"Output Color"
        };
    
	return nil;
}

+ (QCPlugInExecutionMode)executionMode
{
	return kQCPlugInExecutionModeProcessor;
}

+ (QCPlugInTimeMode)timeMode
{
	return kQCPlugInTimeModeNone;
}

- (instancetype)init
{
    if (!(self = [super init])) return self;
    
    // Allocate any permanent resource required by the plug-in.
	
	return self;
}


@end

@implementation MIDI2ColorPlugIn (Execution)

- (BOOL)startExecution:(id <QCPlugInContext>)context
{
    self->colorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericRGB);
	return YES;
}

- (void)enableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance starts being used by Quartz Composer.
}

- (BOOL)execute:(id <QCPlugInContext>)context atTime:(NSTimeInterval)time withArguments:(NSDictionary *)arguments
{
    static CGFloat color[4];
    
    CGColorRef aColor;
    int pitch, octave;
    float alpha;
    
    octave = floor(self.inputValue / 12);
    pitch = (int)(self.inputValue - (octave * 12));
    
    switch (pitch) {
        // C
        case 0: color[0] = 1.0; color[1] = 0.0; color[2] = 0.0; break;
        
        // C♯/D♭
        case 1: color[0] = 1.0; color[1] = 0.5; color[2] = 0.0; break;
            
        // D
        case 2: color[0] = 1.0; color[1] = 0.75; color[2] = 0.0; break;
            
        // D♯/E♭
        case 3: color[0] = 1.0; color[1] = 1.0; color[2] = 0.0; break;
            
        // E
        case 4: color[0] = 0.5; color[1] = 1.0; color[2] = 0.0; break;
            
        // F
        case 5: color[0] = 0.0; color[1] = 1.0; color[2] = 0.0; break;
            
        // F♯/G♭
        case 6: color[0] = 0.0; color[1] = 0.5; color[2] = 0.5; break;
            
        // G
        case 7: color[0] = 0.0; color[1] = 0.0; color[2] = 1.0; break;
            
        // G♯/A♭
        case 8: color[0] = 0.25; color[1] = 0.0; color[2] = 0.75; break;
            
        // A
        case 9: color[0] = 0.3; color[1] = 0.0; color[2] = 0.5; break;
            
        // A♯/B♭
        case 10: color[0] = 0.4; color[1] = 0.0; color[2] = 0.75; break;
            
        // B
        case 11: color[0] = 0.5; color[1] = 0.0; color[2] = 1.0; break;
            
        default: color[0] = 0.5; color[1] = 0.5; color[2] = 0.5;
    }
	
    alpha = 1.0 - ((float)octave / 11.0);
    color[3] = alpha;
    
    aColor = CGColorCreate(self->colorSpace, color);
    self.outputColor = aColor;
    CGColorRelease(aColor);
    
	return YES;
}

- (void)disableExecution:(id <QCPlugInContext>)context
{
	// Called by Quartz Composer when the plug-in instance stops being used by Quartz Composer.
}

- (void)stopExecution:(id <QCPlugInContext>)context
{
    CGColorSpaceRelease(self->colorSpace);
}

@end
