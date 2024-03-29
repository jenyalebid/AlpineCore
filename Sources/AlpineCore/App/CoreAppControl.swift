//
//  CoreAppControl.swift
//  AlpineCore
//
//  Created by Jenya Lebid on 1/18/24.
//

import SwiftUI
import SwiftData

import PopupKit

public typealias Core = CoreAppControl
public typealias CoreAlert = SceneAlert
public typealias CoreAlertButton = AlertButton

@Observable
public class CoreAppControl {
    
    public static var shared = CoreAppControl()
    
    public var modelContainer: ModelContainer?
    
    public var user: CoreUser! // IN MAIN CONTEXT
    public var app: CoreApp! // IN MAIN CONTEXT
    
    public var defaults = CoreDefaults()
    
    private init() {}
   
    private func getErrorText(error: Error) -> (String, String) {
        if let err = error as? AlpineError {
            return (err.getType(), err.message)
        }
        return ("System Error", error.log())
    }
    
    public func makeError(error: Error, additionalInfo: String? = nil, showToUser: Bool = true) {
        guard let modelContainer else { return }
        Task {
            let actor = AppErrorActor(modelContainer: modelContainer)
            await actor.makeError(error: error, additionalInfo: additionalInfo, userId: user.persistentModelID)
            if showToUser {
                let (title, message) = getErrorText(error: error)
                Core.makeAlert(CoreAlert(title: title, message: message, buttons: nil))
            }
        }
    }
    
    public static func reset() {
        CoreAppControl.shared = CoreAppControl()
    }
}

public extension CoreAppControl {
    
    static func quit() {
        exit(0)
    }
}

public extension CoreAppControl { // Alerts
    
    static var user: CoreUser {
        Core.shared.user
    }
    
    static func makeAlert(_ alert: CoreAlert) {
        DispatchQueue.main.async {
            AlertManager.shared.presentAlert(alert)
        }
    }
    
    static func makeSimpleAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            let alert = CoreAlert(title: title, message: message, buttons: nil)
            AlertManager.shared.presentAlert(alert)
        }
    }
    
    static func makeError(error: Error, additionalInfo: String? = nil, showToUser: Bool = true) {
        Self.shared.makeError(error: error, additionalInfo: additionalInfo, showToUser: showToUser)
    }
}

public extension CoreAppControl {
    
    static func presentSheet<Content: View>(style: UIModalPresentationStyle = .automatic, @ViewBuilder _ content: @escaping () -> Content) {
        PKSheetManager.shared.presentSheet(style: style, content)
    }
    
    static func makePopout(systemImage: String, message: String) {
        PKPopoutManager.shared.makePopout(systemImage: systemImage, message: message)
    }
}
