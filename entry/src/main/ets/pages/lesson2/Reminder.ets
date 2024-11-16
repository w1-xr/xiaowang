//后台任务（短时任务，长时任务，延迟任务，代理提醒---（倒计时类，日历类，闹钟类））
import { notificationManager } from '@kit.NotificationKit'
import Base from '@ohos.base';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';

@Entry
@Component
struct Reminder {
//设置允不允许通知
  async onPageShow(): Promise<void> {
    let isNotificationEnabled=await notificationManager.isNotificationEnabledSync()
    if (!isNotificationEnabled){
      notificationManager.requestEnableNotification().then(()=>{
        AlertDialog.show({
          message:"允许通知"
        })
      }).catch((e:Base.BusinessError)=>{
        AlertDialog.show({
          message:"禁止通知"
        })

      })
    }
  }
@State reminderId:number=-1
  build() {
    Column() {
      //1.发布闹钟
      /*
          publishReminder(reminderReq: ReminderRequest): Promise<number>     发布一个定时提醒类通知。
          cancelReminder(reminderId: number): Promise<void>                  取消一个指定的提醒类通知。
       */
       Button("发布闹钟")
         .onClick(async ()=>{
             let reminderRequest:reminderAgentManager.ReminderRequestAlarm={
               reminderType:reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
               hour:9,
               minute:48,
               daysOfWeek:[],//每周哪几天需要重复
               wantAgent:{// 点击提醒通知后跳转的目标UIAbility信息
                 abilityName:"EntryAbility",
                 pkgName:"com.example.myapplication2"
               },
               title:"我的闹钟",
               content:"该拉粑粑了"
             }
           try {
             let reminderId=await reminderAgentManager.publishReminder(reminderRequest)
             this.reminderId=reminderId
             AlertDialog.show({
               message:"设置闹钟成功"
             })
           }catch (e){
              AlertDialog.show({
                message:JSON.stringify(e)
              })
           }
         })
      Button("关闭闹钟")
        .onClick(async ()=>{
          await reminderAgentManager.cancelReminder(this.reminderId)
          AlertDialog.show({
            message:"关闭闹钟成功"
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}