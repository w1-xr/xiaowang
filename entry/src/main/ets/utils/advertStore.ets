import dataPreferences from '@ohos.data.preferences';
import { Context } from '@kit.AbilityKit';
export class AdvertClass{
  showAd:boolean=false;//是否显示广告
  adTimeL:number=5;//广告倒计时
  adUrl?:string="";//广告的链接
  adImg:ResourceStr="";//广告的图片
}


//大方法
export class advertStore{
  //this.content模式
  //1.定义content
  context:Context;
  constructor(context: Context) {
    this.context = context;
  }
   //2.getStore方法
  async getStore(){
    return await dataPreferences.getPreferences(this.context,"my_advertSql");
  }
    //3.存
  async putAdvert(data:string){
    const store=await this.getStore();
    await store.put("myAdvert",data);
    await store.flush()
  }
    //4.取
  async getAdvert(){
    const store=await this.getStore();
    let data=await store.get("myAdvert","{}") as string;
    return JSON.parse(data) as AdvertClass;
  }

}