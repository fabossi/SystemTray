//
//  TrayHelper.swift
//  SystemTray
//
//  Created by Felipe Fabossi on 18/03/25.
//

import SwiftUI

struct TrayConfig {
    var maxDent: PresentationDetent
    var cornerRadius: CGFloat = 30
    var isIntercativeDismissDisabled: Bool = false
    var horizonalPadding: CGFloat = 15
    var bottomPadding: CGFloat = 15
}

extension View {
    
    @ViewBuilder
    func systemTrayView
    <Content: View>(_ show: Binding<Bool>,
                                    config: TrayConfig = .init(maxDent: .fraction(0.99)),
                                       @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self
            .sheet(isPresented: show) {
                content()
                    .background(.bg)
                    .clipShape(.rect(cornerRadius: config.cornerRadius))
                    .padding([.horizontal, .bottom], 15)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .padding(.horizontal, config.horizonalPadding)
                    .padding(.bottom, config.bottomPadding)
                // Presentation Configuration
                    .presentationDetents([config.maxDent])
                    .presentationCornerRadius(0)
                    .presentationBackground(.clear)
                    .presentationDragIndicator(.hidden)
                    .interactiveDismissDisabled(config.isIntercativeDismissDisabled)
                    .background(RemoveSheetShadow())
            }
    }
}

fileprivate struct RemoveSheetShadow: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        
        DispatchQueue.main.async {
            if let shadowView = view.dropShadowView {
                shadowView.layer.shadowColor = UIColor.clear.cgColor
            }
        }
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

extension UIView {
    var dropShadowView: UIView? {
        if let superview, String(describing: type(of: superview)) == "UIDropShadowView" {
            return superview
        }
        return superview?.dropShadowView
    }
}
