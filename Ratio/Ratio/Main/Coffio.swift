//
//  Coffio.swift
//  Ratio
//
//  Created by Priscilla Ip on 2021-03-08.
//

import ComposableArchitecture
import SwiftUI

struct Coffio: View {
    let store: Store<AppState, AppAction>

    var body: some View {
        WithViewStore(self.store) { viewStore in
            VStack(spacing: 0) {

                // START: - RatioView
                VStack(spacing: 24) {
                    // Ratio Screen
                    HStack(spacing: 0) {
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
                                        .font(Font.custom("Orbitron-Medium", fixedSize: 56))
                                        .foregroundColor(.coffioBeige)
                                        .frame(
                                            width: geo.size.width/2,
                                            height: geo.size.height
                                        )

                                    ZStack {
                                        Text("\(viewStore.ratioDenominator, specifier: "%.0f")")
                                            .font(Font.custom("Orbitron-Medium", fixedSize: 56))
                                            .foregroundColor(.coffioBeige)
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(.coffioOrange)
                                            .shadow(color: .coffioBackgroundDark, radius: 4, x: 4, y: 4)
                                    }
                                    .frame(
                                        width: geo.size.width/2,
                                        height: geo.size.height
                                    )
                                }
                            }
                        }
                    }
                    .frame(height: 128)




                    Text("RATIO: CLASSIC")
                        .font(Font.custom("Exo2-MediumItalic", fixedSize: 16))
                        .foregroundColor(.coffioGray)
                        .padding(.bottom, 16)
                }
                .padding()
                .background(Color.coffioBackgroundDark)
                // END: - RatioView





                HStack {
                    VStack(spacing: 36) {
                        Text("COFFEE")
                            .font(Font.custom("Exo2-MediumItalic", fixedSize: 16))
                            .foregroundColor(.coffioGray)

                        // Coffee amount
                        VStack(spacing: 8) {
                            Text("\(viewStore.coffeeAmount, specifier: "%.1f")")
                                .font(Font.custom("Orbitron-Medium", fixedSize: 48))
                                .foregroundColor(.coffioBeige)

                            // Coffee buttons
                            ZStack {
                                // Gradient Bevel
                                Rectangle()
                                    .overlay(
                                        LinearGradient(
                                            gradient:
                                                Gradient(colors: [.coffioBackgroundDark, Color(#colorLiteral(red: 0.1960784314, green: 0.2117647059, blue: 0.231372549, alpha: 1))]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .clipShape(RoundedRectangle(cornerRadius: 30))
                                    .shadow(color: Color(#colorLiteral(red: 0.2470588235, green: 0.262745098, blue: 0.2901960784, alpha: 1)), radius: 14, x: -4, y: -4)
                                    .shadow(color: Color(#colorLiteral(red: 0.01568627451, green: 0.01568627451, blue: 0.01568627451, alpha: 1)), radius: 14, x: 4, y: 4)

                                Rectangle()
                                    .clipShape(RoundedRectangle(cornerRadius: 26))
                                    .foregroundColor(.coffioBackgroundLight)
                                    .frame(width: 142, height: 52)
                                HStack {
                                    Image(systemName: "minus")
                                        .onTapGesture {
                                            viewStore.send(.coffeeDecrementButtonTapped)
                                        }
                                    Spacer()
                                    Image(systemName: "plus")
                                        .onTapGesture {
                                            viewStore.send(.coffeeIncrementButtonTapped)
                                        }
                                }
                                .font(Font.custom("Orbitron-Medium", fixedSize: 20))
                                .foregroundColor(.coffioGray)
                                .padding(.horizontal, 24)
                            }
                            .frame(width: 150, height: 60)





                        }

                        // LOCK
                        Toggle("", isOn: viewStore.binding(
                            keyPath: \.lockCoffeeAmount,
                            send: AppAction.form
                        ))
                        .labelsHidden()
                        .toggleStyle(LockToggleStyle())
                    }
                    .padding()

                    VStack(spacing: 36) {
                        Text("WATER")
                            .font(Font.custom("Exo2-MediumItalic", fixedSize: 16))
                            .foregroundColor(.coffioGray)

                        VStack(spacing: 8) {
                            Text("\(viewStore.waterAmount, specifier: "%.0f")")
                                .font(Font.custom("Orbitron-Medium", fixedSize: 52))
                                .foregroundColor(.coffioBeige)

                            ZStack {
                                RoundedRectangle(cornerRadius: 30)
                                HStack {
                                    Image(systemName: "minus")
                                        .onTapGesture {
                                            viewStore.send(.waterDecrementButtonTapped)
                                        }
                                    Spacer()
                                    Image(systemName: "plus")
                                        .onTapGesture {
                                            viewStore.send(.waterIncrementButtonTapped)
                                        }
                                }
                                .font(Font.custom("Orbitron-Medium", fixedSize: 20))
                                .foregroundColor(.coffioGray)
                                .padding(.horizontal, 24)
                            }
                            .frame(height: 60)
                        }

                        // LOCK - WATER
                        Toggle("", isOn: viewStore.binding(
                            keyPath: \.lockWaterAmount,
                            send: AppAction.form
                        ))
                        .labelsHidden()
                        .toggleStyle(LockToggleStyle())
                    }
                    .padding()
                }
                .background(Color.coffioBackgroundLight)








                // START: - Unit View
                VStack {
                    Text("CONVERSION")
                        .font(Font.custom("Exo2-MediumItalic", fixedSize: 16))
                        .foregroundColor(.coffioGray)
                        .padding(.bottom, 16)


                    // TOGGLE
                    Circle()
                        .fill(Color.coffioOrange)
                }
                .padding()
                .background(Color.coffioBackgroundDark)
                // END: - Unit View
            }
            .ignoresSafeArea(.all)
        }
    }
}

struct RatioView: View {
    var body: some View {
        Rectangle()
            .background(Color.coffioBackgroundDark)
    }
}

//struct AmountView: View {
//    var body: some View {
//    }
//}

struct ConversionView: View {
    var body: some View {
        Rectangle()
            .background(Color.coffioBackgroundDark)
    }
}




//Orbitron-Medium

extension Color {
    public static let coffioBackgroundDark = Color(#colorLiteral(red: 0.1215686275, green: 0.1254901961, blue: 0.1450980392, alpha: 1))
    public static let coffioBackgroundLight = Color(#colorLiteral(red: 0.1568627451, green: 0.1725490196, blue: 0.2, alpha: 1))
    public static let coffioBeige = Color(#colorLiteral(red: 0.7411764706, green: 0.7333333333, blue: 0.5882352941, alpha: 1))
    public static let coffioGray = Color(#colorLiteral(red: 0.5647058824, green: 0.5803921569, blue: 0.6274509804, alpha: 1))
    public static let coffioOrange = Color(#colorLiteral(red: 0.8980392157, green: 0.3607843137, blue: 0, alpha: 1))
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
