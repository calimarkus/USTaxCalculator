//
// MacOSViewModifiers.swift
//

import SwiftUI

extension View {
    func macOnlyPadding(_ padding: Double) -> some View {
        modifier(MacOnlyPadding(padding: padding))
    }

    func macOnlyInlinePickerStyle() -> some View {
        modifier(MacOnlyPickerStyle(style: .inline))
    }
}

struct MacOnlyPadding: ViewModifier {
    let padding: Double

    func body(content: Content) -> some View {
        content
        #if os(macOS)
        .padding(padding)
        #endif
    }
}

struct MacOnlyPickerStyle<Style: PickerStyle>: ViewModifier {
    let style: Style

    func body(content: Content) -> some View {
        content
        #if os(macOS)
        .pickerStyle(style)
        #endif
    }
}

@ViewBuilder
func MacOnlySpacer(height: Double) -> some View {
    #if os(macOS)
    Spacer().frame(height: height)
    #endif
}
