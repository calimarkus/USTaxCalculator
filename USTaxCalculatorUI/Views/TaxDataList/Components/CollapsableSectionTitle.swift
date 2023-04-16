//
// CollapsableSectionTitle.swift
//

import SwiftUI

struct CustomLinkStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .secondary : .primary)
    }
}

struct NonCollapsableSectionTitle: View {
    let title: String
    var isFirst: Bool = false
    var titleInset: Double = 10.0

    var body: some View {
        Text(title)
            .font(.headline)
            .padding(.top, isFirst ? 0.0 : 6.0)
            .padding(.bottom, 2.0)
            .padding(.leading, titleInset)
    }
}

struct CollapsableSectionTitle: View {
    let title: String
    var isFirst: Bool = false
    var titleInset: Double = 10.0
    @Binding var isExpanded: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Button {
                    withAnimation {
                        isExpanded = !isExpanded
                    }
                } label: {
                    HStack {
                        Text(title)
                            .font(.headline)
                        Image(systemName: isExpanded
                            ? "chevron.down.square.fill"
                            : "chevron.up.square.fill")
                    }
                }
                .buttonStyle(CustomLinkStyle())
            }
            .padding(.top, isFirst ? 0.0 : 6.0)
            .padding(.bottom, 2.0)
            .padding(.leading, titleInset)
        }
    }
}

struct CollapsableSectionTitle_Previews: PreviewProvider {
    @State static var expanded: Bool = false
    static var previews: some View {
        VStack(alignment: .leading) {
            CollapsableSectionTitle(title: "First one",
                                    isFirst: true,
                                    titleInset: 5.0,
                                    isExpanded: $expanded)
            GroupBox {
                VStack(alignment: .leading) {
                    HStack {
                        Text("Some longer text here")
                        Text("Some longer text here")
                    }
                    Text("And more text")
                }.padding()
            }

            CollapsableSectionTitle(title: "Second",
                                    titleInset: 0.0,
                                    isExpanded: $expanded)
            Text("x")
            Text("y")

            NonCollapsableSectionTitle(title: "Fixed Third", titleInset: 0.0)
            Text("x")
            Text("y")

        }.padding()
    }
}
