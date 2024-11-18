import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { startStore } from '../utils/startStore';
import { AdvertClass, advertStore } from '../utils/advertStore';

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
  }
 // async  onWindowStageCreate(windowStage: window.WindowStage): Promise<void> {
 //    // Main window is created, set main page for this ability
 //    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
 //    //如果起始页存储的
 //   const sStore=new startStore(this.context)
 //   const sD=await sStore.getMes()
 //   if(sD!="started"){
 //     windowStage.loadContent('pages/lesson1/Lunbo', (err) => {
 //       if (err.code) {
 //         hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
 //         return;
 //       }
 //       hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
 //     });
 //   }else {
 //     //调用广告接口
 //     let adData:AdvertClass={
 //       showAd:true,
 //       adTimeL:6,
 //       adImg:"/images/wang.png"
 //     }
 //     const store=new advertStore(this.context)
 //     //存
 //     await store.putAdvert(JSON.stringify(adData))
 //     windowStage.loadContent('pages/lesson1/ShouYe', (err) => {
 //       if (err.code) {
 //         hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
 //         return;
 //       }
 //       hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
 //     });
 //   }
 //
 //  }
    onWindowStageCreate(windowStage: window.WindowStage): void {
    // Main window is created, set main page for this ability
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
      windowStage.loadContent('pages/lesson3/zhiboJian', (err) => {
        if (err.code) {
          hilog.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err) ?? '');
          return;
        }
        hilog.info(0x0000, 'testTag', 'Succeeded in loading the content.');
      });

  }
  onWindowStageDestroy(): void {
    // Main window is destroyed, release UI related resources
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    // Ability has brought to foreground
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    // Ability has back to background
    hilog.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');

  }
}
