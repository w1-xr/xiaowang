import dataPreferences from '@ohos.data.preferences';
//getContext(this)在pages页里面使用，this.content在EntryAbiliby中使用
//getContext(this)模式
//定义
export class testStore{
  //1.getStore方法
  async getScore(){
    return await dataPreferences.getPreferences(getContext(this),"my_mesSql")
  }
  //2.存
  async putMes(data:string){
    const store=await this.getScore()
    await store.put("myMes",data)
    await store.flush()
  }
  //3.取
  async getMes(){
    const store=await this.getScore()
    let data=await store.get("myMes","")
    return data as string
  }

}