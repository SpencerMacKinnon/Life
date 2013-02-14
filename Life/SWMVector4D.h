//
//  SWMVector4D.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMVector4D : NSObject {
    GLfloat *points[4];
}

- (GLfloat*) x;
- (GLfloat*) y;
- (GLfloat*) z;
- (GLfloat*) w;

@end
