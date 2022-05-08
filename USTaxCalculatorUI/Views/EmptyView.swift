//
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack(spacing:0.0) {
            Image(systemName: "pencil.circle.fill")
                .imageScale(.large)
                .font(.system(size: 42, weight: .bold))
            Text("Nothing selected.")
                .padding()
                .navigationTitle("")
            Button {
                // tbd
            } label: {
                Text("Add a dataset")
            }.padding()
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
            .padding()
    }
}
