//
//  XWNetwordDefine.h
//  Project
//
//  Created by xuwen on 2018/8/3.
//  Copyright © 2018年 com.Wudiyongshi.www. All rights reserved.
//

#ifndef XWNetwordDefine_h
#define XWNetwordDefine_h


/** 检查是否有 网络  没有网络展示"No network"*/
# define  CHECKNETWORKING  \
if([SANetworkManager internetStatus] == NO)\
{  \
[self showHint:@"No network" withYoff:100]; \
return; \
} \

#endif /* XWNetwordDefine_h */
