//
//  test.m
//  xianshengDylib
//
//  Created by nantian on 2023/4/7.
//

#import "test.h"

@implementation test

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)sss{
    NSString *string = [[NSString alloc] initWithData:nil encoding:NSUTF8StringEncoding];
    NSLog(@"解密数据：%@",string);
    if(string!=nil && string.length>30){
        if([string containsString:@"clarity_id"] && [string containsString:@"video_uri"]){
            //视频解密
            //executor.submit(upload_to_mongodbone,"videourl_list", videoinfo)
            //提交服务器
        }
        NSDictionary * arg2 =@{};
        NSString * clarity = [arg2 valueForKey:@"p"];
        if([clarity isEqualToString:@"/app/video/clarity"]){
            //保存authorization
            [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@""];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        string = [string substringToIndex:25];
    }
    NSDictionary * json =@{};
    NSArray * data = [json valueForKey:@"data"];
    
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"tasklist"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 保存任务列表到本地
     NSError *saveError = nil;
     NSData *taskListData = [NSKeyedArchiver archivedDataWithRootObject:data requiringSecureCoding:NO error:&saveError];
     if (saveError) {
//         HDDebugLog(@"Failed to save task list to local storage: %@", saveError.localizedDescription);
     } else {
         // 保存成功
//         HDDebugLog(@"Task list saved successfully!");
     }
    
    
    
    
    __block int currentIndex = 0;
    [NSTimer scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer * _Nonnull timer) {
        // 判断是否还有未执行的任务
        
        NSArray *taskList = [[NSUserDefaults standardUserDefaults] objectForKey:@"TaskList"];
        if(taskList.count > 0){
            
            NSMutableArray *mutableTaskList = [taskList mutableCopy];
            NSDictionary *task =  mutableTaskList.firstObject;
            [mutableTaskList removeObjectAtIndex:0];
            
            //执行网络操作
            
            [[NSUserDefaults standardUserDefaults] setObject:mutableTaskList forKey:@"TaskList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        
        if (currentIndex < taskList.count) {
            // 执行当前任务
            NSDictionary *task = taskList[currentIndex];
           // HDDebugLog(@"Executing task: %@", task);
            
            // 移除已执行的任务
            NSMutableArray *mutableTaskList = [taskList mutableCopy];
            [mutableTaskList removeObjectAtIndex:currentIndex];
            taskList = [mutableTaskList copy];
            NSData *updatedTaskListData = [NSKeyedArchiver archivedDataWithRootObject:taskList requiringSecureCoding:NO error:nil];
            [[NSUserDefaults standardUserDefaults] setObject:updatedTaskListData forKey:@"TaskList"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            currentIndex++;
        } else {
            // 所有任务已经执行完毕，暂停计时器
            [timer invalidate];
        }
    }];

    
    
}
@end
