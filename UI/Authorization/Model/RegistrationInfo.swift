//
// RegistrationInfo.swift
// Zentry
//
// Created by Pavel Kuzmin on 2019-03-28.
// Copyright © 2019 Gaika Group. All rights reserved.
//

import Foundation

class RegistrationInfo {
    var type: TherapistType = .speech
    var email: String?
    var firstName: String?
    var lastName: String?
    var password: String?
    var confirmPassword: String?

    func validation() -> Error? {
        guard let email = self.email, !email.isEmpty else {
            return RegistrationInfoError.empty(field: "E-mail")
        }

        guard let firstName = self.firstName, !firstName.isEmpty else {
            return RegistrationInfoError.empty(field: "Name")
        }

        guard let password = self.password, !password.isEmpty else {
            return RegistrationInfoError.empty(field: "Password")
        }

        guard let confirmPassword = self.confirmPassword, !confirmPassword.isEmpty else {
            return RegistrationInfoError.empty(field: "Confirm password")
        }

        if password != confirmPassword {
            return RegistrationInfoError.doNotMatchPasswords
        }

        if let error = self.validation(password: password) {
            return error
        }

        return nil
    }

    // MARK: - Private functions

    private func validation(password: String) -> Error? {
        if password.count < 8 {
            return RegistrationInfoError.wrongPasswords
        }

        return nil
    }
}

enum RegistrationInfoError: Error {
    case empty(field: String)
    case doNotMatchPasswords
    case wrongPasswords
}

extension RegistrationInfoError: CustomNSError {
    var errorCode: Int {
        switch self {
        case .empty(field: _):
            return 1045
        case .doNotMatchPasswords:
            return 1047
        case .wrongPasswords:
            return 1048
        }
    }

    var errorUserInfo: [String : Any] {
        switch self {
        case .empty(field: let field):
            return [NSLocalizedDescriptionKey: LS("registration.info.error.emptyField") + " " + field,
                    NSLocalizedFailureReasonErrorKey: LS("registration.info.error.emptyField.Reason")]
        case .doNotMatchPasswords:
            return [NSLocalizedDescriptionKey: LS("registration.info.error.doNotMatchPasswords"),
                    NSLocalizedFailureReasonErrorKey: LS("registration.info.error.doNotMatchPasswords.Reason")]
        case .wrongPasswords:
            return [NSLocalizedDescriptionKey: LS("registration.info.error.wrongPasswords"),
                    NSLocalizedFailureReasonErrorKey: LS("registration.info.error.wrongPasswords.Reason")]
        }
    }
}
