//
//  UIImage-Targa.m
//  Quake3-iOS
//
//  Created by Tom Kidd on 12/6/19.
//  Copyright © 2019 Tom Kidd. All rights reserved.
//

#import "UIImage-Targa.h"
#import "tga_reader.h"

@implementation UIImage(Targa)
+(id)imageFromTGAFile:(NSString *)filename{
    FILE *file = fopen([filename UTF8String], "rb");
    if(file) {
        fseek(file, 0, SEEK_END);
        int size = (int)ftell(file);
        fseek(file, 0, SEEK_SET);
        
        unsigned char *buffer = (unsigned char *)tgaMalloc(size);
        fread(buffer, 1, size, file);
        fclose(file);
        
        int width = tgaGetWidth(buffer);
        int height = tgaGetHeight(buffer);
        int *pixels = tgaRead(buffer, TGA_READER_ABGR);
        
        tgaFree(buffer);
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGBitmapInfo bitmapInfo = (CGBitmapInfo)kCGImageAlphaLast;
        CGDataProviderRef providerRef = CGDataProviderCreateWithData(NULL, pixels, 4*width*height, releaseDataCallback);
        
        CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4*width, colorSpaceRef, bitmapInfo, providerRef, NULL, 0, kCGRenderingIntentDefault);
        
        UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
        
        CGColorSpaceRelease(colorSpaceRef);
        
        return image;
    }
    
    return nil;
}

static void releaseDataCallback(void *info, const void *data, size_t size) {
    tgaFree((void *)data);
}

@end
