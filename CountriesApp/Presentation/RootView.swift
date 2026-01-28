
import SwiftUI

struct RootView: View {
    @StateObject var store: CountriesStore

    var body: some View {
        TabView {
            SearchView()
                .tabItem { Label("tab.search", systemImage: "magnifyingglass") }

            SavedView()
                .tabItem { Label("tab.saved", systemImage: "star.fill") }
        }
        .environmentObject(store)
        .task { await store.bootstrapIfNeeded() }
        .alert("alert.error.title", isPresented: Binding(
            get: { store.errorMessage != nil },
            set: { if !$0 { store.clearError() } }
        )) {
            Button("alert.ok", role: .cancel) { store.clearError() }
        } message: {
            Text(store.errorMessage ?? "")
        }
    }
}
