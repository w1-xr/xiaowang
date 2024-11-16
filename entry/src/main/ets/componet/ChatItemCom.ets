import { chatClass } from '../utils/ChatStore';

@Component
struct ChatItemCom{
  @Prop item:chatClass;
  @State showPop:boolean=false;
  delFn:(id:string)=>void=()=>""
  @Builder popupBuilder(){
    Text('删除')
      .height(30)
      .textAlign(TextAlign.Center)
      .width(100)
      .onClick(()=>{
        //删除
        this.delFn(this.item.id)
        this.showPop=false;
      })
  }
  build() {
    Row(){
      Image(this.item.avatar)
        .width(50)
        .margin({
          left:10,
          right:10
        })
      Text(this.item.content)
        .backgroundColor(this.item.selfFlag ? "#00ff00" : "#fff")
        .padding(10)
        .borderRadius(5)
    }
    .margin({top:15})
    .height(40)
    .width("100%")
    .direction(this.item.selfFlag ? Direction.Rtl : Direction.Ltr)
    .gesture(
      LongPressGesture()
        .onAction(()=>{
          this.showPop=true;
        })
    )
    .bindPopup(this.showPop,{
      builder: this.popupBuilder, // 气泡的内容
      placement:Placement.Top, // 气泡的弹出位置
      popupColor:Color.Gray, // 气泡的背景色
    })
  }
}
export {ChatItemCom}