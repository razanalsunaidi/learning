import SwiftUI
import AVFoundation
import AudioToolbox

struct Memo: View {
    @State private var glowEffect = false
    @State private var isActive = false

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Black background
            
            if isActive {
                // Replace this with your main content view
                MainContentView()
            } else {
                VStack {
                    // Animated fire logo
                    Text("🔥")
                        .font(.system(size: 100))
                        .shadow(color: glowEffect ? Color.orange : Color.clear, radius: 10)
                        .scaleEffect(glowEffect ? 1.2 : 1.0)
                        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: glowEffect)
                        .onAppear {
                            glowEffect = true
                            playSound() // Play sound when the splash screen appears
                            // Timer to switch to the main content after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }
                    
                    // App name
                    Text("Learning Journey")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                        .padding(.top, 20)
                }
            }
        }
    }

    // Function to play the sound using AudioServices
    func playSound() {
        guard let soundURL = Bundle.main.url(forResource: "fire_sound", withExtension: "mp3") else {
            print("Sound file not found.")
            return
        }

        var soundID: SystemSoundID = 0
        let status = AudioServicesCreateSystemSoundID(soundURL as CFURL, &soundID)

        if status == kAudioServicesNoError {
            AudioServicesPlaySystemSound(soundID)
        } else {
            print("Error loading sound file.")
        }
    }
}

// Placeholder for your main content view
struct MainContentView: View {
    var body: some View {
        Text("Welcome to Learning Journey!")
            .font(.largeTitle)
            .foregroundColor(.black)
    }
}

#Preview {
    Memo()
}
