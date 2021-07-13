import StreamChat
import StreamChatUI
import UIKit
import Nuke

class ViewController: ChatChannelListVC {
    override open func setUp() {
        let query = ChannelListQuery(filter: .containMembers(userIds: [ChatClient.shared.currentUserId!]))

        /// create a controller and assign it to this view controller
        controller = ChatClient.shared.channelListController(query: query)
        super.setUp()
    }
}

class ImgurImageAttachmentView: UIView {
    var content: ChatMessageLinkAttachment? { didSet { updateContent() } }

    lazy var imagePreview: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = false
        return view
    }()

    lazy var imgurLogoView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imagePreview)

        NSLayoutConstraint.activate([
            imagePreview.topAnchor.constraint(equalTo: topAnchor),
            imagePreview.bottomAnchor.constraint(equalTo: bottomAnchor),
            imagePreview.leadingAnchor.constraint(equalTo: leadingAnchor),
            imagePreview.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        let logo = UIImage(named: "imgur_logo")!

        addSubview(imgurLogoView)
        imgurLogoView.image = logo

        let logoWidth: CGFloat = 100
        let logoRatio = logo.size.height / logo.size.width

        NSLayoutConstraint.activate([
            imgurLogoView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imgurLogoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imgurLogoView.widthAnchor.constraint(equalToConstant: logoWidth),
            imgurLogoView.heightAnchor.constraint(equalToConstant: logoWidth * logoRatio)
        ])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateContent() {
        guard let payload = content?.payload else {
            return
        }

        let request = ImageRequest(url: payload.assetURL)
        Nuke.loadImage(with: request, into: imagePreview)
    }
}

class ImgurImageAttachmentViewInjector: AttachmentViewInjector {
    let imgurImageAttachmentView: ImgurImageAttachmentView = {
        let view = ImgurImageAttachmentView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override open func contentViewDidLayout(options: ChatMessageLayoutOptions) {
        contentView.bubbleContentContainer.insertArrangedSubview(imgurImageAttachmentView, at: 0, respectsLayoutMargins: true)

        let constraint = imgurImageAttachmentView.widthAnchor.constraint(equalTo: contentView.widthAnchor)
        constraint.priority = .defaultLow
        constraint.isActive = true
    }

    override open func contentViewDidUpdateContent() {
        imgurImageAttachmentView.content = attachments(payloadType: LinkAttachmentPayload.self).first
    }
}

private func hasImgurLinkAttachment(message: ChatMessage) -> Bool {
    guard let imageAttachment = message.attachments(payloadType: LinkAttachmentPayload.self).first else {
        return false
    }

    guard let host = imageAttachment.assetURL.host else {
        return false
    }

    return host.hasSuffix("imgur.com")
}

class MyAttachmentViewCatalog: AttachmentViewCatalog {
    override class func attachmentViewInjectorClassFor(message: ChatMessage, components: Components) -> AttachmentViewInjector
        .Type? {
        if hasImgurLinkAttachment(message: message) {
            return ImgurImageAttachmentViewInjector.self
        }

        return super.attachmentViewInjectorClassFor(message: message, components: components)
    }
}

