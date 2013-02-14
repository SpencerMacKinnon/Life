//
//  SWMVector2D.h
//  Life
//
//  Created by Spencer MacKinnon on 2/10/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWMVector2D : NSObject {
    GLfloat *points[2];
}

- (GLfloat*) x;
- (GLfloat*) y;

@end
