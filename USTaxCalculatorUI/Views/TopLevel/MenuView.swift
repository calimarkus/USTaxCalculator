//
//

import SwiftUI

extension USTaxData: Identifiable {
    var id: String { return "\(title)\(taxYear.rawValue)\(filingType.rawValue)" }
}

struct MenuView: View {
    @ObservedObject var appState: GlobalAppState

    var body: some View {
        List(selection: $appState.selection) {
            ForEach(appState.taxData.indices, id: \.self) { i in
                if let taxdata = appState.taxData[i] {
                    HStack {
                        Label("\(FormattingHelper.formattedShortTitle(taxData: taxdata))",
                              systemImage: "dollarsign.circle.fill").tag(i)
                        Text("(\(FormattingHelper.formattedStates(states: taxdata.stateTaxes.map { $0.state })), \(FormattingHelper.formattedTaxYearShort(taxData: taxdata)))")
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                    .contextMenu {
                        Button("Edit") {
                            appState.editEntry(index: i)
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(appState: GlobalAppState())
    }
}
