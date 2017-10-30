//
//  WhatsNewViewController.swift
//  WhatsNew
//
//  Created by Patrick Balestra on 10/15/17.
//  Copyright © 2017 Patrick Balestra. All rights reserved.
//

import UIKit

public class WhatsNewViewController: UIViewController {

    /// Defines when to present the What's New view controller. Check the `PresentationOption` enum for more details.
    public var presentationOption: PresentationOption = .always
    /// Closure invoked when the user dismisses the view controller.
    public var onDismissal: (() -> Void)?
    /// Text of the top title.
    public var titleText: String = "What's New" {
        didSet {
            titleLabel.text = titleText
        }
    }
    /// Color of the top title.
    public var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    /// Text of the bottom button that dismisses the view controller.
    public var buttonText: String = "Continue" {
        didSet {
            continueButton.setTitle(buttonText, for: .normal)
        }
    }
    /// Text color of the bottom button that dismisses the view controller.
    public var buttonTextColor: UIColor = .yellow {
        didSet {
            continueButton.setTitleColor(buttonTextColor, for: .normal)
        }
    }
    public var buttonBackgroundColor: UIColor = .black {
        didSet {
            continueButton.backgroundColor = buttonBackgroundColor
        }
    }

    private let items: [WhatsNewItem]

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var continueButton: UIButton!

    public init(items: [WhatsNewItem]) {
        self.items = items
        super.init(nibName: "WhatsNew", bundle: Constants.bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("Unsupported initializer, please use init(items:)")
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setUp(with: items)
    }

    public func presentIfNeeded(on parentViewController: UIViewController) {
        guard Constants.canPresent else { return }
        parentViewController.present(self, animated: true, completion: nil)
    }

    private func setUp(with items: [WhatsNewItem]) {
        items.forEach { item in
            let view: UIView
            switch item {
            case .image(let title, let subtitle, let image):
                let itemView = WhatsNewItemImageView.loadFromNib()
                itemView.set(image: image, title: title, subtitle: subtitle)
                view = itemView

            case .text(let title, let subtitle):
                let itemView = WhatsNewItemTextView.loadFromNib()
                itemView.set(title: title, subtitle: subtitle)
                view = itemView
            }
            stackView.addArrangedSubview(view)
        }
    }

    @IBAction func `continue`() {
        UserDefaults.standard.set(Constants.appVersion, forKey: Constants.userDefaultsKey)
        dismiss(animated: true, completion: onDismissal)
    }
}
