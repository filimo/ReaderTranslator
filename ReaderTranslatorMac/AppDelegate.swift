//
//  AppDelegate.swift
//  ReaderTranslator
//
//  Created by Viktor Kushnerov on 11.10.24.
//  Copyright © 2024 Viktor Kushnerov. All rights reserved.
//

import AppKit
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    var monitor: Any?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Set up a global monitor for key presses
        monitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleKeyEvent(event)
        }
    }

    func handleKeyEvent(_ event: NSEvent) {
        // Check if Ctrl + Option + Command + D are pressed
        if event.modifierFlags.contains([.control, .option, .command]) && event.charactersIgnoringModifiers == "s" {
            performShortcutAction()
        }
    }

    func handleGlobalShortcut() {
        // Send "copy" command to the active application
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        // Create an event source
        let source = CGEventSource(stateID: .hidSystemState)
        // Create a "C" key down event
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: true) // 0x08 - key code for "C"
        // Set the command flag
        keyDown?.flags = .maskCommand
        // Post the event
        keyDown?.post(tap: .cghidEventTap)

        // Create a "C" key up event
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: false)
        // Set the command flag
        keyUp?.flags = .maskCommand
        // Post the event
        keyUp?.post(tap: .cghidEventTap)

        // Wait a bit for the text to get into the clipboard
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let text = pasteboard.string(forType: .string) {
                Store.shared.translateAction.addAll(text: text)
                // Activate the application and bring its window to the front
                NSApplication.shared.activate(ignoringOtherApps: true)
                NSApplication.shared.windows.first?.makeKeyAndOrderFront(nil)
            }
        }
    }

    func performShortcutAction() {
        handleGlobalShortcut()
    }

    func applicationWillTerminate(_ notification: Notification) {
        // Remove monitor when the application terminates
        if let monitor = monitor {
            NSEvent.removeMonitor(monitor)
        }
    }
}
