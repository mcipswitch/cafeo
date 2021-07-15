//
//  CafeoIngredientAmountView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-04-15.
//

import ComposableArchitecture
import SwiftUI

struct CafeoIngredientAmountView: View {
    let store: Store<AppState, AppAction>

    // TODO: - geometry reader?
    var body: some View {
        WithViewStore(self.store) { viewStore in
            HStack {
                CafeoCoffeeAmountView(store: self.store)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .accessibility(sortPriority: 1)
                CafeoWaterAmountView(store: self.store)
                    .frame(width: UIScreen.main.bounds.width / 2)
                    .accessibility(sortPriority: 0)
            }
        }
    }
}
