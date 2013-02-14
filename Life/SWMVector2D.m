//
//  SWMVector2D.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMVector2D.h"

@implementation SWMVector2D

-(id) init {
    self = [super init];
    
    if (self) {
        *points[0] = 0.0f;
        *points[1] = 0.0f;
    }
    
    return self;
}

-(id) init: (GLfloat) X withY:(GLfloat) Y {
    
    self = [super init];
    
    if (self) {
        *points[0] = X;
        *points[1] = Y;
    }
    
    return self;
}

-(GLfloat*)x {
    return points[0];
}

-(GLfloat*)y {
    return points[1];
}

@end
