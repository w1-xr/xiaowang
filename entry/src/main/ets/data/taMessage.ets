import { contentClass } from '../model/tbMessage'
import { util } from '@kit.ArkTS'

export const contentData:contentClass[]=[
  {
    id:util.generateRandomUUID(),
    count:0,
    icon:"/images/tncs.png",
    title:"天猫超市",
    chatList:[],
    time:""
  },
  {
    count:0,
    id:util.generateRandomUUID(),
    icon:"/images/emxee.png",
    title:"EMXEE謾熙官方旗舰店",
    chatList:[],
    time:""
  },
  {
    count:0,
    id:util.generateRandomUUID(),
    icon:"/images/88.png",
    title:"88VIP权益助手",
    chatList:[],
    time:""
  },
  {
    count:0,
    id:util.generateRandomUUID(),
    icon:"/images/lgj.png",
    title:"老管家旗舰店",
    chatList:[],
    time:""
  },
  {
    count:0,
    id:util.generateRandomUUID(),
    icon:"/images/dl.png",
    title:"东菱厨房电器旗舰店",
    chatList:[],
    time:""
  },

]