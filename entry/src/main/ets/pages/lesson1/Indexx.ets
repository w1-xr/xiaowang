//数据管理-用户首选项
import { testStore } from '../../utils/testStore';
import { router } from '@kit.ArkUI';

//1.utils中定义
@Entry
@Component
struct Indexx{
  @State message: string = '你好我要存储1';
  //2.new
  store:testStore=new testStore()
  //3.初始化相等
  async aboutToAppear() {
    this.message=await this.store.getMes()
  }

  build() {
    Column() {
      //1.显示初始值
      Text("mes:"+this.message)
      //2.点击按钮存储新的值
      Button("点击存储")
        .onClick(async ()=>{
          await this.store.putMes("你好，我是存储之后的2")//点击按钮，将新的mes存储到store中
          this.message=await this.store.getMes()//更新mes状态为新的消息
        })
      //3.获取当前的mes
      Button("获取")
        .onClick(async ()=>{
          AlertDialog.show({
            message:await this.store.getMes()
          })
        })
      //4.跳转
      Button("关于")
        .onClick(()=>{
          router.pushUrl({
            url:"pages/AboutPage"
          })
        })

    }
    .height('100%')
    .width('100%')
  }
}