//
// SourcesListView.swift
//

import SwiftUI

struct SourcesListView: View {
    let sources: [URL]

    var body: some View {
        if sources.count > 0 {
            VStack(alignment: .leading, spacing: 5.0) {
                Text("Sources:")
                    .font(.headline)
                ForEach(sources, id: \.absoluteString) { source in
                    Link(source.absoluteString, destination: source)
                        .font(.subheadline)
                        .opacity(0.66)
                        .lineLimit(1)
                    #if os(macOS)
                        .font(.caption2)
                    #endif
                }
            }
        }
    }
}

struct SourcesListView_Previews: PreviewProvider {
    static var previews: some View {
        SourcesListView(sources: [
            "www.google.com",
            "www.nyt.com",
        ]).padding(20.0)
    }
}
