//
//  Const.h
//  MVVMNews
//
//  Created by ios开发 on 2018/1/23.
//  Copyright © 2018年 ios开发. All rights reserved.
//

#ifndef Const_h
#define Const_h


//标题字体
#define LFTitleFont      [UIFont systemFontOfSize:15]
//子标题字体
#define LFSubtitleFont      [UIFont systemFontOfSize:13]

//通过RGB设置颜色
#define LFRGBColor(R,G,B)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1.0]

//应用程序的屏幕高度
#define LFSCREENHEIGHT        [UIScreen mainScreen].bounds.size.height
//应用程序的屏幕宽度
#define LFSCREENWIDTH        [UIScreen mainScreen].bounds.size.width

//通过Storyboard ID 在对应Storyboard中获取场景对象  （\：换行）
#define kVCFromSb(storyboardId, storyboardName)     [[UIStoryboard storyboardWithName:storyboardName bundle:nil] \
instantiateViewControllerWithIdentifier:storyboardId]

//移除iOS7之后，cell默认左侧的分割线边距   Preserve:保存
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}

//Docment文件夹目录
#define LFDocumentPath NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject


#endif /* Const_h */
