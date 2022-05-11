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
                        Label(title: {
                            VStack(alignment: .leading) {
                                Text(titleForTaxdata(taxdata: taxdata))
                                Text(infoTextForTaxdata(taxdata: taxdata))
                                    .foregroundColor(.secondary)
                                    .font(.subheadline)
                            }
                        }, icon: {
                            Image(systemName: "dollarsign.circle.fill")
                        }).tag(i)
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

    func titleForTaxdata(taxdata: USTaxData) -> String {
        return (FormattingHelper.formattedShortTitle(taxData: taxdata))
    }

    func infoTextForTaxdata(taxdata: USTaxData) -> String {
        let states = FormattingHelper.formattedStates(states: taxdata.stateTaxes.map { $0.state })
        let taxyear = FormattingHelper.formattedTaxYearShort(taxData: taxdata)
        return "\(states), \(taxyear)"
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView(appState: GlobalAppState())
    }
}
