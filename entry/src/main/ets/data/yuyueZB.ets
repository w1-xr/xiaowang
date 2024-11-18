@Observed
export class GridDataClass{
  icon:string
  title:string

  constructor(icon: string, title: string, date: string, timeH: number, timeM: number, yuyue: boolean) {
    this.icon = icon
    this.title = title
    this.date = date
    this.timeH = timeH
    this.timeM = timeM
    this.yuyue = yuyue
  }
  date:string
  timeH:number
  timeM:number
  yuyue:boolean
}
export const  GridData:GridDataClass[]=[
  new GridDataClass("/images/zb1.png","所有女生","11.18",10,20,false),
  new GridDataClass("/images/zb2.png","兰儿er","11.18",10,20,false),
  new GridDataClass("/images/zb3.png","南风Cheney","11.18",10,20,false),
  new GridDataClass("/images/zb4.png","美潮美甲教学","11.18",10,20,false),
]


//底部
export class bottomClass{
  icon:string=""
  title:string=""
}
export const  bottomData:bottomClass[]=[
  {
    icon:"/images/zb5.png",
    title:"首页"
  },
  {
    icon:"/images/zb6.png",
    title:"直播好价"
  },
  {
    icon:"/images/zb7.png",
    title:"活动日历"
  },
  {
    icon:"/images/zb8.png",
    title:"我的"
  },
]
