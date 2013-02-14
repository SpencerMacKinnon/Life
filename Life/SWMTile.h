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
    
}

extern const int TOTAL_VERTICES;

@property (nonatomic) GLfloat *diffuseLightColour;

-(id) init2;

@end
