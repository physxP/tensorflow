// Copyright 2018 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at:
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import TensorFlowLiteC

/// A TensorFlow Lite model used by the `Interpreter` to perform inference.
final class Model {
  /// The `TfLiteModel` C pointer type represented as an `UnsafePointer<TfLiteModel>`.
  typealias CModel = OpaquePointer

  /// The underlying `TfLiteModel` C pointer.
  let cModel: CModel?

  /// Creates a new instance with the given `filePath`.
  ///
  /// - Precondition: Initialization can fail if the given `filePath` is invalid.
  /// - Parameters:
  ///   - filePath: The local file path to a TensorFlow Lite model.
  init?(filePath: String) {
    guard !filePath.isEmpty, let cModel = TfLiteModelCreateFromFile(filePath) else { return nil }
    self.cModel = cModel
  }

  init?(modelData: Data) {
    self.cModel = modelData.withUnsafeBytes { TfLiteModelCreate($0, modelData.count) }
  }

  deinit {
    TfLiteModelDelete(cModel)
  }
}
