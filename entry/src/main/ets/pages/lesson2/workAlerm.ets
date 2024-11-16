import { router } from '@kit.ArkUI';
import { alarmClass, alarmStore } from '../../utils/alarmStore';
import { reminderAgentManager } from '@kit.BackgroundTasksKit';
import { util } from '@kit.ArkTS';

@Entry
@Component
struct WorkAlerm {
  @State title1: string = '删除所有';
  @State title2: string = '闹钟';
  @State title3: string = '+';
  @State alarmList:alarmClass[]=[]
  @StorageLink("status") status:string=""
  goAdd(){
    router.pushUrl({
      url:"pages/lesson2/workAdd"
    })
  }
  //3.侧滑通过id找到这条
  @Builder delBuilder(id:string){
     Button("删除")
       .onClick(async ()=>{
         let item=this.alarmList.find((v:alarmClass)=>v.id==id)//3.1.通过id找到删哪一个
         //3.2.检验是否存在
         let validReminder:Array<reminderAgentManager.ReminderInfo>=await reminderAgentManager.getAllValidReminders()
         let index=validReminder.findIndex((v:reminderAgentManager.ReminderInfo)=>v.reminderId==item!.reminderId)
         //3.3.方法删除闹钟让他不响
          if(index!=-1){
            await reminderAgentManager.cancelReminder(item?.reminderId)
          }
          //3.4.表面（数组）删除(通过id找到索引 findIndex)
         let sIndex=this.alarmList.findIndex((v:alarmClass)=>v.id==id)
         this.alarmList.splice(sIndex,1)
         //3.5.数据库删
         this.store.putAlarm(JSON.stringify(this.alarmList))

       })
  }

  //4.取消闹钟（1。关：此enabled属性变成false，调用方法闹钟不响 2.开：删掉原来的，重新发布新的）
 async  changeSeFn(id:string){
    //4.1关闹钟(FALSE)
      const copyAlarmList=[...this.alarmList]
     let item=copyAlarmList.find((v:alarmClass)=>v.id==id)
     let Sindex=copyAlarmList.findIndex((v:alarmClass)=>v.id==id)
     copyAlarmList[Sindex].enabled=false
     //不响（先有效性检验）
     let validReminder:Array<reminderAgentManager.ReminderInfo>=await reminderAgentManager.getAllValidReminders()
     let index=validReminder.findIndex((v:reminderAgentManager.ReminderInfo)=>v.reminderId==item!.reminderId)
     if(index!=-1){
       await reminderAgentManager.cancelReminder(item!.reminderId);
     }
     //2.开闹钟(删掉重新发布)---！肯定不是空，?空就不执行
   if (copyAlarmList[Sindex].enabled){
     copyAlarmList.splice(Sindex,1)
     //发布
     const request:reminderAgentManager.ReminderRequestAlarm={
       reminderType:reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
       hour:item!.hour,
       minute:item!.minute,
       daysOfWeek:item?.daysOfWeek,
       title:item?.title,
       content:item?.content
     }
     let reminderId=await reminderAgentManager.publishReminder(request)
     //数据库添加+表面添加
     let alarmobj:alarmClass={
       hour:item!.hour,
       minute:item!.minute,
       daysOfWeek:item!.daysOfWeek,
       title:item!.title,
       content:item!.content,
       reminderId:reminderId,
       id:util.generateRandomUUID(),
       enabled:true
     }
     copyAlarmList.splice(Sindex,0,alarmobj)
   }
   this.alarmList=[...copyAlarmList]
   this.store.putAlarm(JSON.stringify(this.alarmList))
  }

  //1.定义store
  store:alarmStore=new alarmStore(getContext(this))

  //2.数据保持一致
  async onPageShow(): Promise<void> {
    AppStorage.setOrCreate("status","")
    this.alarmList=await this.store.getAlarm()
  }
  build() {
      //1.主页面
      Column(){
        Row(){
          Text(this.title1)
            .fontColor("#f6a32d")
            .fontSize(18)
            .onClick(()=>{
              this.alarmList=[];
              this.store.putAlarm(JSON.stringify(this.alarmList))
              reminderAgentManager.cancelAllReminders()
            })
          Text(this.title2)
            .fontColor(Color.White)
            .fontSize(20)
          Text(this.title3)
            .fontColor("#f6a32d")
            .fontSize(28)
            .onClick(()=>{
               this.goAdd()
            })
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
        .height(50)
        //2.其他
          Row(){
            Text("其他")
              .fontColor(Color.White)
              .fontSize(25)
          }
          .height(30)
          .width("100%")
        //3.闹钟数组
        List({
          space:10
        }){
          ForEach(this.alarmList,(item:alarmClass)=>{
            ListItem(){
              AlarmCom({
                item:item,
                changeSeFn:()=>{this.changeSeFn(item.id)}
              })
            }
            //3.1点击
            .onClick(()=>{
              this.status=item.id //编辑闹钟，回显
              this.goAdd()//跳转
            })
            //3.2左滑删除
            .swipeAction({
              end:this.delBuilder(item.id)

            })
          })
        }


      }
      .backgroundColor(Color.Black)
      .padding(20)
      .width("100%")
      .height("100%")
    }
}
@Component
struct AlarmCom{
  @Prop item:alarmClass
  changeSeFn:(id:string)=>void=()=>""
  build() {
    Row(){
      //文本内容
       Column(){
         Text(this.item.hour+":"+this.item.minute)
           .fontSize(40)
           .fontColor(Color.White)
           .textAlign(TextAlign.Start)
         Row(){
           Text(this.item.title)
             .fontColor(Color.White)
             .fontSize(15)
           Text(this.item.content)
             .fontColor(Color.White)
             .margin({left:10})
             .fontSize(13)
         }

       }
       .width("100%")
       .alignItems(HorizontalAlign.Start)
       .layoutWeight(1)
      //toggle
      Toggle({
        type:ToggleType.Switch,
        isOn:this.item.enabled
      })
        .onChange(()=>{
          this.changeSeFn(this.item.id)
        })

    }
    .margin({top:10})
    .justifyContent(FlexAlign.Start)
    .width("100%")

  }
}
