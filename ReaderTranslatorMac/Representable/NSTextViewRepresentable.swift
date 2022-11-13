//
//  NSTextViewRepresentable.swift
//  ReaderTranslatorMac
//
//  Created by Viktor Kushnerov on 13.11.22.
//  Copyright © 2022 Viktor Kushnerov. All rights reserved.
//

import SwiftUI

struct NSTextViewRepresentable: NSViewRepresentable {
    let textView = NSTextView()
    
    @Binding var text: String
    @Binding var selectedText: String
    
    func makeNSView(context: Context) -> NSTextView {
        textView.delegate = context.coordinator
        return textView
    }
    
    func updateNSView(_ view: NSTextView, context: Context) {
        // SwiftUI -> UIKit
        if view.string != text { view.string = text }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, NSTextViewDelegate {
        let parent: NSTextViewRepresentable
        
        init(_ parent: NSTextViewRepresentable) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: NSTextView) {
            parent.text = textView.string
        }
        
        func textViewDidChangeSelection(_ notification: Notification) {
            Task {
                await MainActor.run {
                    parent.selectedText = parent.textView.selectedText
                }
            }
        }
        
        func textDidChange(_ notification: Notification) {
            parent.text = parent.textView.string
        }
    }
}
