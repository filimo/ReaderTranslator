//
//  EditorTextView.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 10/2/19.
//  Copyright © 2019 Viktor Kushnerov. All rights reserved.
//

//
//  Created by Thiago Holanda on 22.07.19.
//  Copyright © 2019 unnamedd codes. All rights reserved.
//  https://gist.github.com/unnamedd/6e8c3fbc806b8deb60fa65d6b9affab0

import Combine
import SwiftUI

struct EditorNSTextRepresentable: NSViewRepresentable {
    @Binding var translateAction: TranslateAction
    private var text: String {
        get {
            guard case let .gTranslator(text) = translateAction else { return "" }
            return text
        }
        set {
            translateAction = .gTranslator(text: newValue)
        }
    }

    var onEditingChanged: () -> Void = {}
    var onCommit: () -> Void = {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeNSView(context: Context) -> CustomNSTextView {
        let textView = CustomNSTextView(text: text)
        textView.delegate = context.coordinator

        return textView
    }

    func updateNSView(_ view: CustomNSTextView, context: Context) {
        view.text = text
        view.selectedRanges = context.coordinator.selectedRanges
    }
}

extension EditorNSTextRepresentable {
    class Coordinator: NSObject, NSTextViewDelegate {
        var parent: EditorNSTextRepresentable
        var selectedRanges: [NSValue] = []

        init(_ parent: EditorNSTextRepresentable) {
            self.parent = parent
        }

        func textDidBeginEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            parent.text = textView.string
            parent.onEditingChanged()
        }

        func textDidChange(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            parent.text = textView.string
            selectedRanges = textView.selectedRanges
        }

        func textDidEndEditing(_ notification: Notification) {
            guard let textView = notification.object as? NSTextView else {
                return
            }

            parent.text = textView.string
            parent.onCommit()
        }
    }
}

final class CustomNSTextView: NSView {
    private var isEditable: Bool
    private var font: NSFont

    weak var delegate: NSTextViewDelegate?

    var text: String {
        didSet {
            textView.string = text
        }
    }

    var selectedRanges: [NSValue] = [] {
        didSet {
            guard selectedRanges.count > 0 else {
                return
            }

            textView.selectedRanges = selectedRanges
        }
    }

    private lazy var scrollView: NSScrollView = {
        let scrollView = NSScrollView()
        scrollView.drawsBackground = true
        scrollView.borderType = .noBorder
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalRuler = false
        scrollView.autoresizingMask = [.width, .height]
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    private lazy var textView: NSTextView = {
        let contentSize = scrollView.contentSize
        let textStorage = NSTextStorage()

        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)

        let textContainer = NSTextContainer(containerSize: scrollView.frame.size)
        textContainer.widthTracksTextView = true
        textContainer.containerSize = NSSize(
            width: contentSize.width,
            height: CGFloat.greatestFiniteMagnitude
        )

        layoutManager.addTextContainer(textContainer)

        let textView = NSTextView(frame: .zero, textContainer: textContainer)
        textView.autoresizingMask = .width
        textView.backgroundColor = NSColor.textBackgroundColor
        textView.delegate = self.delegate
        textView.drawsBackground = true
        textView.font = self.font
        textView.isEditable = self.isEditable
        textView.isHorizontallyResizable = false
        textView.isVerticallyResizable = true
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude,
                                  height: CGFloat.greatestFiniteMagnitude)
        textView.minSize = NSSize(width: 0, height: contentSize.height)
        textView.textColor = NSColor.labelColor

        return textView
    }()

    // MARK: - Init

    init(text: String,
         isEditable: Bool = true,
         font: NSFont = NSFont.systemFont(ofSize: 32, weight: .ultraLight)) {
        self.font = font
        self.isEditable = isEditable
        self.text = text

        super.init(frame: .zero)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewWillDraw() {
        super.viewWillDraw()

        setupScrollViewConstraints()
        setupTextView()
    }

    func setupScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
    }

    func setupTextView() {
        scrollView.documentView = textView
    }
}
