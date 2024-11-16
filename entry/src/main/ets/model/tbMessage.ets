import { chatClass } from '../utils/ChatStore'
import { util } from '@kit.ArkTS'

export class topClass{
  icon1:string=""
  icon2:string=""
  text1:string=""
  text2:string=""
  text3:string=""
  color:string=""
  textColor:string=""
}

export class contentClass{
  count?:number=0
    id:string=""
    lastText?:string=""
   icon:string=""
   title:string=""
   chatList?:chatClass[]=[]
   time:string=""
}