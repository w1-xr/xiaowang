//小球转
//1.定义类型
class MyCurve{
 curve:Curve
 color:Color |string
  constructor(curve: Curve, color: Color | string) {
    this.curve = curve
    this.color = color
  }
}
//定义数组
const MyCurveDataa:MyCurve[]=[
  new MyCurve(Curve.Linear,Color.Red),
  new MyCurve(Curve.Ease,Color.Orange),
  new MyCurve(Curve.EaseIn,Color.Yellow),
  new MyCurve(Curve.EaseOut,Color.Green),
  new MyCurve(Curve.EaseInOut,Color.Blue),
  new MyCurve(Curve.FastOutSlowIn,Color.Pink),
]
@Entry
@Component
struct BallZhuan {
  @State angle:number=0
  build() {
    Column() {
      //轨道200*200
      Stack(){
        ForEach(MyCurveDataa,(item:MyCurve)=>{
          //1.每一个都是长方形+小球
          Column(){
            Text()
              .width(30)
              .height(30)
              .backgroundColor(item.color)
              .borderRadius(15)
          }
          .width(30)
          .height(200)
          //2.旋转度数
          .rotate({
            angle:this.angle
          })
          .animation({
            duration:1000,
            curve:item.curve,
            iterations:-1
          })
        })
      }
      .width("100%")
      .height(200)
      .onClick(()=>{
        this.angle=360
      })

    }
    .height('100%')
    .width('100%')
  }
}