//
//  IngredientAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-04-15.
//

import ComposableArchitecture
import SwiftUI

struct IngredientAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    // TODO: - geometry reader?
    var body: some View {
        HStack {
            CoffeeAmountView(viewStore: self.viewStore)
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibility(sortPriority: 1)
            WaterAmountView(viewStore: self.viewStore)
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibility(sortPriority: 0)
        }
    }
}
