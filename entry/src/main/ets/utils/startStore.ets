import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';

//大方法
export class startStore{
  //1.定义context
  conext:Context

  constructor(conext: Context) {
    this.conext = conext;
  }

  //2.getStore方法
  async getStore(){
    return await dataPreferences.getPreferences(this.conext,"my_StartSql")
  }
  //存
  async putMes(data:string){
    const store=await this.getStore()
    await store.put("start",data)
    await store.flush()
  }
  //取
  async getMes(){
    const store=await this.getStore()
    let data=await store.get("start","")
    return data as string
  }

}