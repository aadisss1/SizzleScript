//
//  ContentView.swift
//  SizzleScript
//
//  Created by Aadi Ahmed on 17/03/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    var body: some View {
        VStack {
          Text("Hello world")
        }
    }

    
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
