//
// TherapistType.swift
// Zentry
//
// Created by prochol on 2019-03-29.
// Copyright © 2019 Gaika Group. All rights reserved.
//

import Foundation

enum TherapistType: Int, CaseIterable {
    case speech = 1
    case behavior

    var title: String {
        switch self {
        case .speech: return "Speech"
        case .behavior: return "Behavior"
        }
    }
}
