//
//  Coffio.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-08.
//

import ComposableArchitecture
import SwiftUI

struct WaterAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    
    private func waterIncrementButtonTapped() {
        self.viewStore.send(.waterIncrementButtonTapped)
    }
    
    private func waterDecrementButtonTapped() {
        self.viewStore.send(.waterDecrementButtonTapped)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Text("WATER")
                .coffioTextStyle(.mainLabel)
            
            VStack(spacing: 16) {
                Text("\(viewStore.waterAmount, specifier: "%.0f")")
                    .coffioTextStyle(.digitalLabel)
                
                IncrementDecrementButton(
                    incrementAction: self.waterIncrementButtonTapped,
                    decrementAction: self.waterDecrementButtonTapped
                )
            }
            
            Toggle("", isOn: viewStore.binding(
                keyPath: \.lockWaterAmount,
                send: AppAction.form
            )).toggleStyle(LockToggleStyle())
        }
    }
}

struct CoffeeAmountView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    
    private func coffeeIncrementButtonTapped() {
        self.viewStore.send(.coffeeIncrementButtonTapped)
    }
    
    private func coffeeDecrementButtonTapped() {
        self.viewStore.send(.coffeeDecrementButtonTapped)
    }
    
    var body: some View {
        VStack(spacing: 32) {
            Text("COFFEE")
                .coffioTextStyle(.mainLabel)
            
            VStack(spacing: 16) {
                Text("\(viewStore.coffeeAmount, specifier: "%.1f")")
                    .coffioTextStyle(.digitalLabel)
                
                IncrementDecrementButton(
                    incrementAction: self.coffeeIncrementButtonTapped,
                    decrementAction: self.coffeeDecrementButtonTapped
                )
            }
            
            Toggle("", isOn: viewStore.binding(
                keyPath: \.lockCoffeeAmount,
                send: AppAction.form
            )).toggleStyle(LockToggleStyle())
        }
    }
}

struct RatioView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>

    var ratioDenominatorLine: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.coffioOrange)
                .shadow(color: Color.black.opacity(0.5), radius: 2, x: 0, y: 1)
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.white.opacity(0.3))
                .blur(radius: 1)
        }
        .frame(height: 2)
    }

    var body: some View {
        VStack(spacing: 24) {
                ZStack {
                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), style: StrokeStyle(lineWidth: 2))
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(#colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.168627451, alpha: 1)), Color(#colorLiteral(red: 0.2431372549, green: 0.262745098, blue: 0.2941176471, alpha: 1)), Color(#colorLiteral(red: 0.137254902, green: 0.1490196078, blue: 0.168627451, alpha: 1))]),
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                            )

                        HStack {
                            Spacer()
                            Rectangle()
                                .frame(width: 2)
                                .foregroundColor(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)))
                            Spacer()
                        }
                        HStack(spacing: 0) {
                            Text("1")
                                .coffioTextStyle(.ratioLabel)
                                .frame(
                                    width: geo.size.width/2,
                                    height: geo.size.height
                                )

                            ZStack {
                                Text("\(self.viewStore.ratioDenominator, specifier: "%.0f")")
                                    .coffioTextStyle(.ratioLabel)
                                self.ratioDenominatorLine
                                    .frame(width: geo.size.width / 2 - 2)
                            }
                            .frame(
                                width: geo.size.width/2,
                                height: geo.size.height
                            )
                        }
                }
            }

            Text("RATIO: CLASSIC")
                .coffioTextStyle(.mainLabel)
        }
    }
}

