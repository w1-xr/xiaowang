import { addWeek, WeekClass } from '../../componet/addWeek'
import { alarmClass, alarmStore } from '../../utils/alarmStore'
import { reminderAgentManager } from '@kit.BackgroundTasksKit'
import { util } from '@kit.ArkTS'
import { router } from '@kit.ArkUI'
import { item } from '../../componet/item'

class wenziClass{
  title:string=""
  content:string=""
  icon?:string=""
}
const weeks:WeekClass[]=[
  {
    weekTitle:"周一",
    value:1,
    selected:false
  },
  {
    weekTitle:"周二",
    value:2,
    selected:false
  },
  {
    weekTitle:"周三",
    value:3,
    selected:false
  },
  {
    weekTitle:"周四",
    value:4,
    selected:false
  },
  {
    weekTitle:"周五",
    value:5,
    selected:false
  },
  {
    weekTitle:"周六",
    value:6,
    selected:false
  },
  {
    weekTitle:"周日",
    value:7,
    selected:false
  },
]
@Entry
@Component
struct WorkAdd {
  @StorageLink("status") status:string=""
  @State selectedTime:Date=new Date()
  @State h:number=-1
  @State m:number=-1
  @State content:string=""
  @State naoling:string="打雷"
  @State title:string=""
  @State repeatContent:string=""
  @State alarmList:alarmClass[]=[]
  @State daysOfWeek:number[]=[];
  @State weekVib:Visibility=Visibility.None
  @State Vib:Visibility=Visibility.Visible
  @State currentTime:Partial<TimePickerResult>={
    hour:0,
    minute:0
  }
  @Watch("weekChange") @State myWeeks:WeekClass[]=weeks;
  weekChange(){
    //daysOfWeek跟随改变；
    this.daysOfWeek=this.myWeeks.map((v:WeekClass)=>v.selected ? v.value : 0).filter((v:number)=>v!=0);
    let str="";
    let copyWeek:WeekClass[]=[...this.myWeeks];
    switch (JSON.stringify(this.daysOfWeek)){
      case "[1,2,3,4,5]":str="工作日";break;
      case "[1,2,3,4,5,6,7]":str="每天";break;
      case "[]":str="不重复";break;
      default :
        let myW:string[]=[]
        for(let i=0;i<this.daysOfWeek.length;i++){
          let val=this.daysOfWeek[i];//1,2,3
          copyWeek.forEach((v:WeekClass)=>{
            if(v.value==val){
              myW.push(v.weekTitle)
            }
          })
        }
        this.repeatContent=myW.join("、")
    }
  }
  //1.先定义store
  store:alarmStore=new alarmStore(getContext(this))
  //2.保持一致(修改的话就回显)
  async onPageShow(): Promise<void> {
    this.alarmList=await this.store.getAlarm();
    if (this.status){//修改的话就回显
      let item=this.alarmList.find((v:alarmClass)=>v.id==this.status);
      this.title=item!.title;
      this.content=item!.content;
      let d=new Date();
      d.setHours(item!.hour)
      d.setMinutes(item!.minute)
      this.selectedTime=d;
      this.daysOfWeek=item!.daysOfWeek;
      let copyWeek=[...this.myWeeks];
      for(let i=0;i<this.daysOfWeek.length;i++){
        //this.daysOfWeek[i];//1 3
        let val=this.daysOfWeek[i]
        copyWeek=copyWeek.map((v:WeekClass)=>{

          if(v.value==val){
            v.selected=true;
          }
          return v;
        })
      }
      this.myWeeks=Array.from(copyWeek);
    }
    this.currentTime={
      hour:this.selectedTime.getHours(),
      minute:this.selectedTime.getMinutes()
    }
  }
  async save(){
    //添加一个闹钟，存到首选项里；
    //修改闹钟：取消原来的闹钟，删掉这个闹钟，重新添加一个
    //发布闹钟：
    let sIndex=-1;
    if(this.status){
      let item=this.alarmList.find((v:alarmClass)=>v.id==this.status);

      //是否还存在该闹钟；
      let validReminder:Array<reminderAgentManager.ReminderInfo>=await reminderAgentManager.getAllValidReminders()
      let index=validReminder.findIndex((v:reminderAgentManager.ReminderInfo)=>v.reminderId==item!.reminderId)
      if(index!=-1){
        await reminderAgentManager.cancelReminder(item!.reminderId);
      }
      sIndex=this.alarmList.findIndex((v:alarmClass)=>v.id==this.status);
      this.alarmList.splice(sIndex,1);
    }
    let daysOfWeek=[...this.daysOfWeek]

    const reminderReq:reminderAgentManager.ReminderRequestAlarm={
      reminderType:reminderAgentManager.ReminderType.REMINDER_TYPE_ALARM,
      hour:this.currentTime.hour!,
      minute:this.currentTime.minute!,
      daysOfWeek:[...daysOfWeek],//待定
      title:this.title,
      content:this.content
    }
    let reminderId = 0;
    try {
      reminderId=await reminderAgentManager.publishReminder(reminderReq);
    } catch (e) {
      console.log(JSON.stringify(e))
    }
    // console.log(reminderId+"")
    let alarmObj:alarmClass={
      hour:this.currentTime.hour!,
      minute:this.currentTime.minute!,
      daysOfWeek:this.daysOfWeek,
      title:this.title,
      content:this.content,
      reminderId:reminderId,
      id:util.generateRandomUUID(),
      enabled:true
    }
    if(this.status){
      this.alarmList.splice(sIndex,0,alarmObj)
    }else {
      this.alarmList.push(alarmObj);
      console.log(JSON.stringify(this.alarmList)+"999")
    }
    this.store.putAlarm(JSON.stringify(this.alarmList))
    AlertDialog.show({
      message:this.status ? "修改成功" : "添加成功"
    })
  }
  build() {
    Column(){
      //添加页面
      Column() {
        Row(){
          Text("取消")
            .fontColor("#f6a32d")
            .fontSize(18)
            .onClick(()=>{
              router.pushUrl({
                url:"pages/lesson2/workAlerm"
              })
            })
          Text(this.status?"修改闹钟":"添加闹钟")
            .fontColor(Color.White)
            .fontSize(20)
          Text("存储")
            .fontColor("#f6a32d")
            .fontSize(18)
            .onClick( ()=>{
              //添加或者修改
              this.save()
            })
        }
        .width("100%")
        .justifyContent(FlexAlign.SpaceBetween)
        .height(50)
        TimePicker({
          selected:this.selectedTime
        })
          .useMilitaryTime(false)
          .onChange((value:TimePickerResult)=>{
            this.currentTime.hour=value.hour
            this.currentTime.minute=value.minute
            let p=value.hour>=12 ? "下午" :'上午';
            //0:12
            //1-11:1-11
            //12:12
            //13:1
            //14:2
            let h=value.hour==0 || value.hour==12 ? 12 : value.hour%12;
          })
          .width('100%')
          .height(200)
          .textStyle({color: '#fff'})
          .disappearTextStyle({color: '#fff'})
          .selectedTextStyle({
            color:Color.White,
            font: {
              size: 27
            }
          })
        //设置
        Column(){
          item({
            Vib:this.Vib,
            weekVib:this.weekVib,
            title:"重复",
            content:this.repeatContent,
            icon:"/images/rback.png"
          })
          item({
            Vib:this.Vib,
            weekVib:this.weekVib,
            title:"标题",
            content:this.title,
            icon:""
          })
          item({
            Vib:this.Vib,
            weekVib:this.weekVib,
            title:"内容",
            content:this.content,
            icon:""
          })
          item({
            Vib:this.Vib,
            weekVib:this.weekVib,
            title:"闹铃",
            content:this.naoling,
            icon:""
          })
        }
        .borderRadius(10)
        .width("100%")
        .height(200)
        .backgroundColor("#2c2c2c")

      }
      .padding(20)
      .backgroundColor('black')
      .height('100%')
      .width('100%')
      .visibility(this.Vib)
      //添加周几页面
      addWeek({
        daysOfWeek:this.daysOfWeek,
        myWeeks:this.myWeeks,
        weekVib:this.weekVib,
        Vib:this.Vib
      })
    }

  }
}