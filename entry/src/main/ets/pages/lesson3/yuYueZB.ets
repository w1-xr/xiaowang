import { item } from '../../componet/item'
import { BottomNavBar, grigDataNavBar } from '../../componet/yuyueZB'
import { GridData } from '../../data/yuyueZB'
import { GridDataClass } from '../../data/yuyueZB'
@Extend(Text) function globalTextStyle(){
  .fontColor("#5a87ec")
  .fontSize(14)
}
@Entry
@Component
struct YuYueZB {
  @State searchValue:string=""
  @State curIndex:number=-1
  @State GridData:GridDataClass[]=GridData
 async  onPageShow(): Promise<void> {

  }
  build() {
  Column(){
       //1.头部
        Row(){
          Image("/images/lback.png")
            .width(20)
          Text("关注")
            .fontWeight(800)
            .fontSize(22)
            .margin({left:10,right:10})
          Text("发现")
            .fontSize(19)
          Text("蜜蜂家居")
            .fontSize(19)
            .margin({left:10,right:10})
            Search({
              placeholder:"金蘑菇菇",
              value:$$this.searchValue
            })
              .layoutWeight(1)
        }
      //2.中间
       Row(){
          Row(){
            Image("/images/hongbao.png")
              .width(15)
            Text("4000元红包发放中>")
              .fontColor(Color.Red)
              .fontSize(14)
          }
          Text("11:17:16:15开播")
            .fontColor("#5a87ec")
            .fontSize(13)
         Text("预约>")
           .fontColor("#3361a0")
           .fontWeight(800)

           .fontSize(14)
       }
       .width("100%")
       .justifyContent(FlexAlign.SpaceBetween)
      Grid(){
           ForEach(this.GridData,(item:GridDataClass,index:number)=>{
             grigDataNavBar({
               item:item
             })
           })
      }
      .margin({top:15})
      .columnsTemplate("1fr 1fr")
    .columnsGap(10)
    .rowsGap(10)
      //3.底部导航
    BottomNavBar()
    }
    .padding(10)
    .height('100%')
    .width('100%')
  }
}