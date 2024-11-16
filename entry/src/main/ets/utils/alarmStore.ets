import { util } from '@kit.ArkTS'
import dataPreferences from '@ohos.data.preferences';
import { Context } from '@ohos.abilityAccessCtrl';

export class alarmClass{
  hour:number=0
  minute:number=0
  daysOfWeek:number[]=[]
  title:string=""
  content:string=""
  reminderId:number=-1
  id:string=""
  enabled:boolean=true
}

export class alarmStore{
  //1.定义Context
  context:Context

  constructor(context: Context) {
    this.context = context;
  }
  //2.getStore方法
  async getStore(){
    return await dataPreferences.getPreferences(this.context,"my_alarmSql")
  }
  //3.存储
  async putAlarm(data:string){
    const  store=await this.getStore()
    await store.put("myAlerm",data)
    await store.flush()
  }
  //3.取
  async getAlarm(){
    const store=await this.getStore()
    let data=await store.get("myAlerm","[]") as string
    return JSON.parse(data) as alarmClass[]
  }

}