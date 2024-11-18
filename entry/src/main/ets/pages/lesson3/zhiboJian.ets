class bottomIconClass{
  icon:string=""
}
//1.定义类型
class MyCurveClass{
  curve:Curve
  iconS:string

  constructor(curve: Curve, iconS: string) {
    this.curve = curve
    this.iconS = iconS
  }
}
//定义数组
const MyCurveData:MyCurveClass[]=[
  new MyCurveClass(Curve.Linear,"/images/gift.png"),
  new MyCurveClass(Curve.Ease,"/images/wang.png"),
  new MyCurveClass(Curve.EaseIn,"/images/liu.png"),
  new MyCurveClass(Curve.EaseOut,"/images/search.png"),
  new MyCurveClass(Curve.EaseInOut,"/images/88.png"),
]
@Entry
@Component
struct ZhiboJian {
  @State index:number=1
  @State InputText:string=""
  @State y:number=0
  @State op:number=1
  @Builder bottomIcon($$:bottomIconClass){
    Row(){
      Image($$.icon)
        .width(22)
    }
    .margin({left:5})
    .justifyContent(FlexAlign.Center)
    .width(34)
    .height(34)
    .borderRadius(17)
    .backgroundColor("rgba(0,0,0,0.2)")
  }
@Styles imgStyle(){
    .width(22)
   .height(22)
   .borderRadius(10)
}
  build() {
    Stack(){
      //1.背景图片
      Column(){}
      .height('100%')
      .width('100%')
      .backgroundImage("/images/wangshaonv")
      .backgroundImageSize(ImageSize.Cover)
      // .expandSafeArea([SafeAreaType.KEYBOARD,SafeAreaType.SYSTEM])

      //2.直播间swipper
      Swiper(){
        //swiper1 空白区
        Column(){

        }
        .width("100%")
        .height("100%")
        //swiper2 内容区
        Column(){
          //顶部
          Row(){
            Row(){//左边
             Row(){
               Text("YokLass")
                 .fontWeight(900)
                 .fontSize(8)
             }
             .padding(3)
              .width(40)
              .height(40)
              .backgroundColor(Color.White)
              .borderRadius(20)
              Text("王少女的店铺")
                .fontColor(Color.White)
                .fontSize(12)
                .fontWeight(600)
                .margin({left:5,right:5})
              Row(){
                Image("/images/huyuan.png")
                  .width(20)
                  .position({left:11.5,top:6})
              }
              .width(45)
              .height(30)
              .borderRadius(15)
              .backgroundColor("#ec9e38")
            }
            .backgroundColor("rgba(0,0,0,0.1)")
            .borderRadius("50%")
            .padding(3)
            Row(){//右边
               Image("/images/wang.png")
                 .imgStyle()
               Image("/images/liu.png")
                 .imgStyle()
                 .margin({left:5,right:5})
               Image("/images/wuliu.png")
                 .imgStyle()
              Row(){
                 Text("656")
                   .fontColor(Color.White)
                   .fontSize(13)
              }
              .justifyContent(FlexAlign.Center)
              .width(40)
              .height(30)
              .borderRadius(15)
              .backgroundColor("rgba(0,0,0,0.1)")
              .margin({left:5,right:5})
              Text("x")
                .fontColor(Color.White)
                .fontSize(20)
            }
          }
          .width("100%")
          .justifyContent(FlexAlign.SpaceBetween)
          //评论区
          //底部导航
          Row(){
            TextInput({
              placeholder:"说点什么...",
              text:$$this.InputText
            })
              .placeholderColor("#e0e2e4")
              .layoutWeight(1)
              .backgroundColor("rgba(0,0,0,0.2)")
              .fontSize(15)
              .fontColor("#e0e2e4")
            Row(){
              this.bottomIcon({icon:"/images/lm.png"})
              this.bottomIcon({icon:"/images/car.png"})
              this.bottomIcon({icon:"/images/gift.png"})
            }
            Row(){
              Text("...")
                .fontColor(Color.White)
                .fontSize(25)
                .position({top:-5,left:8})
            }
            .width(37)
            .height(34)
            .borderRadius(17)
            .backgroundColor("rgba(0,0,0,0.2)")

          }
          .position({bottom:3,left:3})
          //礼物往上走
          Column(){
             ForEach(MyCurveData,(item:MyCurveClass)=>{
               Image(item.iconS)
                 .width(25)
                 .height(25)
                 .position({
                   right:40,
                   bottom:70
                 })
                 .opacity(this.op)
                 .translate({
                   y:this.y
                 })
                 .animation({
                   duration:1000,
                   curve:item.curve,
                   iterations:-1
                 })
             })
          }
          .width(60)
          .height(60)
          .position({bottom:-30,right:0})
          .onAppear(()=>{
            this.y=-120
            this.op=0
          })
        }
        .width("100%")
        .height("100%")
        .padding(5)
      }
        .width("100%")
        .height("100%")
        .loop(false)
        .indicator(false)
        .index(this.index)
      .effectMode(EdgeEffect.None)
    }
  }
}