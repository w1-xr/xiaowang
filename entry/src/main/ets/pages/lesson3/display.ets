//display屏幕属性
import display from '@ohos.display';
@Entry
@Component
struct Display {
 //1.初始化定义
  @State disPlayClass:display.Display|undefined=undefined

  aboutToAppear(): void {
    //2.获取实例对象
    this.disPlayClass=display.getDefaultDisplaySync()
  }

  build() {
    Column() {
//1.获取相关属性
      Button("获取相关属性")
        .onClick(async ()=>{
          AlertDialog.show({
            message:JSON.stringify(this.disPlayClass)
          })
        })
//2.getCutoutInfo 获取获取挖孔屏、刘海屏、瀑布屏等不可用屏幕区域信息。使用Promise异步回调。建议应用布局规避该区域
      Button("getCutoutInfo")
        .onClick(async ()=>{
          let cutInfo:display.CutoutInfo=await this.disPlayClass!.getCutoutInfo()
          let liuHaiRect=cutInfo.boundingRects
          AlertDialog.show({
            message:JSON.stringify(cutInfo)
          })
        })
//3.display.getFoldStatus 获取可折叠设备的当前折叠状态。
      Button("获取折叠状态")
        .onClick( async ()=>{
          let foldStatus:display.FoldStatus= display.getFoldStatus()
          AlertDialog.show({
            message:JSON.stringify(foldStatus)
          })
        })
//4.display.isFoldable 检查设备是否可折叠
      Button("查看是否可折叠")
        .onClick( ()=>{
         let Foldable:boolean=display.isFoldable()
          AlertDialog.show({
            message:Foldable+""
          })
        })
//5.display.getFoldDisplayMode 获取可折叠设备的显示模式（主屏幕/子屏幕。。。）
      Button("getFoldDisplayMode")
        .onClick(async ()=>{
          let FoldCreaseRegion=await display.getCurrentFoldCreaseRegion()
          AlertDialog.show({
            message:JSON.stringify(FoldCreaseRegion)
          })
        })
    }
    .height('100%')
    .width('100%')
  }
}