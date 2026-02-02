
import SwiftUI


struct ScreenRecordingGuard<Content: View>: View {

    let message: String
    let content: Content

    @State private var isRecording = UIScreen.isRecording

    init(
        message: String,
        @ViewBuilder content: () -> Content
    ) {
        self.message = message
        self.content = content()
    }

    var body: some View {
        ZStack {
            if isRecording {
                if #available(iOS 17.0, *) {
                    ContentUnavailableView(
                        "Not Allowed",
                        systemImage: "video.slash",
                        description: Text(message)
                    )
                } else {
                    Color.black
                        .overlay(
                            Text(message)
                                .foregroundColor(.white)
                        )
                }
            } else {
                content
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIScreen.capturedDidChangeNotification,
                object: nil,
                queue: .main
            ) { _ in
                isRecording = UIScreen.isRecording
            }
        }
    }
}
