import { local } from '../../componet/local';

@Entry(local)
@Component
struct WindowNewWindow {
  @State message: string = '我是新窗口';
 @LocalStorageLink("msg") msg:string="初始值"
  build() {
    RelativeContainer() {
      Text(this.msg)
      Text(this.message)
        .id('WindowNewWindowHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .backgroundColor(Color.Pink)
    .height('100%')
    .width('100%')
  }
}