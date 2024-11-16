import { ChatItemCom } from '../../componet/ChatItemCom'
import { chatClass} from '../../utils/ChatStore'
import { tbChatStore } from '../../utils/tbMesStore'
import { util } from '@kit.ArkTS'
import { http } from '@kit.NetworkKit'
import { contentClass } from '../../model/tbMessage'
import { router } from '@kit.ArkUI'

class ResponseClass{
  result:number=-1;
  content:string=""
}
@Entry()
@Component
struct TbChat {
  @StorageLink("aaa") aaa:contentClass|undefined=undefined
  @State chatList:chatClass[]=[]
  @State sendWord:string=""
  scroller:Scroller=new Scroller()
  //1.new出来
  store:tbChatStore=new tbChatStore(getContext(this))
  //统一数据
  async aboutToAppear(): Promise<void> {
    this.aaa!.count=0
    this.chatList=await this.store.getChat(this.aaa!.id)
    //一进去就在聊天框底部
    setTimeout(()=>{
      this.scroller.scrollEdge(Edge.Bottom)
    },50)
  }
  //2.发送方法（存发送内容，存回复内容）
  async sendMessageFn(){
    //存发送
    let sendObj:chatClass={
      content:this.sendWord,
      avatar:"/images/liu.png",
      id:util.generateRandomUUID(),
      selfFlag:true
    }
    this.chatList.push(sendObj)
    this.aaa!.lastText=this.sendWord
    this.aaa!.time=new Date().toLocaleTimeString()
    this.store.putChat(JSON.stringify(this.chatList),this.aaa!.id)
    this.scroller.scrollEdge(Edge.Bottom)
    //存接收
    const url="http://api.qingyunke.com/api.php?key=free&appid=0&msg="+this.sendWord
     this.sendWord=""
     const myHttp=http.createHttp()
    let res=await myHttp.request(url)
    let result= res.result as string
    let resDate=JSON.parse(result) as ResponseClass
    if (resDate.result==0){
      let content=resDate.content
      let conObj:chatClass={
        content:content,
        avatar:this.aaa!.icon,
        id:util.generateRandomUUID(),
        selfFlag:false//你是人机吗
      }
      if (!router.getParams()){
        this.aaa!.count!++
      }
      this.aaa!.time=new Date().toLocaleTimeString()
      this.aaa!.lastText=content
      //表面存
      this.chatList.push(conObj)
      //数据库存
      this.store.putChat(JSON.stringify(this.chatList),this.aaa!.id)
      //让List保持在底部
      this.scroller.scrollEdge(Edge.Bottom)
    }
  }
  //3.删除方法
  delItem(id:string){
    //表面删
    let chatL=[...this.chatList]
    let index=chatL.findIndex((v:chatClass)=>v.id==id);
    chatL.splice(index,1);
    this.chatList=[...chatL];
    //数据库删除
    this.store.putChat(JSON.stringify(this.chatList),this.aaa!.id)
  }
  build() {
    Column() {
    Row(){
      Row(){
        Text("<")
          .fontSize(20)
          .onClick(()=>{
            router.back()
          })
        Text(this.aaa?.title) .textAlign(TextAlign.Center).layoutWeight(1)
      }
        .height(50)
        .backgroundColor("#ccc")
      .padding({left:15})
        .width("100%")
    }
     //聊天人

      //内容区
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
      .height("calc(100% - 100vp)")
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

