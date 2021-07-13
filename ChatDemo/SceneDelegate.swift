//
//  SceneDelegate.swift
//  ChatDemo
//
//  Created by tommaso barbugli on 13/07/2021.
//

import UIKit
import StreamChat
import StreamChatUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let config = ChatClientConfig(apiKey: .init("API_KEY"))
        let token =
            Token(
                stringLiteral: "USER_TOKEN"
            )

        Components.default.messageListVC = MessageList.self
        Components.default.attachmentViewCatalog = MyAttachmentViewCatalog.self

        Appearance.default.colorPalette.background6 = .green
        Appearance.default.images.sendArrow = UIImage(systemName: "arrowshape.turn.up.right")!

        /// create an instance of ChatClient and share it using the singleton
        ChatClient.shared = ChatClient(config: config)

        /// connect to chat
        ChatClient.shared.connectUser(
            userInfo: UserInfo(id: "USER_ID", name: "Tutorial Droid", imageURL: URL(string: "https://bit.ly/2TIt8NR")),
            token: token
        )

        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

