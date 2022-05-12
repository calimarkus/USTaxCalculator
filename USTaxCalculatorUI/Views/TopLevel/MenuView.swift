//
//

import SwiftUI

struct MenuView: View {
    @ObservedObject var appState: GlobalAppState

    var body: some View {
        List(selection: appState.selectionBinding()) {
            ForEach(appState.taxdata.indices, id: \.self) { i in
                if let taxdata = appState.taxdata[i] {
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
                            appState.navigationState = .entry(entryIndex: i, isEditing: true)
                        }
                        Button("Delete", role: .destructive) {
                            appState.taxdata.remove(at: i)
                        }
                    }
                }
            }
        }
        .listStyle(SidebarListStyle())
        .onDeleteCommand {
            if let idx = appState.selectionBinding().wrappedValue.first {
                appState.taxdata.remove(at: idx)
            }
        }
    }

    func titleForTaxdata(taxdata: CalculatedTaxData) -> String {
        return (FormattingHelper.formattedShortTitle(taxData: taxdata))
    }

    func infoTextForTaxdata(taxdata: CalculatedTaxData) -> String {
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
