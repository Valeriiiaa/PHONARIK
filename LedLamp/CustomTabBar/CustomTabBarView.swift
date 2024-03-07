//
//  CustomTabBarView.swift
//  LedLamp
//
//  Created by Kyrylo Chernov on 06.03.2024.
//

import SwiftUI
import AxisTabView

struct MainViewRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        return view!
    }
}

struct RoomsViewRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = UIStoryboard(name: "Rooms", bundle: nil).instantiateInitialViewController()!
        return view
    }
}

struct MusicViewRepresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let view = UIStoryboard(name: "MusicPlayer", bundle: nil).instantiateInitialViewController()!
        return view
    }
}

struct CustomTabBarView: View {
    @State private var selection: Int = 0
    @State private var constant = ATConstant(axisMode: .bottom, screen: .init(activeSafeArea: false, transitionMode: .none), tab: .init(normalSize: CGSize(width: 64, height: 80), spacingMode: .center, spacing: 24))
    @State private var color: Color = Color(uiColor: UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 0.26))
    
    var body: some View {
        GeometryReader { proxy in
            Image(.mainBackground)
                .resizable()
                .aspectRatio(contentMode: .fill)
            AxisTabView(selection: $selection, constant: constant) { state in
                ATCapsuleStyle(state, color: color, horizontalSpacing: 61)
            } content: {
                MainViewWprapper(selection: $selection, constant: $constant, tag: 0, systemName: "01.circle.fill", safeArea: proxy.safeAreaInsets)
                RoomsViewWprapper(selection: $selection, constant: $constant, tag: 1, systemName: "02.circle.fill", safeArea: proxy.safeAreaInsets)
                MusicViewWprapper(selection: $selection, constant: $constant, tag: 3, systemName: "03.circle.fill", safeArea: proxy.safeAreaInsets)
            } onTapReceive: { selectionTap in
                /// Imperative syntax
                print("---------------------")
                print("Selection : ", selectionTap)
                print("Already selected : ", self.selection == selectionTap)
            }
        }
        .animation(.easeInOut, value: constant)
        .navigationTitle("Screen \(selection + 1)")
    }
}


struct RoomsViewWprapper: View {
    @Binding var selection: Int
    @Binding var constant: ATConstant
    
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets
    
    var body: some View {
        RoomsViewRepresentable()
            .ignoresSafeArea(.all)
            .padding(.bottom, getBottomPadding())
            .tabItem(tag: tag, normal: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: false, title: "rooms".localized, image: .roomsTabBar)
            }, select: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: true, title: "rooms".localized, image: .roomsTabBar)
            })
    }
    
    private func getTopPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .top ? constant.tab.normalSize.height + safeArea.top : 0
    }
    
    private func getBottomPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .bottom ? constant.tab.normalSize.height + safeArea.bottom : 0
    }
}

struct MusicViewWprapper: View {
    @Binding var selection: Int
    @Binding var constant: ATConstant
    
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets
    
    var body: some View {
        MusicViewRepresentable()
            .ignoresSafeArea(.all)
            .padding(.bottom, getBottomPadding())
            .tabItem(tag: tag, normal: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: false, title: "music".localized, image: .musicTabBar)
            }, select: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: true, title: "music".localized, image: .musicTabBar)
            })
        
    }
    
    private func getTopPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .top ? constant.tab.normalSize.height + safeArea.top : 0
    }
    
    private func getBottomPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .bottom ? constant.tab.normalSize.height + safeArea.bottom : 0
    }
}

struct MainViewWprapper: View {
    @Binding var selection: Int
    @Binding var constant: ATConstant
    
    let tag: Int
    let systemName: String
    let safeArea: EdgeInsets
    
    var body: some View {
        MainViewRepresentable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(2)
            .ignoresSafeArea(.all)
            .padding(.bottom, getBottomPadding())
            .tabItem(tag: tag, normal: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: false, title: "light".localized, image: .lightTabBar)
            }, select: {
                TabButton(constant: $constant, selection: $selection, tag: tag, isSelection: true, title: "light".localized, image: .lightTabBar)
            })
        
    }
    
    private func getTopPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .top ? constant.tab.normalSize.height + safeArea.top : 0
    }
    
    private func getBottomPadding() -> CGFloat {
        guard !constant.screen.activeSafeArea else { return 0 }
        return constant.axisMode == .bottom ? constant.tab.normalSize.height + safeArea.bottom : 0
    }
}

struct TabButton: View {
    
    @Binding var constant: ATConstant
    @Binding var selection: Int
    
    let tag: Int
    let isSelection: Bool
    let title: String
    let image: ImageResource
    
    let selectionColor = Color(uiColor: UIColor(red: 231 / 255, green: 254 / 255, blue: 85 / 255, alpha: 1))
    let unselectionColor = Color.clear
    
    let unselectedContentColor = Color(uiColor: UIColor(red: 231 / 255, green: 231 / 255, blue: 231 / 255, alpha: 1))
    let selectedContentColor = Color(uiColor: UIColor(red: 34 / 255, green: 34 / 255, blue: 34 / 255, alpha: 1))

    @State private var w: CGFloat = 0
    
    var content: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 4) {
                Image(image)
                    .renderingMode(.template)
                Text(title)
                    .font(.system(size: 12))
            }

        }
        .frame(width: 64, height: 64)
        .foregroundStyle(isSelection ? selectedContentColor : unselectedContentColor)
        .background(isSelection ? selectionColor : unselectionColor)
        .clipShape(Capsule())
        .onAppear {
            w = constant.tab.normalSize.width
            if isSelection {
                withAnimation(.easeInOut(duration: 0.26)) {
                    w = constant.tab.selectWidth < 0 ? constant.tab.normalSize.width : constant.tab.selectWidth + 5
                }
                withAnimation(.easeInOut(duration: 0.3).delay(0.25)) {
                    w = constant.tab.selectWidth < 0 ? constant.tab.normalSize.width : constant.tab.selectWidth
                }
            }else {
                w = constant.tab.normalSize.width
            }
        }
    }
    var body: some View {
        if constant.axisMode == .top {
            content
        }else {
            content
        }
    }
}
