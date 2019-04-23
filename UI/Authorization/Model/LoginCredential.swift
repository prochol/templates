//
// LoginCredential.swift
// DaTracker
//
// Created by Pavel Kuzmin on 24.10.2018.
// Copyright © 2018 Gaika Group. All rights reserved.
//

import Foundation

class LoginCredential {
    var username: String?
    var password: String?

    func validation() -> Error? {
        guard let username = self.username, !username.isEmpty else {
            return CredentialError.emptyField
        }

        guard let password = self.password, !password.isEmpty else {
            return CredentialError.emptyField
        }

        return nil
    }
}

enum CredentialError: Error {
    case emptyField
}

extension CredentialError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .emptyField:
            return 1045
        }
    }

    var errorUserInfo: [String : Any] {
        switch self {
        case .emptyField:
            return [NSLocalizedDescriptionKey: LS("authorization.error.emptyField"),
                    NSLocalizedFailureReasonErrorKey: LS("authorization.error.emptyField.Reason")]
        }
    }
}

struct LoginCredentialMock {
    struct Behavior {
        let username: String = "therapist101"
        let password: String = "test"
        let userId: String = "167F40F4-8D72-449B-B9D0-E2278248837A"
        let userType: Int = 0
    }

    struct Speech {
        let username: String = "speechtherapist"
        let password: String = "test"
        let userId: String = "777091A6-A4D5-47EB-8E83-4D73358FC577"
        let userType: Int = 1
    }
}
