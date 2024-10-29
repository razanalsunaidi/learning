import SwiftUI
import Combine

class UserInputModel: ObservableObject {
@Published var userInput: String = ""
}
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
                TextField("Enter your text here", text: $viewModel.userInputModel.userInput) // Bind to userInputModel
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(Color.black)
                    .foregroundColor(.white)
                    .accentColor(Color("orangeBG"))
                    .padding(.bottom, 5)
                
                // Custom underline
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
}
// Splash Screen View
struct SplashScreen: View {
@Binding var isActive: Bool
@State private var glowEffect = false

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
}
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
