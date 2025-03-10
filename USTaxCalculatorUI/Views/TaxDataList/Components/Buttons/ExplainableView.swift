//
// ExplainableView.swift
//

import SwiftUI

enum ExplainableColumnSize {
    static var width: Double {
        #if os(visionOS)
            35.0
        #else
            25.0
        #endif
    }
}

struct ExplainableView<Content: View, InfoContent: View>: View {
    @State private var showingPopover = false

    let content: Content
    let infoContent: InfoContent

    init(@ViewBuilder content: () -> Content,
         @ViewBuilder infoContent: () -> InfoContent)
    {
        self.content = content()
        self.infoContent = infoContent()
    }

    var body: some View {
        Button {
            showingPopover = !showingPopover
        } label: {
            HStack(spacing: 0.0) {
                content
                HStack(spacing: 0.0) {
                    Spacer()
                    Image(systemName: "info.circle")
                        .foregroundColor(.secondary)
                    #if os(macOS)
                        .popover(isPresented: $showingPopover, arrowEdge: .trailing) {
                            infoContent
                                .frame(maxWidth: 500)
                        }
                    #endif

                    #if !os(macOS)
                        NavigationLink(isActive: $showingPopover) {
                            ScrollView {
                                infoContent
                            }
                        } label: {
                            EmptyView()
                                .hidden()
                        }
                        .hidden()
                        .frame(width: 0.0)
                    #endif
                }
                .frame(width: ExplainableColumnSize.width)
            }
        }
        .buttonStyle(.plain)
    }
}

struct ExplainableView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .trailing) {
            HStack(spacing: 0.0) {
                Text("$20.00").font(.system(.body, design: .monospaced))
                Spacer().frame(width: ExplainableColumnSize.width)
            }

            ExplainableView {
                Text("$500.50").font(.system(.body, design: .monospaced))
            } infoContent: {
                EmptyView()
            }

            ExplainableView {
                Text("40%").font(.system(.body, design: .monospaced))
            } infoContent: {
                EmptyView()
            }
        }.padding()
    }
}
