import { bottomClass, bottomData, GridData, GridDataClass } from '../data/yuyueZB'
@Extend(Text) function globalTextStyle(){
  .fontColor("#5a87ec")
  .fontSize(14)
}
@Component
struct BottomNavBar{
  bottomData:bottomClass[]=bottomData
  build() {
    Row(){
      ForEach(bottomData,(item:bottomClass,index:number)=>{
        Column(){
          Image(item.icon)
            .width(30)
          Text(item.title)
            .margin({top:5})
            .fontColor(index==0?Color.Red:Color.Black)
            .fontSize(14)
        }
      })
    }
    .backgroundColor("#f6f6f6")
    .position({bottom:0,left:5})
    .width("100%")
    .height(50)
    .justifyContent(FlexAlign.SpaceAround)
  }
}
export {BottomNavBar}

@Component
struct grigDataNavBar{
@ObjectLink  item:GridDataClass

  build() {
        GridItem(){
          Column(){
            Image(this.item.icon)
              .width(160)
            Text(this.item.title)
              .fontWeight(800)
              .margin({top:10,bottom:8})
            Row(){
              Row(){
                Text(this.item.date)
                  .globalTextStyle()
                Text(this.item.timeH+"")
                  .globalTextStyle()
                Text(":")
                  .globalTextStyle()
                Text(this.item.timeM+"")
                  .globalTextStyle()
                Text("开播")
                  .globalTextStyle()
              }
              Text(this.item.yuyue?"已预约":"预约>")
                .fontColor("#3361a0")
                .fontWeight(800)
                .fontSize(14)
                .onClick(()=>{
                  this.item.yuyue = !this.item.yuyue
                })
            }
            .width("100%" )
            .justifyContent(FlexAlign.SpaceBetween)

          }
          .alignItems(HorizontalAlign.Start)
        }

  }
}
export {grigDataNavBar}