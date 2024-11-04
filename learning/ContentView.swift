import SwiftUI
import Combine
import AVFoundation // Import AVFoundation for audio playback


//-------------------------------
class UserInputModel: ObservableObject {
    @Published var userInput: String = ""
}
//-------------------------------

// ViewModel
class MainViewModel: ObservableObject {
    @Published var userInputModel = UserInputModel()
    @Published var selectedOption: String? = nil
    @Published var isActive = false
    @Published var showTestSwift = false

    var isStartButtonEnabled: Bool {
        !userInputModel.userInput.isEmpty && selectedOption != nil // Check the user input from the model
    }
}
//-------------------------------

// Main Content View
struct ContentView: View {
    @StateObject private var viewModel = MainViewModel() // Create an instance of the ViewModel

    var body: some View {
        ZStack {
            // Splash Screen
            if !viewModel.isActive {
                SplashScreen(isActive: $viewModel.isActive)
            } else if viewModel.showTestSwift {
                TestSwift(userInputModel: viewModel.userInputModel) // Show TestSwift
            } else {
                mainContentView
            }
        }
    }
//-------------------------------

    // Main content view
    private var mainContentView: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack {
                ZStack {
                    Circle()
                        .fill(Color("greyBG"))
                        .frame(width: 150, height: 150)
                    Text("🔥")
                        .font(.system(size: 70))
                }

                VStack(alignment: .leading) {
                    Text("Hello Learner!")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .bold()
                    Text("This app will help you learn every day")
                        .foregroundColor(Color("greyBG"))

                    Text("I want to learn")
                        .foregroundColor(.white)

                    // TextField for user input
                    HStack {
                        TextField("Enter your text here", text: $viewModel.userInputModel.userInput) // Bind to userInputModel
                            .textFieldStyle(PlainTextFieldStyle())
                            .background(Color.black)
                            .foregroundColor(.white)
                            .accentColor(Color("orangeBG"))
                            .padding(.bottom, 5)
                            .frame(maxWidth: .infinity) // Allow the text field to expand
                            .lineLimit(1) // Ensures single line input
                            .font(.system(size: calculateFontSize(for: viewModel.userInputModel.userInput))) // Dynamically calculated font size
                            .minimumScaleFactor(0.5) // Allows text to scale down if needed
                            .padding(10) // Add padding for better touch targets
                    }

                    Divider()
                        .background(Color("greyBG"))
                        .frame(height: 2)

                    Text("I want to learn it in a")
                        .foregroundColor(.white)

                    // Radio buttons section
                    HStack(spacing: 20) {
                        RadioButton(title: "Week", selectedOption: $viewModel.selectedOption)
                        RadioButton(title: "Month", selectedOption: $viewModel.selectedOption)
                        RadioButton(title: "Year", selectedOption: $viewModel.selectedOption)
                    }

                    // Centered Start button
                    HStack {
                        Spacer() // Pushes the button to the center
                        Button(action: {
                            viewModel.showTestSwift = true // Show TestSwift when clicked
                        }) {
                            Text("Start →")
                                .bold()
                                .padding()
                                .frame(width: 150)
                                .background(viewModel.isStartButtonEnabled ? Color("orangeBG") : Color("greyBG"))
                                .foregroundColor(viewModel.isStartButtonEnabled ? .black : .gray)
                                .cornerRadius(5) // Rounded corners
                        }
                        .disabled(!viewModel.isStartButtonEnabled) // Disable button if conditions are not met
                        Spacer() // Pushes the button to the center
                    }
                    .padding(.top, 20) // Add some space above the button
                }
                .padding()
            }
        }
    }
    
//-------------------------------
    
    // Function to calculate font size based on input length
    private func calculateFontSize(for text: String) -> CGFloat {
        let baseSize: CGFloat = 20 // Base font size
        let maxTextLength: CGFloat = 30 // Maximum length before scaling down
        let textLength = CGFloat(text.count)
        
        // Scale the font down based on the length of the text
        if textLength > maxTextLength {
            return max(baseSize * (maxTextLength / textLength), 10) // Ensure a minimum font size
        }
        
        return baseSize // Return base size if within limit
    }
}

//-------------------------------

// Splash Screen View
struct SplashScreen: View {
    @Binding var isActive: Bool
    @State private var glowEffect = false
    @State private var audioPlayer: AVAudioPlayer? // Declare audio player
    
//-------------------------------
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all) // Black background
            
            if !isActive {
                VStack {
                    // Animated fire logo
                    Text("🔥")
                        .font(.system(size: 100))
                        .shadow(color: glowEffect ? Color.orange : Color.clear, radius: 10)
                        .scaleEffect(glowEffect ? 1.2 : 1.0)
                        .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true), value: glowEffect)
                        .onAppear {
                            glowEffect = true
                            playSound() // Play sound when the view appears
                            // Timer to switch to the main content after 2 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation {
                                    isActive = true
                                }
                            }
                        }
                        .padding(20)

                    // App name
                    Text("Learning Journey")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                }
            }
        }
    }
    
//-------------------------------
    
    // Function to play sound
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "260555__lookimadeathing__basic-fire-whoosh-2", withExtension: "flac") else {
            print("Sound file not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

//-------------------------------

// Radio Button View
struct RadioButton: View {
    let title: String
    @Binding var selectedOption: String?

    var body: some View {
        Button(action: {
            selectedOption = title
        }) {
            Text(title)
                .padding()
                .frame(maxWidth: .infinity) // Make the button full width
                .background(selectedOption == title ? Color("orangeBG") : Color("greyBG")) // Set the background color
                .foregroundColor(selectedOption == title ? .black : .orange) // Set text color
                .cornerRadius(5) // Rounded corners
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
#Preview {
    ContentView()
}
