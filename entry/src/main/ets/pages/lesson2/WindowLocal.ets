import { window } from '@kit.ArkUI'
import { local } from '../../componet/local'
import { image } from '@kit.ImageKit';

@Entry(local)
@Component
struct WindowLocal {
  @State img:image.PixelMap | undefined=undefined;
 @State windowClass:window.Window|undefined=undefined
  async aboutToAppear(): Promise<void> {
      this.windowClass=await window.getLastWindow(getContext(this))
//方法13 on('screenshot')   开启截屏事件的监听
      this.windowClass.on("screenshot",()=>{
        AlertDialog.show({
          message:"截屏了"
        })
      })
  }

  build() {
    Column() {
//方法9  loadContent  跳转窗口，可携带参数
       Button("loadContent 跳转窗口")
         .onClick(async ()=>{
             local.setOrCreate("msg","我是新改变之后的")//这样也可以，不用写LocalStorageLink
           await this.windowClass?.loadContent("pages/lesson2/WindowNewWindow" ,local)
//方法10   setWindowBackgroundColor设置窗口背景色
           this.windowClass?.setWindowBackgroundColor("#f0f0f0")
         })
//方法11  setWindowPrivacyMode  设置窗口是否为隐私模式 窗口内容将无法被截屏或录屏 + try catch(和async awiait配合使用)
      Button("隐私模式")
        .onClick(async ()=>{
          try {
            await this.windowClass?.setWindowPrivacyMode(true)
            AlertDialog.show({
              message:"成功"
            })
          }catch (e){
            AlertDialog.show({
              message:JSON.stringify(e)
            })
          }
        })
//方法12 snapshot 获取截屏
      Button("snapshot 获取截屏")
        .onClick(async ()=>{
          this.img= await this.windowClass?.snapshot()
        })
      Image(this.img!)
        .width(200)
    }
    .height('100%')
    .width('100%')
  }
}