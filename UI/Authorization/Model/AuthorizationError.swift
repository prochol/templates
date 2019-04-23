//
// AuthorizationError.swift
// DaTracker
//
// Created by Pavel Kuzmin on 2018-12-05.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import Foundation

enum AuthorizationError: Error {
    case notFound
    case wrongUser
    case notFoundEmail
    case failedRegisterUser
    case updateToken(error: Error)
}

extension AuthorizationError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .notFound, .notFoundEmail:
            return 404
        case .wrongUser, .failedRegisterUser, .updateToken(error: _):
            return 400
        }
    }

    var errorUserInfo: [String : Any] {
        switch self {
        case .notFound:
            return [NSLocalizedDescriptionKey: LS("authorization.error.notFoundUser"),
                    NSLocalizedFailureReasonErrorKey: LS("authorization.error.notFoundUser.Reason")]
        case .wrongUser:
            return [NSLocalizedDescriptionKey: LS("authorization.error.wrongUser"),
                    NSLocalizedFailureReasonErrorKey: LS("authorization.error.wrongUser.Reason")]
        case .notFoundEmail:
            return [NSLocalizedDescriptionKey: LS("authorization.error.notFoundEmail"),
                    NSLocalizedFailureReasonErrorKey: LS("authorization.error.notFoundEmail.Reason")]
        case .failedRegisterUser:
            return [NSLocalizedDescriptionKey: LS("authorization.error.failedRegisterUser"),
                    NSLocalizedFailureReasonErrorKey: LS("authorization.error.failedRegisterUser.Reason")]
        case .updateToken(error: let error):
            return [NSLocalizedDescriptionKey: LS("authorization.error.updateToken"),
                    NSLocalizedFailureReasonErrorKey: LS("authorization.error.updateToken.Reason"),
                    NSUnderlyingErrorKey: error]
        }
    }
}
