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
                    .frame(height: 180)
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

                // START: - Unit View
                VStack(spacing: 32) {
                    ZStack {
                        Text("CONVERSION")
                            .kerning(2)
                            .coffioTextStyle(.miniLabel)

                        Path { path in
                            path.move(to: CGPoint(x: 0, y: 0))
                            path.addLine(to: CGPoint(x: 200, y: 0))
                            path.addLine(to: CGPoint(x: 200, y: 20))
                        }
                        .stroke(Color.coffioBackgroundLight, lineWidth: 1)
                    }

                    // TOGGLE
                    HStack(spacing: 30) {
                        Text("\(UnitMass.grams.abbrString)")
                            .coffioTextStyle(.unitLabel)

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
                                .offset(x: -100/2 + (42/2))
                        }

                        Text("\(UnitMass.ounces.abbrString)")
                            .coffioTextStyle(.unitLabel)
                    }

                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 32)
                .background(Color.coffioBackgroundDark)
            }
            .edgesIgnoringSafeArea(.all)
        }
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

// MARK: - View + Extension

extension View {
    func inverseMask<Mask>(_ mask: Mask) -> some View where Mask: View {
        self.mask(
            mask
                .foregroundColor(.black)
                .background(Color.white)
                .compositingGroup()
                .luminanceToAlpha()
        )
    }
    
    func coffioTextStyle(_ textStyle: CoffioTextStyle) -> some View {
        return self.modifier(CoffioText(textStyle))
    }
}


// MARK: - Font+Extensions

extension Font {
    
    static func orbitronMediumFont(size: CGFloat) -> Font {
        return Font.custom("Orbitron-Medium", fixedSize: size)
    }
    
    static func exo2MediumItalicFont(size: CGFloat) -> Font {
        return Font.custom("Exo2-MediumItalic", fixedSize: size)
    }
    
    static func exo2SemiBoldItalicFont(size: CGFloat) -> Font {
        return Font.custom("Exo2-SemiBold", fixedSize: size)
    }
}

enum CoffioTextStyle {
    case mainLabel
    case digitalLabel
    case ratioLabel
    case unitLabel
    case miniLabel
    
    var font: Font {
        switch self {
        case .mainLabel:
            return .exo2MediumItalicFont(size: 16)
        case .digitalLabel:
            return .orbitronMediumFont(size: 48)
        case .ratioLabel:
            return .orbitronMediumFont(size: 50)
        case .unitLabel:
            return .exo2SemiBoldItalicFont(size: 16)
        case .miniLabel:
            return .exo2MediumItalicFont(size: 12)
        }
    }
    
    var color: Color {
        switch self {
        case .mainLabel:
            return .coffioGray
        case .digitalLabel:
            return .coffioBeige
        case .ratioLabel:
            return .coffioBeige
        case .unitLabel:
            return .coffioGray
        case .miniLabel:
            return .coffioGray
        }
    }
}

struct CoffioText: ViewModifier {
    var textStyle: CoffioTextStyle
    
    init(_ textStyle: CoffioTextStyle) {
        self.textStyle = textStyle
    }
    
    func body(content: Content) -> some View {
        content
            .font(textStyle.font)
            .foregroundColor(textStyle.color)
    }
}
