import { contentData } from '../../data/taMessage'
import { contentClass, topClass } from '../../model/tbMessage'
import { router } from '@kit.ArkUI'
import { tbChatStore } from '../../utils/tbMesStore'

PersistentStorage.persistProp<contentClass[]>('contentData', contentData)
@Entry
@Component
struct TbMessage {
  @State countTotal: number = 0
  @StorageLink('contentData') contentArr:contentClass[] = []
  @State searchText:string=""
  store:tbChatStore=new tbChatStore(getContext(this))
  @StorageProp("aaa")@Watch("countChange") aaa:contentClass|undefined=undefined
  countChange(){
      let index=this.contentArr.findIndex((v:contentClass)=>v.id==this.aaa?.id)
     if(index!=-1){
       this.contentArr.splice(index,1,this.aaa!)
     }
  }
  @Builder top($$:topClass){
    Row(){
      Column(){
        Row(){
          Image($$.icon1)
            .width(15)
          Text($$.text1)
            .fontColor($$.textColor)
            .fontWeight(500)
            .margin({right:5})
          Text(">")
        }
        Text($$.text2)
          .margin({top:5,bottom:5})
          .fontSize(14)
        Text($$.text3)
          .fontColor(Color.Gray)
          .fontSize(14)
          .width(105)
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
      }
      .alignItems(HorizontalAlign.Start)
      Image($$.icon2)
        .width(40)
    }
    .margin({right:10})
   .borderRadius(10)
    .backgroundColor($$.color)
    .padding(8)
  }
  build() {
    Stack({alignContent:Alignment.TopStart}) {
      //顶部
      Column(){
        Row(){
          Text("消息")
            .fontSize(20)
            .fontWeight(700)
          Text("("+this.countTotal+")")
          Search({
            placeholder:"搜索聊天记录",
            value:$$this.searchText
          })
            .margin({left:10,right:10})
            .layoutWeight(1)
          Image("/images/clear.png")
            .width(23)
          Image("/images/add.png")
            .width(20)
            .margin({left:10})
        }.margin({bottom:20})
        Row(){
          this.top({icon1:"/images/wuliu.png",icon2:"/images/wuliu2.png",text1:"交易物流",text2:"宝贝正在运输中",text3:"已到达河北石家庄",textColor:"#5595d6",color:"#e7f4fd"})
          this.top({icon1:"/images/tixing.png",icon2:"/images/tixing2.png",text1:"服务提醒",text2:"主播开播了",text3:"斯凯奇舒适盟主",textColor:"#ec955a",color:"#fef8ec"})
        }
        .justifyContent(FlexAlign.SpaceBetween)
      }
      //中间
      List(){
        ForEach(this.contentArr,(item:contentClass)=>{
          ListItem(){

            Row(){
              Image(item.icon)
                .width(40)
              Column(){
                Row(){
                  Text(item.title)
                    .fontSize(18)
                  Blank()
                  Text(item.time)
                    .fontSize(14)
                    .fontColor(Color.Gray)
                }
                .width("100%")
                Badge({
                  count:item.count!,
                  style:{
                    color:Color.White,
                    badgeColor:Color.Red
                  },
                }){
                  Text(item.lastText)
                    .width("98%")
                    .fontColor(Color.Gray)
                    .margin({top:5})
                    .fontSize(14)
                }
                }
              .alignItems(HorizontalAlign.Start)
              .padding({left:10})
              .layoutWeight(1)
            }
            .width("100%")
            .height(70)
          }
          .onClick(()=>{
              AppStorage.setOrCreate<contentClass>("aaa",item)
            router.pushUrl({
              url:"pages/work/tbChat",
              params:{
                "status":"itemPage"
              }
            })
          })
          .margin({bottom:5})
          .width("100%")
        })
      }
      .edgeEffect(EdgeEffect.Fade)
      .listDirection(Axis.Vertical)
      .position({top:140,left:3})
    }
    .padding(15)
    .height('100%')
    .width('100%')
  }
}