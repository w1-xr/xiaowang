//window.createWindow（） 创建子窗口
import { window } from '@kit.ArkUI';

@Entry
@Component
struct WindowOn {
  @State message: string = 'Hello World';

  build() {
    Column() {
//方法6 createWindow（）
        Button("创建子窗口")
          .onClick(async ()=>{
            let config:window.Configuration={
              name:"newWindow",
              windowType:window.WindowType.TYPE_DIALOG,
              ctx:getContext(this),
              parentId:0//一般默认是0
            }
            //1.调用这个方法
            const newWindowClass:window.Window=await window.createWindow(config)
//方法7  windowSizeChange 窗口尺寸改变触发回调
            newWindowClass.on("windowSizeChange",()=>{
              AlertDialog.show({
                message:"窗口尺寸改变了"
              })
            })
            //2.设置新窗口的宽高
            await newWindowClass.resize(300,400)
            //3.窗口在哪个page里
//方法8  setUIContent 跳转窗口，不携带参数
            await newWindowClass.setUIContent("pages/lesson2/WindowNewWindow")
            //4.展示窗口
            await newWindowClass.showWindow()
          })
    }
    .height('100%')
    .width('100%')
  }
}