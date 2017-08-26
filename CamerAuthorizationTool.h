//
//  CamerAuthorizationTool.h
//  SGCQRCode
//
//  Created by uxin on 17/1/13.
//  Copyright © 2017年 liyanting. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^AuthorizaReturnBlock) ();
typedef void (^AuthorizaErrorCodeBlock) (NSString * errorCode);

@interface CamerAuthorizationTool : NSObject

@property (strong, nonatomic) AuthorizaReturnBlock returnBlock;
@property (strong, nonatomic) AuthorizaErrorCodeBlock errorBlock;

// 相机使用访问
-(void)getCameraAuthorizaionBlockWithReturnBlock: (AuthorizaReturnBlock) returnBlock
                 WithErrorBlock: (AuthorizaErrorCodeBlock) errorBlock;

//相册使用访问
- (void)getPhotoAuthorizaionBlockWithReturnBlock: (AuthorizaReturnBlock) returnBlock
                                   WithErrorBlock: (AuthorizaErrorCodeBlock) errorBlock;

@end
