@Component
struct item{
  @Prop title:string
  @Link content:string
  @Prop icon:string
  @Link Vib:Visibility
  @Link weekVib:Visibility

  build() {
      Row(){
        Text(this.title)
          .fontColor(Color.White)
          .fontWeight(800)
          .fontSize(18)
        TextInput({
          text:$$this.content
        })
          .fontSize(13)
          .direction(Direction.Rtl)
          .layoutWeight(1)
          .backgroundColor(Color.Transparent)
          .fontColor(Color.White)
        Image(this.icon)
          .width(20)
          .onClick(()=>{
              this.Vib=Visibility.None
              this.weekVib=Visibility.Visible
          })
      }
      .border({
        width:{
          bottom:1
        },
        color:"#474747"
      })
      .padding(10)
      .justifyContent(FlexAlign.SpaceBetween)
      .height(50)
      .width("100%")

  }
}
export {item}