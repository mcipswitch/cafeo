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

    var body: some View {
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
