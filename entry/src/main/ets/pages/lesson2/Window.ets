//window 窗口提供管理窗口的一些基础能力，包括对当前窗口的创建、销毁、各属性设置，以及对各窗口间的管理调度。
import { window } from '@kit.ArkUI'

/*
    1.导入模块
    2.使用getLastWindow() createWindow() findWindow()中的任一方法获取到Window实例（windowClass）
    3.调用对应方法
 */
@Entry
@Component
struct Window {
  @State winClass:window.Window|undefined=undefined
async aboutToAppear(): Promise<void> {
    //获取window实例
  this.winClass=await window.getLastWindow(getContext(this))
//方法5  keyboardHeightChange 固定态软键盘高度变化的监听
  this.winClass.on("keyboardHeightChange",()=>{
    console.log("软件盘收起或展开")
  })
}

  build() {
    Column({space:10}) {
      TextInput({
        text:""
      })
//方法1  getWindowProperties 获取当前窗口的属性，返回WindowProperties。
      Button("获取当前窗口窗口 getWindowProperties")
        .onClick(async ()=>{
            let winProp:window.WindowProperties=await this.winClass!.getWindowProperties()
            AlertDialog.show({
              message:JSON.stringify(winProp)
            })
        })
//方法2  getWindowAvoidArea  获取窗口内容规避的区域；如系统栏区域、刘海屏区域、手势区域、软键盘区域等与窗口内容重叠时，需要窗口内容避让的区域。
      Button("获内容规避区域 getWindowProperties")
        .onClick(async ()=>{
          let winAvoid:window.AvoidArea=await this.winClass!.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM)
          AlertDialog.show({
            message:JSON.stringify(winAvoid)
          })
        })
//方法3   setWindowLayoutFullScreen 布局是否为沉浸式布局（全屏）顶上去
      Button("是否全屏")
        .onClick(async ()=>{
           await this.winClass!.setWindowLayoutFullScreen(true)
          AlertDialog.show({
            message:"设置沉浸式窗口"
          })
        })
//方法4 setWindowSystemBarEnable 设置窗口全屏模式时导航栏、状态栏的可见模式，使用Promise异步回调。
      Button("设置全屏模式时候导航栏，状态栏可见模式")
        .onClick(async ()=>{
          await this.winClass?.setWindowSystemBarEnable(["navigation"])
        })
//方法5 setPreferredOrientation 设置屏幕方向
      Button("设置屏幕方向-横屏")
        .onClick(async ()=>{
          await this.winClass?.setPreferredOrientation(window.Orientation.LANDSCAPE)

        })
    }
    .backgroundColor(Color.Pink)
    .height('100%')
    .width('100%')
  }
}