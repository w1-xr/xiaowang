import { AdvertClass, advertStore } from '../../utils/advertStore'
//展示首页内容，并根据广告数据动态显示广告时间
@Entry
@Component
struct ShouYe {
  //1.先new
  store:advertStore=new advertStore(getContext(this))
  @State adData:Partial<AdvertClass>={}
  //2.保持一致
  async aboutToAppear(){
   this.adData=await this.store.getAdvert()
  }

  build() {
   Column() {
      Text("我是首页")
     if (this.adData.showAd){
       Text(this.adData.adTimeL+"")
       Image(this.adData.adImg)
     }

    }
    .height('100%')
    .width('100%')
  }
}