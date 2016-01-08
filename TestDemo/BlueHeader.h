//
//  BlueHeader.h
//  Thermometer
//
//  Created by ouguoquan on 14/10/30.
//  Copyright (c) 2014年 ouguoquan. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "BluetoothManager.h"
//#import "TemperatureInfo.h"
//#import "DeviceEntity.h"
//#import "HistoryEntity.h"
//#import "EventLogEntity.h"
//#import "TemperatureInfo.h"
//#import "CoreManager.h"
//#import "common.h"
//#import "CoreDataModel.h"
//#import "DataModel.h"
//#import "CoreOperate.h"
//#import "LastEntity.h"
//#import "SystemBellsManager.h"
//#import "LocalLanguageManager.h"
//#import "VersionManage.h"
//#import "BaseicAnimation.h"

#define K_FIRST_LANUCH    @"first_lanuch" //第一次启动   true false
#define K_OPEN_VIBRATION  @"openvibration" //震动key
#define K_OPEN_BELLS      @"openbells" //铃声
#define K_ALLOW_UPLOAD    @"allowUpload"//允许上传

#define K_INPUT_PSD       @"123654"

#define K_Change_UNITS    @"changeuints"//单位

#define K_USER_LANGUAGE   @"userLanguage"

#define K_SET_LANGUAGE    @"setLanguage"

#define K_LOGIN [[[PLIST valueForKey:@"userInfo"]valueForKey:@"status"]isEqualToString:@"success"]

#define K_USER_BELLS      @"userbells"

#define K_USER_INFO      @"userInfo"//用户登录信息

#define mainWidth    self.view.frame.size.width
#define mainHeight   self.view.frame.size.height


//fqdao
#define K_USER_Terms @"setTerms"//同意协议

#define K_USER_FIRST_AGREE @"First_agree"//第一次同意协议
//fqdao


#define K_GOTO_SLEEPSET   @"k_goto_sleepset"//睡姿设置  uuid  sleepSet

#define K_IS_HUASHEDU     [PLIST boolForKey:K_Change_UNITS] //默认为no 标准单位c

#define K_IS_OPEN_VIBRATION [PLIST boolForKey:K_OPEN_VIBRATION]  //是否开启震动

#define k_IS_ALLOW_UPLOAD   [PLIST boolForKey:K_OPEN_VIBRATION]  //是否允许数据上传

#define returnNormTem(tem)          [NSString stringWithFormat:@"%@℃",[common cutdecimalwithFormat:@"0.0" floatV:[tem floatValue]]]


#define K_FIR_UPDATE_URL   @"http://fir.im/tem1000"
#define MQTTHosts @"119.134.251.155"
#define Host @"http://api.bbcheck.net:8800/index"
#define K_LCD_FOND        @"LcdD"//@"LCD2"
#define K_Gotham_FOND @"Gotham Rounded"

#define K_LABEL_TEXT_COLOR    [UIColor colorWithRed:28/255.0 green:158/255.0 blue:247/255.0 alpha:1.0]

#define k_LEFT_VC_WIDTH       280.0f


#define K_EMPTY_UUID        @"0"

#define K_SHOW_PF           false


#define k_LAST_USER_ID      @"lastuserid"


#define k_BLUE_COLOR_VALUE  0x01bdda   //蓝色
#define k_YELLOW_COLOR_VALUE  0xffd200  //黄色
#define k_ORANGE_COLOR_VALUE  0xe9611d  //橙色
#define K_purple_COLOR_VALUE   0x9160af  //紫色


//睡姿
typedef NS_ENUM(NSInteger, MainViewSelectType)
{
    MainViewSelectTypeTemperture = 1,     //温度
    MainViewSelectTypeShare      = 2,     //分享
    MainViewSelectTypeCare       = 3,     //医疗
    MainViewSelectTypeSleep      = 4,     //睡姿
    MainViewSelectTypePF         = 5,     //防丢功能
};


//脱落温度值
#define TempertureVauleFallOff        32.2

//高温警告通知消息（通过通知消息进入到主界面）
#define k_USER_NOTIFICATION_WARN      @"KeyNotificationWarn"

//后台重新激活app通知消息
#define k_USER_ACTION_WARN      @"keyApplicationDidBecomeActive"

//通知类型
#define TypeNotificationKey @"TypeNotificationKey"
    //高温报警
    #define Type_Notification_Warn @"TypeNotificationWarn"
    //脱落
    #define Type_Notification_FallOff @"TypeNotificationFallOff"
    //断开
    #define Type_Notification_DisConnect @"TypeNotificationDisConnect"
    //重新连接
    #define Type_Notification_ReConnect @"TypeNotificationReConnect"

@interface BlueHeader : NSObject

@end
