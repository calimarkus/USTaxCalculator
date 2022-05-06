//
//

import SwiftUI

class TaxDataSet: ObservableObject {
    @Published var selection: Set<Int> = [0]
    var activeTaxData:USTaxData { get {
        return taxData[selection.first!]
    }}
    let taxData:[USTaxData] = [ExampleData.single21Data(), ExampleData.single20Data()]
}

struct MainView: View {
    @EnvironmentObject var dataset: TaxDataSet

    var body: some View {
        NavigationView {
            MenuView()
            TaxDataView(taxdata: dataset.activeTaxData)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(TaxDataSet())
    }
}
