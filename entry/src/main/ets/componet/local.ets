let localObj:Record<string,string>={
  "msg":"我是local中存储的信息"
}
export const local=new LocalStorage(localObj)

let tbMesObj:Record<string,string>={
  "icon1":"",
  "icon2":"/images/wang.png",
  "title":""
}
export const localTB=new LocalStorage(tbMesObj)
