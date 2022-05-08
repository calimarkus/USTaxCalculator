//
//

import SwiftUI

class TaxDataSet: ObservableObject {
    @Published var selection: Set<Int> = [0]
    var activeTaxData: USTaxData? {
        if let idx = selection.first {
            return taxData[idx]
        } else {
            return nil
        }
    }

    let taxData: [USTaxData] = [ExampleData.single21Data(), ExampleData.single20Data()]
}

struct MainView: View {
    @EnvironmentObject var dataset: TaxDataSet

    var body: some View {
        NavigationView {
            MenuView()
            Group {
                if let taxdata = dataset.activeTaxData {
                    TaxDataView(taxdata: taxdata)
                } else {
                    EmptyView()
                }
            }
            .frame(minWidth: 400.0, minHeight: 400.0)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .frame(width: 750.0, height: 500)
            .environmentObject(TaxDataSet())
    }
}
