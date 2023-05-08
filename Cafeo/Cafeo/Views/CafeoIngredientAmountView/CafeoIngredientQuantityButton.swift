//
//  CafeoIngredientQuantityButton.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-03-09.
//

import ComposableArchitecture
import SwiftUI

struct CafeoIngredientQuantityButtonDomain {
    struct State: Equatable {}

    enum Action: Equatable {
        case onPress(step: IngredientAction)
        case onRelease
        case onTap(step: IngredientAction)
    }

    struct Environment {}

    static let reducer: Reducer<State, Action, Environment> = {
        return .init { _, _, _ in
            return .none
        }
    }()
}


struct CafeoIngredientQuantityButton: View {
    let store: Store<CafeoIngredientQuantityButtonDomain.State, CafeoIngredientQuantityButtonDomain.Action>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            ZStack {
                RoundedRectangle(cornerRadius: CommonConstants.Spacing.spacing24, style: .continuous)
                    .stroke(CommonAssets.Gradients.cafeoGray, lineWidth: 2)
                    .clipShape(RoundedRectangle(cornerRadius: CommonConstants.Spacing.spacing24, style: .continuous))
                    .frame(width: 120, height: 44)
                    .background(
                        RoundedRectangle(cornerRadius: CommonConstants.Spacing.spacing24, style: .continuous)
                            .fill(CommonAssets.Colors.cafeoPrimaryBackgroundLight)
                            .shadow(color: CommonAssets.Colors.cafeoHighlightLight, radius: 8, x: -4, y: -4)
                            .shadow(color: CommonAssets.Colors.cafeoShadowDark, radius: 8, x: 4, y: 4)
                    )
                    .overlay(
                        HStack(spacing: 0) {
                            CafeoQuantityStepperButton(Image.cafeo(.minus)) {
                                viewStore.send(.onTap(step: .decrement))
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0)
                                    .onEnded { _ in
                                        viewStore.send(.onPress(step: .decrement))
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { _ in
                                        // This is triggered by the end of a long press gesture
                                        viewStore.send(.onRelease)
                                    }
                            )

                            Spacer()

                            CafeoQuantityStepperButton(Image.cafeo(.plus)) {
                                viewStore.send(.onTap(step: .increment))
                            }
                            .simultaneousGesture(
                                LongPressGesture(minimumDuration: 0)
                                    .onEnded { _ in
                                        viewStore.send(.onPress(step: .increment))
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 0)
                                    .onEnded { _ in
                                        // This is triggered by the end of a long press gesture
                                        viewStore.send(.onRelease)
                                    }
                            )
                        }.padding(.horizontal, CommonConstants.Spacing.spacing6)
                    )
            }
        }
    }
}

private struct CafeoQuantityStepperButton: View {
    let action: () -> Void
    let image: Image

    init(_ image: Image, action: @escaping () -> Void) {
        self.action = action
        self.image = image
    }

    var body: some View {
        Button(action: self.action) {
            self.image
        }
        .contentShape(Rectangle())
        .cafeoButtonStyle(
            .init(
                labelFont: .quantityStepperLabel,
                labelColor: .quantityStepper,
                backgroundColor: .clear,
                size: CGSize(width: 44, height: 44)
            )
        )
    }
}
