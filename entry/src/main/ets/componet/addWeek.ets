import { alarmClass } from '../utils/alarmStore';

 export class WeekClass{
  weekTitle:string="";
  value:number=0;
  selected:boolean=false;
}
@Component
struct addWeek{

  @Link weekVib:Visibility
  @Link Vib:Visibility
  @Link myWeeks:WeekClass[]
  @Link daysOfWeek:number[]
  build() {

      Column(){
        Row(){
          Image("/images/lback.png")
            .width(17)
            .onClick(()=>{
               this.Vib=Visibility.Visible
              this.weekVib=Visibility.None
            })
          Text("重复")
            .fontColor(Color.White)
            .margin({left:10})
        }
        .width("100%")
        // Text(JSON.stringify(this.myWeeks))
        // Text(JSON.stringify(this.daysOfWeek))
        Column(){
          ForEach(this.myWeeks,(wItem:WeekClass,index:number)=>{
            Row(){
              Text(wItem.weekTitle)
                .layoutWeight(1)
                .fontColor(Color.White)
              Toggle({
                type:ToggleType.Checkbox,
                isOn:wItem.selected
              })
                .width(20)
                .onChange((isOn:boolean)=>{
                  let copyWeeks=[...this.myWeeks];
                  copyWeeks[index].selected=isOn;
                  this.myWeeks=[...copyWeeks]
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
          })
        }
        .margin({top:50})
        .borderRadius(10)
        .width("100%")
        .height(350)
        .backgroundColor("#2c2c2c")

      }
      .padding(20)
      .width("100%")
      .height("100%")
      .backgroundColor(Color.Black)
      .visibility(this.weekVib)
    }
}
export {addWeek}