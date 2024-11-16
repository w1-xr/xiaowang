//通知
import { notificationManager } from '@kit.NotificationKit'
import Base from '@ohos.base';
import { Want, WantAgent, wantAgent } from '@kit.AbilityKit';
@Entry
@Component
struct Notification {
  @State badgeNumber:number=0
  async  onBackground(): Promise<void>{
      let activeList=await notificationManager.getActiveNotifications();//调用方法
      this.badgeNumber=activeList.length
      notificationManager.setBadgeNumber(this.badgeNumber);
  }

  async onPageShow(): Promise<void> {
    //4.减少角标
    /*
    getActiveNotifications(callback: AsyncCallback<Array<NotificationRequest>>): void    获取当前应用未删除的通知列表。通过该方法，可以查看目前的通知个数，从而设置角标
     */
    //获取未读的通知的个数，设置角标；
    let activeList=await notificationManager.getActiveNotifications();//调用方法
    this.badgeNumber=activeList.length
    notificationManager.setBadgeNumber(this.badgeNumber);
    //1.判断是否授权过
    /* 接口名以及描述
     isNotificationEnabled():Promise<boolean>  查询通知是否授权
     requestEnableNotification(callback: AsyncCallback<void>): void  请求发送通知的许可，第一次调用会弹窗让用户选择
 */
    let isNotificationEnabled=await notificationManager.isNotificationEnabledSync()
    if (!isNotificationEnabled){
      //没授权过，弹出授权窗口
      notificationManager.requestEnableNotification().then(()=>{
        AlertDialog.show({
          message:"允许通知"
        })
      }).catch((e:Base.BusinessError)=>{
        if (e.code==1600004){
          AlertDialog.show({
            message:"禁止通知"
          })
        }
      })
    }
  }


