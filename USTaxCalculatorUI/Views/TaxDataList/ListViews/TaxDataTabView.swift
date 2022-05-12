//
//

import SwiftUI

enum TaxListTab: String {
    case federal = "Federal"
    case states = "States"
    case summary = "Summary"
}

struct TaxDataTabView<Content: View>: View {
    let tab: TaxListTab
    let content: Content

    init(_ tab: TaxListTab, @ViewBuilder content: () -> Content) {
        self.tab = tab
        self.content = content()
    }

    var body: some View {
        ScrollView {
            HStack {
                Spacer()
                VStack(alignment: .leading) {
                    content
                }
                .frame(maxWidth: 680)
                .padding()
                Spacer()
            }
        }
        .id(tab)
        .tabItem {
            Image(systemName: "dollarsign.circle.fill")
            Text(tab.rawValue)
        }
    }
}

struct TaxDataTabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            TaxDataTabView(.federal) {
                Text("text")
            }
        }.padding()
    }
}
