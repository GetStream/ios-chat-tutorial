//
// Copyright © 2021 Stream.io Inc. All rights reserved.
//

import StreamChat
import StreamChatUI
import UIKit

func applyChatCustomizations() {
    Appearance.default.colorPalette.background6 = .green
    Appearance.default.images.sendArrow = UIImage(systemName: "arrowshape.turn.up.right")!

    Components.default.channelVC = DemoChannelVC.self
    Components.default.attachmentViewCatalog = MyAttachmentViewCatalog.self
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        let config = ChatClientConfig(apiKey: .init("b67pax5b2wdq"))

        /// user id and token for the user
        let userId = "tutorial-droid"
        let token: Token =
            "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZHJvaWQifQ.NhEr0hP9W9nwqV7ZkdShxvi02C5PR7SJE7Cs4y7kyqg"

        applyChatCustomizations()

        /// create an instance of ChatClient and share it using the singleton
        ChatClient.shared = ChatClient(config: config)

        /// connect to chat
        ChatClient.shared.connectUser(
            userInfo: UserInfo(
                id: "tutorial-droid",
                name: "Tutorial Droid",
                imageURL: URL(string: "https://bit.ly/2TIt8NR")
            ),
            token: token
        )
       
        let channelList = DemoChannelList()
        let query = ChannelListQuery(filter: .containMembers(userIds: [userId]))
        channelList.controller = ChatClient.shared.channelListController(query: query)
        
        /// similar to embedding with a navigation controller using Storyboard
        window?.rootViewController = UINavigationController(rootViewController: channelList)
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
