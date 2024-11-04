# Learning Journey App 🔥

The **Learning Journey** app is designed to help users track their learning goals and habits. It features a splash screen, a main content view for inputting learning objectives, and a goal editing screen. The application utilizes SwiftUI and the MVVM (Model-View-ViewModel) design pattern for better separation of concerns.

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Code Overview](#code-overview)
  - [Main View and Splash Screen](#main-view-and-splash-screen)
  - [Learning Tracker View](#learning-tracker-view)
  - [Goal Editing View](#goal-editing-view)
  - [The Interfaces Of The App](#The-Interfaces-Of-The-App)

## Features

- User input for learning goals.
- Dynamic learning tracker with a calendar view.
- Ability to log learning days and freeze days.
- A splash screen with sound effects.
- Goal editing functionality.

## Installation

To get started with the Learning Journey app, clone this repository:
https://github.com/razanalsunaidi/learning.git

Open the project in Xcode and run it on a simulator or a physical device.

## Usage
Splash Screen: The app starts with an animated splash screen.
Main Content: Input your learning goal and select a duration (Week, Month, Year). Click "Start" to proceed to the learning tracker.
Learning Tracker: Track your learning progress, log your learning days, and freeze days as needed.
Edit Goal: Update your learning goals and durations.

## Code Overview

Main View and Splash Screen
User Input Model: Manages the user's input.
Main ViewModel: Controls the app's state and navigation.
ContentView: Displays the splash screen and main content based on user interactions.
Splash Screen: Features an animated logo and plays sound effects during initialization.

## Learning Tracker View

TestSwift ViewModel: Manages the learning progress and current date.
TestSwift View: Displays the current day, a calendar for selecting learning days, and buttons for logging actions.

## Goal Editing View

EditGoal ViewModel: Handles updating the user's learning goals.
EditGoal View: Provides input fields for setting and updating goals with duration options.

## The Interfaces Of The App
<img width="313" alt="Screenshot 1446-05-02 at 2 36 37 PM" src="https://github.com/user-attachments/assets/9a4bd930-2a78-44f1-b546-d172a5434447">
<img width="325" alt="Screenshot 1446-05-02 at 2 37 24 PM" src="https://github.com/user-attachments/assets/6c972d1f-42aa-44d6-8d61-ddb210a26b90">
<img width="317" alt="Screenshot 1446-05-02 at 2 38 12 PM" src="https://github.com/user-attachments/assets/b8f168b3-bb26-4ecf-bcc4-b052b201ad0a">
