//
//  SWMTile.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMTile.h"

@implementation SWMTile

@synthesize diffuseLightColour = _diffuseLightColour;
@synthesize colourIndex = _colourIndex;
@synthesize row = _row;
@synthesize column = _column;
@synthesize isActive = _isActive;

- (id)init{
    
    self = [super init];
    if (self) {
        GLKVector4 diffuseLightColourBlack = GLKVector4Make(0.0, 0.0, 0.0, 0.0);
        GLKMatrix4 mvMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, 0.0f);
        [self setDiffuseLightColour:diffuseLightColourBlack];
        [self setModelViewMatrix: mvMatrix];
        _row = 0;
        _column = 0;
        _isActive = false;
    }
    return self;
}

- (id)initWith:(GLKMatrix4)mvMatrix andColour:(GLKVector4)colour{
    self = [self init];
    if (self) {
        [self setModelViewMatrix:mvMatrix];
        [self setDiffuseLightColour:colour];
        _row = 0;
        _column = 0;
        _isActive = false;
    }
    
    return self;
}

- (BOOL)loadShaders{
    // Override point for custom shader attributes.
    if ([super loadShaders]) {
        _colourIndex = glGetUniformLocation([_shader program], "diffuseColour");
    }
    // TODO: Release on teardown
    [super releaseShaders];
    return YES;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect withColour:(BOOL)colour{
    // TODO: Refactor this to call only the models draw call, perhaps using a property bag?
    [super glkView:view drawInRect:rect];
    
    if (colour) {
        glUniform4f(_colourIndex, _diffuseLightColour.x, _diffuseLightColour.y, _diffuseLightColour.z, _diffuseLightColour.w);
    }
    else {
        glUniform4f(_colourIndex, 0.0f, 0.0f, 0.0f, 0.0f);
    }
}

@end
