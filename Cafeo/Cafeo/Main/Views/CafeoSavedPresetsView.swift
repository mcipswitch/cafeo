//
//  CafeoSavedPresetsView.swift
//  Cafeo
//
//  Created by Priscilla Ip on 2021-07-17.
//

import ComposableArchitecture
import SwiftUI

struct CafeoSavedPresetsView: View {
    let store: Store<CafeoSavedPresetsDomain.State, CafeoSavedPresetsDomain.Action>
    var selectedPreset: CafeoPresetDomain.State?
    var newPresetSelected: (CafeoPresetDomain.State) -> Void

    @Environment(\.presentationMode) var presentation

    init(store: Store<CafeoSavedPresetsDomain.State, CafeoSavedPresetsDomain.Action>,
         selectedPreset: CafeoPresetDomain.State?,
         newPresetSelected: @escaping (CafeoPresetDomain.State) -> Void) {
        self.store = store
        self.selectedPreset = selectedPreset
        self.newPresetSelected = newPresetSelected

        // This is required to set up the list background color
        UITableView.appearance().backgroundColor = UIColor(.cafeoBackgroundDark)
    }

    @State var isEditing = false

    var body: some View {
        WithViewStore(self.store) { viewStore in
            List {
                Section(header: HeaderText(isEditing: self.$isEditing, text: "Saved presets".localized)) {
                    ForEachStore(
                        self.store.scope(
                            state: \.savedPresets,
                            action: CafeoSavedPresetsDomain.Action.presetAction(id:action:))) { presetStore in

                        // TODO: fix the isSelected bool
                        CafeoPresetLabel(store: presetStore, isSelected: self.selectedPreset == ViewStore(presetStore).state) {
                            self.presentation.wrappedValue.dismiss()
                            self.newPresetSelected($0)
                        }
                    }
                    .onMove { viewStore.send(.movePreset($0, $1)) }
                    .onDelete { viewStore.send(.deletePreset($0)) }
                }
            }
            .environment(\.editMode, .constant(self.isEditing ? .active : .inactive))
            .preferredColorScheme(.dark)
            .listStyle(GroupedListStyle())
        }
    }

    private struct HeaderText: View {
        @Binding var isEditing: Bool
        var text: String
        var body: some View {
            HStack {
                Text(self.text)
                    .kerning(.cafeo(.standard))
                    .cafeoText(.mainLabel, color: .cafeoGray)
                Spacer()
                Button(action: {
                    self.isEditing.toggle()
                }, label: {
                    Text("Edit".localized)
                        .kerning(.cafeo(.standard))
                        .cafeoText(.mainLabel, color: .cafeoGray)
                        .textCase(.uppercase)
                })
            }
            .padding(.vertical, .cafeo(.spacing16))
        }
    }

    private struct CafeoPresetLabel: View {
        let store: Store<CafeoPresetDomain.State, CafeoPresetDomain.Action>
        var isSelected: Bool
        var action: (CafeoPresetDomain.State) -> Void

        var body: some View {
            WithViewStore(self.store) { viewStore in
                Button(action: {
                    self.action(viewStore.state)
                }) {
                    HStack {
                        VStack(alignment: .leading, spacing: .cafeo(.spacing8)) {
                            Text(viewStore.name)
                                .kerning(.cafeo(.standard))
                                .cafeoText(.mainLabel, color: .cafeoGray)
                            Text("1/\(viewStore.settings.activeRatioIdx)")
                                .kerning(.cafeo(.standard))
                                .cafeoText(.mainLabel, color: .cafeoGray)
                        }
                        Spacer()
                        if self.isSelected {
                            Image(systemName: "checkmark")
                                .cafeoText(.mainLabel, color: .cafeoOrange)
                        }
                    }
                }
                .listRowBackground(Color.cafeoBackgroundDark)
            }
        }
    }
}
