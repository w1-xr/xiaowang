//安全区域（页面可以显示在哪）
import { KeyboardAvoidMode,window } from '@kit.ArkUI'

//默认摄像头挖孔区域不为非安全区域，页面不避让挖孔。可在module.json5中添加配置项, 摄像头挖孔区域视为非安全区，实现页面默认避让挖孔
// "metadata": [
// {
//   "name": "avoid_cutout",
// "value": "true",
// }
// ],

/*
  1.expandSafeArea   控制组件扩展其安全区域
    expandSafeArea(types?: Array<SafeAreaType>, edges?: Array<SafeAreaEdge>)
        types:(非必填，配置扩展安全区域的类型。未添加metadata配置项时，页面不避让挖孔)
             1.SYSTEM系统默认非安全区域，包括状态栏、导航栏。
             2.CUTOUT设备的非安全区域，例如刘海屏或挖孔屏区域。
             3.KEYBOARD软键盘区域。
         edges:（非必填，配置扩展安全区域的方向）
             TOP上方区域。 BOTTOM下方区域。 START前部区域。 END尾部区域
*/
//1.1 利用安全区域使内容区占满整个屏幕
// @Entry
// @Component
// struct Safe {
//   build() {
//     Column() {
//       Row(){
//
//       }
//       .height("100%")
//       .width("100%")
//       .backgroundColor(Color.Pink)
//     }
//     .height('100%')
//     .width('100%')
//     .backgroundColor(Color.Red)
//     .expandSafeArea([SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
//   }
// }

//1.2  软键盘弹出时固定底部背景
// @Entry
// @Component
// struct Safe {
//   build() {
//     Stack({
//       alignContent:Alignment.Bottom
//     }) {
//       Column(){
//
//       }
//       .height("100%")
//       .width("100%")
//       .backgroundImage("/images/liu.png")
//       .backgroundImageSize(ImageSize.Cover)
//       .expandSafeArea([SafeAreaType.KEYBOARD,SafeAreaType.SYSTEM])
//
//       TextInput()
//     }
//     .height('100%')
//     .width('100%')
//     .backgroundColor(Color.Red)
//   }
// }
//1.3 软键盘弹出时，固定顶部导航
// @Entry
// @Component
// struct Safe{
//   //1.一进来沾满整个屏幕（要不软键盘一上来，内容区间黄色就出去了）
//   async aboutToAppear() {
//     let windowClass=await window.getLastWindow(getContext(this))
//     windowClass.setWindowLayoutFullScreen(true)
//   }
//
//   @State arr:string[]=Array.from(new Array(10),(v:string,index:number)=>index+"")
//   build() {
//     Column() {
//       Text("老王")
//         .width("100%")
//         .height(100)
//         .backgroundColor("#ccc")
//         .expandSafeArea([SafeAreaType.KEYBOARD]) //允许老王在键盘弹出时候时仍然显示
//         .zIndex(100)
//
//       List(){
//         ForEach(this.arr,(item:string)=>{
//           ListItem(){
//             Text(item)
//           }
//           .width("100%")
//           .height(150)
//           .border({
//             width:1
//           })
//         })
//       }
//       .width("100%")
//       .backgroundColor(Color.Orange)
//       .layoutWeight(1)
//
//       Row(){
//         TextInput()
//           .layoutWeight(1)
//         Button("发送:")
//       }
//       .width("100%")
//       .height(50)
//       .backgroundColor("#fff")
//     }
//     .backgroundColor(Color.Pink)
//     .width('100%')
//     .height("100%")
//     // .expandSafeArea([SafeAreaType.KEYBOARD,SafeAreaType.SYSTEM],[SafeAreaEdge.TOP,SafeAreaEdge.BOTTOM])
//   }
// }

/*2. setKeyboardAvoidMode 控制键盘抬起时页面的避让模式
  getKeyboardAvoidMode  返回键盘抬起时的页面避让模式
      | OFFSET | 上抬模式。 |
      | RESIZE | 压缩模式   |
 */
//原来页面什么比例,软键盘抬起后还是什么比例`
@Entry
@Component
struct Safe{
  async aboutToAppear() {
    const windowClass:window.Window=await window.getLastWindow(getContext(this))
    windowClass.getUIContext().setKeyboardAvoidMode(KeyboardAvoidMode.RESIZE)
  }
  build() {
    Column({
      space:20
    }){

      TextInput()
      TextInput()
    }
    .height("100%")
    .width("100%")
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}