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
import { HippyAny, HippyRenderCallback } from '../../../support/common/HippyTypes'
import { HRComponent } from '../../HippyRenderView'
import { NativeRenderContext } from '../../NativeRenderContext'
import { HRRect } from '../../utils/HRTypes'
import HippyRenderBaseView, { HippyObservedArray } from '../base/HippyRenderBaseView'
import { LogUtils } from '../../../support/utils/LogUtils';

@Observed
export class HRListItemView extends HippyRenderBaseView {
  private readonly TAG = "HRListItemView"

  constructor(ctx: NativeRenderContext) {
    super(ctx)
  }

  setProp(propKey: string, propValue: HippyAny | HippyRenderCallback): boolean {
    return super.setProp(propKey, propValue as HippyAny)
  }

  protected updateRenderViewFrame(frame: HRRect): void {
    this.cssPositionX = 0
    this.cssPositionY = 0
    this.cssWidth = frame.width
    this.cssHeight = frame.height
  }
}

@Component
export struct HRListItem {
  @ObjectLink renderView: HRListItemView
  @ObjectLink children: HippyObservedArray<HippyRenderBaseView>
  @BuilderParam buildRenderView:($$: HippyRenderBaseView, parent: HRComponent) => void

  build() {
    Stack() {
      ForEach(this.children, (item: HippyRenderBaseView) => {
        this.buildRenderView(item, null)
      }, (item: HippyRenderBaseView) => item.tag + '')
    }
    .applyRenderViewBaseAttr(this.renderView)
  }
}

// base props for all components
@Extend(Stack)
function applyRenderViewBaseAttr($$: HippyRenderBaseView) {
  .backgroundColor($$.cssBackgroundColor)
  .position({x: $$.cssPositionX, y: $$.cssPositionY})
  .size({width:$$.cssWidth, height: $$.cssHeight})
  .opacity($$.cssOpacity)
  .clip($$.cssOverflow)
  .visibility(($$ as HippyRenderBaseView).cssVisibility) // must add as, otherwise the compiler has error
  .zIndex($$.cssZIndex)
  .border($$.cssBorder)
  .borderWidth(1) // TODO:
  .rotate($$.cssRotate)
  .scale($$.cssScale)
  .translate($$.cssTranslate)
  .onClick($$.eventClick)
}