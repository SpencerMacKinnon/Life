//
//  SWMVector3D.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMVector3D : NSObject {
    GLfloat *points[3];
}

- (id) initWithX: (GLfloat)X Y:(GLfloat) Y Z:(GLfloat) Z;
- (GLfloat*) x;
- (GLfloat*) y;
- (GLfloat*) z;

@end
