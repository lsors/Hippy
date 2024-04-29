/*
 *
 * Tencent is pleased to support the open source community by making
 * Hippy available.
 *
 * Copyright (C) 2019 THL A29 Limited, a Tencent company.
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#include "renderer/arkui/arkui_node.h"

namespace hippy {
inline namespace render {
inline namespace native {

ArkUINode::ArkUINode(ArkUI_NodeHandle nodeHandle) : node_handle_(nodeHandle) {
  
}

ArkUINode::~ArkUINode() {
  if (node_handle_ != nullptr) {
  }
}

ArkUINode::ArkUINode(ArkUINode &&other) noexcept : node_handle_(std::move(other.node_handle_)) {
  other.node_handle_ = nullptr;
}

ArkUINode &ArkUINode::operator=(ArkUINode &&other) noexcept {
  std::swap(node_handle_, other.node_handle_);
  return *this;
}

ArkUI_NodeHandle ArkUINode::GetArkUINodeHandle() { return node_handle_; }

void ArkUINode::OnNodeEvent(ArkUI_NodeEvent *event) {}

void ArkUINode::MarkDirty() {

}

ArkUINode &ArkUINode::SetPosition() {

  return *this;
}

ArkUINode &ArkUINode::SetSize() {

  return *this;
}

} // namespace native
} // namespace render
} // namespace hippy
