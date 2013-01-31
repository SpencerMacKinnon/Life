//
//  Shader.fsh
//  Life
//
//  Created by Spencer MacKinnon on 1/30/13.
//  Copyright (c) 2013 Spencer MacKinnon. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
