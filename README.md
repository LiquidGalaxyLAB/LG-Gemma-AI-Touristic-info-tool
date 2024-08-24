# AI Touristic Information Tool for Liquid Galaxy

</br>

![App Screenshot](https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/images/appLogo-Gemini.png?raw=true)

<br>

## Table of Contents
- [About](#about)
- [Main Features and Functionalities](#main-features-and-functionalities)
- [Requirements](#requirements)
  - [Device Compatibility](#device-compatibility)
  - [Liquid Galaxy Integration (Optional)](#liquid-galaxy-integration-optional)
  - [Gemini API Key](#gemini-api-key)
  - [Gemma Docker Installation (Optional)](#gemma-docker-installation-optional)
  - [YouTube API Key](#youtube-api-key)
  - [Deepgram API Key](#deepgram-api-key)
- [Building from Source](#building-from-source)
  - [General for both Gemma and Gemini](#general-for-both-gemma-and-gemini)
  - [Using Gemma Codebase](#using-gemma-instead-of-gemini)
  - [Using Gemini Codebase](#using-gemini)
- [User Guide](#user-guide)
- [Enhancement and Future Plans](#enhancement-and-future-plans)
- [Technical Documentation](#technical-documentation)
- [Contributors](#contributors)

---

## About

The **AI Touristic Information Tool for Liquid Galaxy** is a Flutter-based Android tablet application that simplifies and enhances travel planning by helping users discover personalized points of interest worldwide. Whether you're searching for popular tourist attractions, dining options, or shopping locations nearby or across the globe, the app leverages the power of Generative AI through Google’s Gemma and Gemini models to provide tailored recommendations.

With Liquid Galaxy technology, users can visualize their entire trip across multiple screens, creating an immersive panoramic experience. The app seamlessly synchronizes maps between the Liquid Galaxy rig and the application via Google Maps. Additionally, it can operate as a standalone tool, offering tours and POIs based on AI-generated data.

---

## Main Features and Functionalities

- 🌍 **Global Exploration**: Discover activities and destinations around the world with ease.
  
- 📍 **Local Discovery**: Find nearby attractions by entering a specific location or using your current location through integrated Google Maps.
  
- 🤖 **AI-Powered Information**: Get personalized points of interest (POIs) powered by Google’s Gemini API, complete with detailed information tailored to your preferences.
  
- 📌 **POI Insights**: Explore various points of interest within a generated or customized tour, with additional information displayed on Google Maps and Google Earth through balloons and info windows.
  
- 🔍 **Deep Dive**: Access more details about each POI with top 10 website results and YouTube links for comprehensive information.
  
- 🌌 **Immersive Visuals**: Experience the panoramic display of the Liquid Galaxy rig, visualizing tours, orbits, and KML balloons across multiple synchronized screens.
  
- 🖥️ **Liquid Galaxy System Control**: Manage the Liquid Galaxy system through SSH, including relaunching, restarting, shutting down, and more, for an enhanced visualization experience.
  
- 🎯 **Tailored Tours**: Customize your own tours by selecting your favorite points from AI-generated recommendations for a personalized adventure.
  
- 📚 **In-App Tutorials**: Navigate the app with ease using intuitive in-app tutorials designed to enhance your experience.
  
- ✨ **Personalized Experience**: Adapt the app settings to your preferences, from font size and themes to selecting one of 8 supported languages.
  
- 🔄 **Real-Time Responses**: Enjoy a smooth experience with AI-generated responses presented in real-time stream mode.
  
- ⭐ **Save Your Favorites**: Keep your favorite tours and POIs easily accessible for future exploration and customization.
  
- 🎙️ **Voice Interaction**: Record your questions or listen to AI-narrated tours for an interactive experience.

---

## Requirements 

### Device Compatibility
- The application requires an Android tablet running Android 13 (API level 33) or higher.

### Liquid Galaxy Integration (Optional)
- To fully utilize the Liquid Galaxy features, ensure that the Liquid Galaxy core is installed. For detailed installation instructions, please refer to the [Liquid Galaxy repository](https://github.com/LiquidGalaxyLAB) and check the [training video done by me](https://youtu.be/jz-QZi__10c?si=SjxrbuDSZQXv6kRl) for more information.

### Gemini API Key
- You can go to the [Google AI Studio](https://ai.google.dev/aistudio) and click on "Get a Gemini API key" to create your own API key.

### Gemma Docker Installation (Optional)
- To run a Docker container for using the Gemma model locally, follow the [Docker guide]().
- Once the container is running, you can interact with the model through the terminal using the following CURL command. Replace "your_input_here" with your desired query:

```bash
curl -X POST http://localhost:8085/rag/stream_events \
  -H "Content-Type: application/json" \
  -H "Accept: text/event-stream" \
  -d '{"input": "your_input_value_here"}'
```

### YouTube API Key:
- You can get your own Youtube API key by following the guide from [here](https://developers.google.com/youtube/v3/getting-started)

### Deepgram API Key:
- You can get your own Deepgram API key from [here](https://console.deepgram.com/)

---

## Building From Source:

### General for both Gemma and Gemini

To build the app from source, follow these steps:

1. Clone the repository by opening a new terminal and running:
    ```bash
    git clone https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool.git
    ```

2. Set up a Google Maps API key:
    - Obtain a Google Maps API Key by following the instructions [here](#link-to-google-maps-api-instructions).
    - Navigate to the `android/app/main` directory within the cloned repository.
    - Open the `AndroidManifest.xml` file in a text editor.
    - Locate and update the following section where you replace "GMP_KEY" with your own Key:
      ```xml
      <meta-data android:name="com.google.android.geo.API_KEY"
          android:value="GMP_Key"/>
      ```

3. Run the application:
    - Navigate to the project directory:
      ```bash
      cd LG-Gemma-AI-Touristic-info-tool/ai_touristic_info_tool
      ```
    - Install the necessary dependencies:
      ```bash
      flutter pub get
      ```
    - Launch the app:
      ```bash
      flutter run
      ```
> **Important**: Ensure you have a tablet device connected or an Android tablet emulator running before executing the `flutter run` command.

## Using Gemma Instead of Gemini

1. Follow the Docker guide for installation and running the container [here]().

2. If you want to use Gemma instead of Gemini:
    - Switch to the `gemma_app` branch:
      ```bash
      git checkout gemma-app
      ```
    - Configure your IP address and port:
        - For a real device, use your computer's IP address.
        - For an emulator, use `10.0.2.2`.
        - The port should be `8085`.
          
     <br>

<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724506294.png" alt="Connection AI image" width="800"/>

          
> **Important**: Ensure that the Gemma app server is running through Docker and check for the appropriate server status message before using the Flutter app as shown:

<br>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20163052.png" alt="Server running" width="800"/>


## Using Gemini

1. For Gemini, use the `main` branch:
    ```bash
    git checkout main
    ```

2. Obtain a Gemini API key from [here](https://ai.google.dev/aistudio).

3. Enter your credentials in the API key settings section in the app and set as default.
   
   <br>

<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492641.png?raw=true" alt="Gemini APi Key" width="800"/>

 

## User Guide

1. You can download the app from the [Play Store]() or get the APK [here]().


# Enhancement and Future Plans

While the main features are complete, future enhancements may include:
- Adding a chat function for users to inquire about specific places.
- Leveraging Gemini’s multimodality to allow users to upload images for location-based insights.

# Technical Documentation

For more detailed technical information, please refer to the [Wiki]().

# Contributors

This project was initiated as a Google Summer of Code 2024 project with Liquid Galaxy Org. The project was developed by:

- **Mahinour Elsarky**: Project Developer and GSoC 2024 contributor
- **Claudia Diosan**: Mentor
- **Andreu Ibañez**: Liquid Galaxy Org. Admin


