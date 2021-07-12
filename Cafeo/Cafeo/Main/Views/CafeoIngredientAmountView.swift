//
//  CafeoIngredientAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-04-15.
//

import ComposableArchitecture
import SwiftUI

struct CafeoIngredientAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    // TODO: - geometry reader?
    var body: some View {
        HStack {
            CafeoCoffeeAmountView(viewStore: self.viewStore)
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibility(sortPriority: 1)
            CafeoWaterAmountView(viewStore: self.viewStore)
                .frame(width: UIScreen.main.bounds.width / 2)
                .accessibility(sortPriority: 0)
        }
    }
}
