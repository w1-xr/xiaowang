import { chatClass, chatStore } from '../../utils/ChatStore'
import { util } from '@kit.ArkTS'
import { http } from '@kit.NetworkKit'

class ResponseClass{
  result:number=-1;
  content:string=""
}
@Entry
@Component
struct Chat {
  @State chatList:chatClass[]=[]//内容区数组
  @State sendWord:string=""//我发送的信息
  scroller:Scroller=new Scroller()

  //1.utils中定义
  //2.new出来
  store:chatStore=new chatStore(getContext(this))
  //3.初始化统一赋值
  async aboutToAppear() {
    this.chatList=await this.store.getChat();
    setTimeout(()=>{//每次一进去就在聊天底部
      this.scroller.scrollEdge(Edge.Bottom);
    },50)
  }
  //4.执行发送，回复就更新数组的方法
  async sendMessageFn(){
    //3.1发送的消息
     let sendObj:chatClass={
       content:this.sendWord,
       avatar:"/images/wang.png",
       id:util.generateRandomUUID(),
       selfFlag:true
     }
     //表面存
     this.chatList.push(sendObj)
    //数据库存
    this.store.putChat(JSON.stringify(this.chatList))
    //让List保持在底部
    this.scroller.scrollEdge(Edge.Bottom)

    //3.2回复的消息
    const url="http://api.qingyunke.com/api.php?key=free&appid=0&msg="+this.sendWord
    this.sendWord=""
    const myHttp=http.createHttp()
    let res=await myHttp.request(url)
    let result=res.result as string
    let resData=JSON.parse(result) as ResponseClass
    //console.info(result)
    if (resData.result==0){
      let content=resData.content//回复的内容
      let conObj:chatClass={
        content:content,
        avatar:"/images/liu.png",
        id:util.generateRandomUUID(),
        selfFlag:false
      }
      //表面存
      this.chatList.push(conObj)
      //数据库存
      this.store.putChat(JSON.stringify(this.chatList))
      //让List保持在底部
      this.scroller.scrollEdge(Edge.Bottom)
    }
  }
  //5.删除方法
  delItem(id:string){
    //表面删
    let chatL=[...this.chatList]
    let index=chatL.findIndex((v:chatClass)=>v.id==id);
    chatL.splice(index,1);
    this.chatList=[...chatL];
    //数据库删除
    this.store.putChat(JSON.stringify(this.chatList))
  }


  build() {
    Column() {
      //1.上：聊天人
      Text("哆啦A梦")
        .height(50)
        .backgroundColor("#ccc")
        .textAlign(TextAlign.Center)
        .width("100%")
      //2.内容区
      List({
          scroller:this.scroller
      }){
        ForEach(this.chatList,(item:chatClass)=>{
          ListItem(){
            ChatItemCom({
              item:item,
              delFn:()=>{this.delItem(item.id)}
            })
          }
        })
      }
      .width("100%")
      .height('calc(100% - 100vp)')
      .onAppear(()=>{
        this.scroller.scrollEdge(Edge.Bottom);
      })
      //3.输入区
      Row(){
        TextInput({
          text:$$this.sendWord
        })
          .layoutWeight(1)
          .onSubmit(()=>{
            //this.sendMessageFn()
          })
        Button("发送")
          .onClick(()=>{
            this.sendMessageFn()
          })
      }
      .height(50)
    }
    .height('100%')
    .width('100%')
  }
}


@Component
struct ChatItemCom{
  @Prop item:chatClass;
  @State showPop:boolean=false;
  delFn:(id:string)=>void = ()=>"";
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