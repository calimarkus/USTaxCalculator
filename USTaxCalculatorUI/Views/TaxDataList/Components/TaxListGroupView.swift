//
// TaxListGroupView.swift
//

import SwiftUI

struct TaxListGroupView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        let cornerRadius = 10.0
        VStack {
            content
        }
        .padding(10.0)
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(Color.secondary.opacity(0.5), lineWidth: 1)
                .background(Color.secondary.opacity(0.03)).cornerRadius(cornerRadius)
        )
        .transition(
            .opacity
                .combined(with: .offset(x: 0, y: -44.0))
                .combined(with: .scale(scale: 0.98, anchor: .leading))
        )
    }
}

struct TaxListGroupView_Previews: PreviewProvider {
    static var previews: some View {
        TaxListGroupView {
            VStack(alignment: .leading) {
                Text("Test")
                Text("Some longer text here")
                Text("Test3")
            }.padding(10.0)
        }.padding()
    }
}
