//
//  UIImageView+UIWebImage.m
//  0321异步加载图片
//
//  Created by bever on 16/3/21.
//  Copyright © 2016年 bever. All rights reserved.
//

#import "UIImageView+UIWebImage.h"
#import <CommonCrypto/CommonDigest.h>   //含有MD5的集成头文件
#import "CaheDic.h"

@implementation UIImageView (UIWebImage) 

//要求异步加载网络图片
//把二进制数据流转换成图片比较费时


- (void)setMyImageWithURL:(NSString *)urlStr {
    NSString *md5 = [self md5:urlStr]; //对网址进行MD5加密:32位的
    NSMutableDictionary *dic = [CaheDic shareThisDic].caheDic;  //缓存
    //路径
    NSMutableString *filePath = [[NSMutableString alloc]initWithString:NSHomeDirectory()];

   
    [filePath appendFormat:@"/Documents/IMGs/%@.jpg",md5];
    
    
    
    //创建并行队列
    dispatch_queue_t queue = dispatch_queue_create(nil, DISPATCH_QUEUE_PRIORITY_DEFAULT);
    
    
    //创建异步任务：每个图片的加载的有关方法都是异步执行，不知道有没有问题
    dispatch_async(queue, ^{
       
        //创建图片：先判断缓存里有没有图片，再判断硬件里有没有，迫不得已再去加载网络数据
        UIImage *img = nil;
        
        if ([dic objectForKey:md5]) {//字典有
            img = [dic objectForKey:md5];
        }else if([[NSFileManager defaultManager]fileExistsAtPath:filePath]){
            //字典没有，看看物理存储有没有
            NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
            img = [UIImage imageWithData:data];
        
        }else{
            //加载图片的代码块
            NSURL *imgURL = [NSURL URLWithString:urlStr];
            
            NSData *imgData = [NSData dataWithContentsOfURL:imgURL];
            
            img = [UIImage imageWithData:imgData];
            
            //判断文件路径是否存在，存在就说明已经保存过了
                [[NSFileManager defaultManager]createFileAtPath:filePath contents:imgData attributes:nil];
            
            
        }
        
        //主线程刷新UI（好像没有什么影响）
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = img;
        });
        
//保存~~~~加载好图片之后，把图片存进缓存和硬盘
        //先存进缓存：是一个字典
        //先判断字典里有没有这个元素，没有话cunjinqu
        if (![dic objectForKey:md5]) {
            [dic setObject:img forKey:md5];
        }
       
       
//        [[NSFileManager defaultManager]createFileAtPath:basePath contents:img attributes:nil];
        
    });


}

//这一块比较陌生，是照网上的demo来的
//返回一个MD5类型的字符串
//要判断一下参数的有无
- (NSString *)md5:(NSString *)URLstring {

    const char *cStr = [URLstring UTF8String];
    unsigned char result[16];   //用来接受数据
    //不知道干嘛的，先用好了
    CC_MD5(cStr, (UInt32)strlen(cStr), result);
    
    //用可拼接的字符串来承接输出结果
    NSMutableString *ret = [[NSMutableString alloc]initWithCapacity:CC_MD5_DIGEST_LENGTH];  //用了一个定义宏的东西，稍后去了解
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
       
    }
    
    return ret;
    
}


@end
