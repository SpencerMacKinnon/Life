//
//  SWMTile.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMModel.h"
#import <GLKit/GLKit.h>

@interface SWMTile : SWMModel
{
    GLuint colourIndex;
    GLKVector4 diffuseLightColour;
}

extern const int TOTAL_VERTICES;

@property (nonatomic) GLKVector4 diffuseLightColour;
@property GLuint colourIndex;

-(id) init2;

@end
