/*
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2022 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { HRComponent } from '../../HippyRenderView'
import { NativeRenderContext } from '../../NativeRenderContext'
import { HRGestureDispatcher } from '../../uimanager/HRGestureDispatcher'
import { HREventType, HREventUtils } from '../../utils/HREventUtils'
import HippyRenderBaseView, { HippyObservedArray } from '../base/HippyRenderBaseView'
import { LogUtils } from '../../../support/utils/LogUtils'
import { HippyAny, HippyRenderCallback } from '../../../support/common/HippyTypes';
const TAG: string = "HRModal";

@Observed
export class HRModalView extends HippyRenderBaseView {
  static readonly VIEW_NAME = "HRModalView"

  animationType: string | null = null
  transparent: boolean = true
  supportedOrientations: string | null = null
  immersionStatusBar: boolean = false;
  darkStatusBarText: boolean = false;

  handleClose() {
    HRGestureDispatcher.handleClickEvent(this.ctx, this.tag, HREventUtils.EVENT_MODAL_REQUEST_CLOSE)
  }

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }
  setProp(propKey: string, propValue: HippyAny | HippyRenderCallback): boolean {
    LogUtils.i(TAG, `modalview propkey: ${propKey}, value: ${propValue}`)
    switch (propKey) {
      case "transparent":
        this.transparent = propValue as boolean;
        break;
      case "immersionStatusBar":
        this.immersionStatusBar = propValue as boolean;
        break;
      case "supportedOrientations":
        this.supportedOrientations = propValue as string;
        break;
      case "animationType":
        this.animationType = propValue as string;
        break;
      case "darkStatusBarText":
        this.darkStatusBarText = propValue as boolean;
        break;
      default:
        break
    }
    return super.setProp(propKey, propValue)
  }
}

@CustomDialog
struct HippyDialog {
  controller: CustomDialogController
  @ObjectLink renderView: HRModalView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>
  @BuilderParam buildRenderView: ($$: HippyRenderBaseView, parent: HRComponent) => void

  build() {
    Stack() {
      ForEach(this.children, (item: HippyRenderBaseView) => {
        this.buildRenderView(item, null)
      }, (item: HippyRenderBaseView) => item.tag + '')
    }
    .opacity(this.renderView.transparent == true ? 0.4 : 1)
    .size({width:this.renderView.cssWidth, height: this.renderView.cssHeight})
    .backgroundColor(0x55ffffff).backdropBlur(5)
    .onClick((e:ClickEvent) => {
      LogUtils.i(TAG, `HRModal cssWidth: ${this.renderView.cssWidth}, cssHeight: ${this.renderView.cssHeight}`);
      this.renderView.handleClose()
    })

  }
}

@Component
export struct HRModal {
  @ObjectLink renderView: HRModalView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>
  @BuilderParam buildRenderView: ($$: HippyRenderBaseView, parent: HRComponent) => void
  private dialogController: CustomDialogController = {} as CustomDialogController
  handleCancel(): void {
    HRGestureDispatcher.handleClickEvent(this.renderView.ctx, this.renderView.tag, HREventUtils.EVENT_MODAL_REQUEST_CLOSE)
  }
  aboutToAppear() {
    this.dialogController = new CustomDialogController({
      builder: HippyDialog({
        renderView: this.renderView,
        children: this.children,
        buildRenderView: this.buildRenderView
      }),
      autoCancel: true,
      customStyle: true,
      alignment: DialogAlignment.Center,
      openAnimation: { duration: 0 },
      closeAnimation: { duration: 0 },
      cancel: this.handleCancel,
    });
    this.dialogController.open();
    HRGestureDispatcher.handleClickEvent(this.renderView.ctx, this.renderView.tag, HREventUtils.EVENT_MODAL_SHOW)

  }

  aboutToDisappear() {
    this.dialogController.close()
  }

  build() {

  }
}