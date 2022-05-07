//
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        Text("")
            .padding()
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .status) {
                    Button {
                        // TBD
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
