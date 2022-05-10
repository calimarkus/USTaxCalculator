//
//

import SwiftUI

struct MainView: View {
    @ObservedObject var dataset: TaxDataSet
    @ObservedObject var collapseState: SectionCollapseState

    var body: some View {
        NavigationView {
            MenuView(dataset: dataset)
            Group {
                if dataset.showEntryForm {
                    TaxDataEntryView(dataset: dataset,
                                     input: dataset.taxDataInputForEditing)
                } else if let taxdata = dataset.activeTaxData {
                    TaxDataListView(collapseState: collapseState,
                                    dataset: dataset,
                                    taxdata: taxdata)
                } else {
                    EmptyView(dataset: dataset)
                }
            }
            .frame(minWidth: 400.0, minHeight: 400.0)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(dataset: TaxDataSet(),
                 collapseState: SectionCollapseState())
            .frame(width: 750.0, height: 500)
    }
}
