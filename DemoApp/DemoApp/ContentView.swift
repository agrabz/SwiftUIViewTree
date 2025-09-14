
import SwiftUI
import SwiftUIViewTreeKit

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .renderViewTree(of: self)
    }
}

#Preview {
    ContentView()
}
