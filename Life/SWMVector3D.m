//
//  SWMVector3D.m
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import "SWMVector3D.h"

@implementation SWMVector3D

-(id) init {
    self = [super init];
    
    if (self) {
        *points[0] = 0.0f;
        *points[1] = 0.0f;
        *points[2] = 0.0f;
    }
    
    return self;
}

-(id) initWithX: (GLfloat) X Y:(GLfloat) Y Z: (GLfloat) Z{
    
    self = [super init];
    
    if (self) {
        *points[0] = X;
        *points[1] = Y;
        *points[2] = Z;
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

@end