struct Coffio: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 0) {
                RatioView(viewStore: viewStore)
                    .frame(height: 160)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 32)
                    .background(Color.coffioBackgroundDark)

                HStack {
                    CoffeeAmountView(viewStore: viewStore)
                    Spacer()
                    WaterAmountView(viewStore: viewStore)
                }
                .padding(.horizontal, 32)
                .padding(.vertical, 32)
                .background(Color.coffioBackgroundLight)

                UnitView(viewStore: viewStore)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 32)
                    .background(Color.coffioBackgroundDark)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct UnitView: View {
    @ObservedObject var viewStore: ViewStore<AppState, AppAction>
    @State private var toggleOffset: CGFloat = -100/2 + (42/2)

    var body: some View {
        VStack(spacing: 20) {
            Text("CONVERSION")
                .kerning(2)
                .coffioTextStyle(.miniLabel)
                .padding(.horizontal, 8)
                .background(Color.coffioBackgroundDark)
                .anchorPreference(
                    key: SelectionPreferenceKey.self,
                    value: .bounds,
                    transform: { $0 }
                )
                .backgroundPreferenceValue(SelectionPreferenceKey.self) { prefs in
                    GeometryReader { geometry in
                        prefs.map { value in
                            Path { path in
                                path.move(to: CGPoint(x: -40,
                                                      y: 16))
                                path.addLine(to: CGPoint(x: -40,
                                                         y: geometry[value].height/2))
                                path.addLine(to: CGPoint(x: geometry[value].width + 40,
                                                         y: geometry[value].height/2))
                                path.addLine(to: CGPoint(x: geometry[value].width + 40,
                                                         y: 16))
                            }
                            .stroke(Color.coffioGray, lineWidth: 1)
                        }
                    }
                }

            HStack(spacing: 30) {
                Text("\(UnitMass.grams.abbrString)")
                    .coffioTextStyle(.unitLabel)

                // Toggle
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), lineWidth: 2)
                        .frame(width: 100, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 24, style: .continuous)
                                .fill(Color.coffioBackgroundLight)
                                .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 4, x: 2, y: 2)
                        )
                        .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 4, x: 2, y: 2)

                    Circle()
                        .stroke(Color.coffioOrange, lineWidth: 2)
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient:
                                            Gradient(colors: [Color(#colorLiteral(red: 0.5568627451, green: 0.2, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0.8980392157, green: 0.3803921569, blue: 0, alpha: 1))]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color(#colorLiteral(red: 0.09411764706, green: 0.09803921569, blue: 0.1019607843, alpha: 1)), radius: 14, x: 4, y: 4)
                        )
                        .offset(x: self.viewStore.unit.toggleOffset)
                }
                .onTapGesture {
                    // TODO: - remove the animation for the digits
                    self.viewStore.send(.unitChanged, animation: Animation.timingCurve(0.75, 0.69, 0, 0.94))
                }





                Text("\(UnitMass.ounces.abbrString)")
                    .coffioTextStyle(.unitLabel)
            }

            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}

// MARK: - Previews

struct Coffio_Previews: PreviewProvider {
    static var previews: some View {
        Coffio(store: Store(initialState: AppState(),
                            reducer: appReducer,
                            environment: AppEnvironment()
        ))
    }
}











struct SelectionPreferenceKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? = nil
    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = nextValue()
    }
}


















// MARK: - SizePrefKey

struct SizePrefData: Equatable {
    let viewID: Int
    let bounds: CGRect
}

struct SizePrefKey: PreferenceKey {
    static var defaultValue: [SizePrefData] = []
    static func reduce(value: inout [SizePrefData], nextValue: () -> [SizePrefData]) {
        value.append(contentsOf: nextValue())
    }
}

extension View {
    public func saveSizes(viewID: Int, coordinateSpace: CoordinateSpace = .global) -> some View {
        /**
         Attach a geometry reader to a view as a background to read its size.

         Please see:
         https://swiftwithmajid.com/2020/01/15/the-magic-of-view-preferences-in-swiftui/
         https://swiftui-lab.com/view-extensions-for-better-code-readability/
        */
        background(GeometryReader { geo in
            Color.clear.preference(key: SizePrefKey.self,
                                   value: [SizePrefData(viewID: viewID, bounds: geo.frame(in: coordinateSpace))])
        })
    }

    public func retrieveSizes(viewID: Int, completion: @escaping (CGRect) -> Void) -> some View {
        onPreferenceChange(SizePrefKey.self) { preferences in
            DispatchQueue.main.async {
                // The async is used to prevent a possible blocking loop,
                // due to the child and the ancestor modifying each other.
                let p = preferences.first(where: { $0.viewID == viewID })
                completion(p?.bounds ?? .zero)
            }
        }
    }
}
