//
//  Filters.swift
//  VideoFilter
//
//  Created by Martin Chibwe on 10/28/17.
//  Copyright © 2017 Martin Chibwe. All rights reserved.
//

import Foundation
import AVFoundation
import CoreMedia
import UIKit

let CMYKHalftone = "CMYK Halftone"
let CMYKHalftoneFilter = CIFilter(name: "CICMYKHalftone", withInputParameters: ["inputWidth" : 20, "inputSharpness": 1])

let ComicEffect = "Comic Effect"
let ComicEffectFilter = CIFilter(name: "CIComicEffect")

let Crystallize = "Crystallize"
let CrystallizeFilter = CIFilter(name: "CICrystallize", withInputParameters: ["inputRadius" : 30])

let Edges = "Edges"
let EdgesEffectFilter = CIFilter(name: "CIEdges", withInputParameters: ["inputIntensity" : 10])

let HexagonalPixellate = "Hex Pixellate"
let HexagonalPixellateFilter = CIFilter(name: "CIHexagonalPixellate", withInputParameters: ["inputScale" : 40])

let Invert = "Invert"
let InvertFilter = CIFilter(name: "CIColorInvert")

let Pointillize = "Pointillize"
let PointillizeFilter = CIFilter(name: "CIPointillize", withInputParameters: ["inputRadius" : 30])

let LineOverlay = "Line Overlay"
let LineOverlayFilter = CIFilter(name: "CILineOverlay")

let Posterize = "Posterize"
let PosterizeFilter = CIFilter(name: "CIColorPosterize", withInputParameters: ["inputLevels" : 5])

let Filters = [
    CMYKHalftone: CMYKHalftoneFilter,
    ComicEffect: ComicEffectFilter,
    Crystallize: CrystallizeFilter,
    Edges: EdgesEffectFilter,
    HexagonalPixellate: HexagonalPixellateFilter,
    Invert: InvertFilter,
    Pointillize: PointillizeFilter,
    LineOverlay: LineOverlayFilter,
    Posterize: PosterizeFilter
]
var CIFilterNames = [
    "CIPhotoEffectChrome",
    "CIPhotoEffectFade",
    "CIPhotoEffectInstant",
    "CIPhotoEffectNoir",
    "CIPhotoEffectProcess",
    "CIPhotoEffectTonal",
    "CIPhotoEffectTransfer",
    "CISepiaTone"
]



