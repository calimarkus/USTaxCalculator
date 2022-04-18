//
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            MenuView(data: [ExampleData.single21Data()])
            TaxDataView(taxdata: ExampleData.single21Data())
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
