

import SwiftUI


struct ScreenShotPreventerMask: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        
        let view = UITextField()
        
        view.isSecureTextEntry = true
        
        view.text = ""
        
        view.isUserInteractionEnabled = false
        
        if let autoHideLayer = findAutoHideLayer(view: view) {
            autoHideLayer.backgroundColor = UIColor.white.cgColor
        } else {
            /// Fall Back
            view.layer.sublayers?.last?.backgroundColor = UIColor.white.cgColor }
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    func findAutoHideLayer(view: UIView) -> CALayer? {
        if let layers = view.layer.sublayers {
            
            if let layer = layers.first(where: { layer in layer.delegate.debugDescription.contains("UITextLayoutCanvasView")                 
            }) {
                return layer
            }
        }
        return nil
        
    }
}
extension UIScreen {
    static var isRecording: Bool {
        UIScreen.main.isCaptured
    }
}

extension View {
    
    @ViewBuilder
    func screenProtection(
        enabled: Bool,
        message: String = "Screen recording or screenshots are not allowed"
    ) -> some View {
        
        if enabled {
            ScreenRecordingGuard(message: message) {
                self
                    .mask {
                        ScreenShotPreventerMask()
                            .ignoresSafeArea()
                    }
            }
        } else {
            self
        }
    }
}

