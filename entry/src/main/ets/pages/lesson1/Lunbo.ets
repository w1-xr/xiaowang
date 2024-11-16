import { router } from '@kit.ArkUI';
import { startStore } from '../../utils/startStore';

@Entry
@Component
struct Lunbo {
  store:startStore=new startStore(getContext(this))

  build() {
    Swiper(){
      Image("/images/liu.png")
        .width("100%")
        .height("100%")
      Image("/images/wang.png")
        .width("100%")
        .height("100%")
    }
    .height('100%')
    .width('100%')
    .indicator(true)
    .onChange((index:number)=>{
      if(index==1){
        router.replaceUrl({
          url:"pages/lesson1/ShouYe"
        })
        this.store.putMes("started")
      }
    })
  }
}