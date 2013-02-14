//
//  SWMVector4D.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMVector4D.h"

@implementation SWMVector4D

-(id) init {
    self = [super init];
    
    if (self) {
        *points[0] = 0.0f;
        *points[1] = 0.0f;
        *points[2] = 0.0f;
        *points[3] = 0.0f;
    }
    
    return self;
}

-(id) init: (GLfloat) X withY:(GLfloat) Y withZ:(GLfloat) Z withW:(GLfloat) W{
    
    self = [super init];
    
    if (self) {
        *points[0] = X;
        *points[1] = Y;
        *points[2] = Z;
        *points[3] = W;
    }
    
    return self;
}

-(GLfloat*)x {
    return points[0];
}

-(GLfloat*)y {
    return points[1];
}

-(GLfloat*)z {
    return points[2];
}

-(GLfloat*)w {
    return points[3];
}

@end