  build() {
    Column() {
      //2.发布通知
      /*
          publish(request: NotificationRequest, callback: AsyncCallback<void>): void   发布通知
          cancel(id: number, label: string, callback: AsyncCallback<void>): void  取消指定的通知
          cancelAll(callback: AsyncCallback<void>): void; 取消所有该应用发布的通知。**

       */
      //2.1 普通文本
       Button("发送通知-普通文本")
         .onClick(async ()=>{
           const request:notificationManager.NotificationRequest={
             id:1,
             content:{
               notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
              normal:{
                 title:"胡延伸发来了1条消息",
                 text:"拉粑粑吗？"
              }
             }
           }
           await notificationManager.publish(request)
         })

      //2.2 多行文本
      Button("发送通知-多行文本")
        .onClick(async ()=>{
          const request:notificationManager.NotificationRequest={
            id:2,
            content:{
              notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE,
              multiLine:{
                title:"我是多行文本的标题",//收起时候展示的标题
                text:"下去沉淀吧",//收起时候展示的内容
                additionalText:"我是附加内容",
                briefText:"我是概要内容",
                longTitle:"我是展开时候的标题",//点开时候的标题
                lines:["我是第一行","我是第二行","我是第三行","我是第四行"]//点开时候展示的内容
              }
            }
          }
            await notificationManager.publish(request)
        })

      //2.3 长文本
      Button("发送通知-长文本")
        .onClick(async ()=>{
          const request:notificationManager.NotificationRequest={
            id:3,
            content:{
              notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT,
              longText:{
                title:"我是长文本的标题啦啦啦",//收起时候展示的标题
                text:"lalalalalallala",//收起时候展示的内容
                longText:"我时常文本",//点开时候展示的内容
                briefText:"我是概要内容",
                expandedTitle:"我是展开时候的长文本标题"//点开时候的标题
              }
            }
          }
          await notificationManager.publish(request)
        })

      //2.4.发布进度条类型文本
      Button("发布通知-进度条类型")
        .onClick(async ()=>{
          notificationManager.isSupportTemplate("downloadTemplate").then(async (flag:boolean)=>{
            if (flag){//如果是发布的话
              const request:notificationManager.NotificationRequest={
                id:4,
                content:{
                  notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
                  normal:{
                    title:"这个店",
                    text:"只有老板是老的",
                    additionalText:"我是附加文本"
                  }
                },
                template:{
                  name:"downloadTemplate",
                  data:{
                    title:"文件名",
                    fileName:"music.mp7",
                    progressValue:50
                  }
                }
              }
              await notificationManager.publish(request)
            }else {
                AlertDialog.show({
                  message:"此功能不支持"
                })
            }
          }).catch((e:Base.BusinessError)=>{
            console.log(`error:${e}`)
          })
        })

      //3.为通知添加行为意图  WantAgent
      /*
            getWantAgent(info: WantAgentInfo, callback: AsyncCallback<WantAgent>): void   创建WantAgent。
            trigger(agent: WantAgent, triggerInfo: TriggerInfo, callback?: Callback<CompleteData>): void    触发WantAgent意图。
            cancel(agent: WantAgent, callback: AsyncCallback<void>): void    取消WantAgent。
            getWant(agent: WantAgent, callback: AsyncCallback<Want>): void    获取WantAgent的want。
            equal(agent: WantAgent, otherAgent: WantAgent, callback: AsyncCallback<boolean>): void   判断两个WantAgent实例是否相等
       */
      /* WantAgentInfo类型
           wants             Array<[Want]>                        是     将被执行的动作列表。wants数组为预留能力，当前只支持一个want。传入多个时只取wants数组的第一个成员。
           actionType11+     wantAgent.OperationType              否     动作类型。
           requestCode       number                               是     使用者定义的一个私有值。
           actionFlags11+    Array<[wantAgent.WantAgentFlags]>    否     动作执行属性。
           extraInfo         { [key: string]: any }               否     额外数据。
           extraInfos11+     Record<string, Object>               否     额外数据。推荐使用该属性替代extraInfo，设置该属性后，extraInfo不再生效
       */
      /*
          OperationType
        | 名称              | 值   | 说明                      |
        | ----------------- | ---- | ------------------------- |
        | UNKNOWN_TYPE      | 0    | 不识别的类型。            |
        | START_ABILITY     | 1    | 开启一个有页面的Ability。 |
        | START_ABILITIES   | 2    | 开启多个有页面的Ability。 |
        | START_SERVICE     | 3    | 开启一个无页面的ability。 |
        | SEND_COMMON_EVENT | 4    | 发送一个公共事件。        |
       */
      Button("为通知添加行为意图")
        .onClick(async ()=>{
          let wantAgentObj:WantAgent;//用于保存创建成功的WantAgent对象
          const info:wantAgent.WantAgentInfo={
            wants:[
              {
                bundleName:"com.example.myapplication2",
                abilityName:"EntryAbility"
              }
            ],
            requestCode:0,
            actionType:wantAgent.OperationType.START_ABILITY,
            wantAgentFlags:[wantAgent.WantAgentFlags.CONSTANT_FLAG]
          }
          //3.1 准备意图
          wantAgentObj=await wantAgent.getWantAgent(info)
          //3.2 准备通知
          let id=(new Date()).getTime()
          const request:notificationManager.NotificationRequest={
            id:id,
            content:{
              notificationContentType:notificationManager.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT,
              normal:{
                title:"我要跳转到首页"+id,
                text:"jump jump jump"
              }
            },
            wantAgent:wantAgentObj
          }
          await notificationManager.publish(request);

          //4.管理通知角标
          /*
              setBadgeNumber(badgeNumber: number, callback: AsyncCallback<void>): void     设置角标个数。
           */
          this.badgeNumber++ // 一发布通知角标就+1
          notificationManager.setBadgeNumber(this.badgeNumber) //设置通知角标
        })

      //5.清空通知
      Button("清空通知")
        .onClick(async ()=>{
          await notificationManager.cancelAll()
          this.badgeNumber=0
          await notificationManager.setBadgeNumber(0)
        })
    }
    .height('100%')
    .width('100%')
  }
}