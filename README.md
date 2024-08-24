# AI Touristic Information Tool for Liquid Galaxy

</br>

![App Screenshot](https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/images/appLogo-Gemini.png?raw=true)

<br>

## Table of Contents
- [About](#about)
- [Main Features and Functionalities](#main-features-and-functionalities)
- [Technologies Used](#technologies-used)
- [Prerequisites](#prerequisites)
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
- [Usage](#usage)
- [App Screenshots](#app-screenshots)
- [Enhancement and Future Plans](#enhancement-and-future-plans)
- [Technical Documentation](#technical-documentation)
- [Contribution](#contribution)
- [Project Info](#project-info)

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

## Technologies Used
- Flutter & Dart
- Langchain
- Ollama
- Web-Scraping
- Python
- Fast API & Langserve
- Docker
- Gemini API
- Gemma Google Generative AI model
- (KML) Keyhole Markup Language
- Google Maps
- Google Earth
- Liquid Galaxy
- Virtual Box and (CLI) Linux Commands

---

## Prerequisites 

### Device Compatibility
- The application requires an Android tablet running Android 13 (API level 33) or higher.
- The tablet has to be a 10 inch android tablet.

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

 

## Usage

1. **Downloading the app**

You can download the app from the [Play Store]() or download the [APK]().
  
2. **Set up**

Make sure you have set up your API keys correctly, and that you have all the "[Prerequisites](#prerequisites)" needed to start using the application.

3. **Connecting to the Liquid Galaxy system**

If you have a Liquid Galaxy System available, you can Connect to the LG rig by entering your credentials:

<br>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492932.png?raw=true" alt="Connection" width="800"/>

If everything is correct, you should see the indicator turn green above.
  
4. **Worldwide Exploration**

Use the app for exploring any place around the globe by choosing one of the recommendations or typing your own query:

<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492453.png?raw=true" alt="worldwide" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492470.png?raw=true" alt="worldwide" width="400"/>
</td>
</tr>
</table>


5. **Explore locations Nearby**

Use the app to explore anything you want to look for nearby a location by determining the location, and choosing one of the recommendations or typing your own query:

<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492534.png?raw=true" alt="nearby" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492548.png?raw=true" alt="nearby" width="400"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492561.png?raw=true" alt="nearby" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724520610.png?raw=true" alt="nearby" width="400"/>
</td> 
</tr>
</table>


6. **Visualize the POIs**

Through the AI-generated POIs and tour, you can view all POIs on Google Maps and Google Earth through the Liquid Galaxy System.
- View the Point Details
- Orbit around the point
- Fetch Extra details from the web and Youtube about this point
- Play/stop a tour
- Add POI to favorites
- Save the whole tour to view it later
  
<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493170.png?raw=true" alt="poi" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492955.png?raw=true" alt="poi" width="400"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493215.png?raw=true" alt="poi" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493161.png?raw=true" alt="poi" width="400"/>
</td>
</tr>
</table>



 7. **Customize your own Tour**

Using your saved places, you can customize your own tour upon your interest and save the tour for later visualizations. 
- You can do that by selecting more than 2 points, then click on the customize button.
- After that, you can drag your points from the side bar into the map
- Click on Create
- Visualize your tour
- View your current tour
- Reset the tour or remove a point
- Add the tour to your favorites

<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492903.png?raw=true" alt="custom" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492740.png?raw=true" alt="poi" width="400"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492727.png?raw=true" alt="poi" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492909.png?raw=true" alt="poi" width="400"/>
</td>
</tr>
</table>



8. **View all your saved tours**

Either you customized your own tours, or you saved one of the AI-generated tours, you can view them later.

<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492708.png?raw=true" alt="favs" width="600"/>

9. **Personalize your app**

Through the settings page, you can personalize your app as needed:
- Change App Language

<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492615.png?raw=true" alt="lang" width="600"/>

- Change App Theme
  
<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492595.png?raw=true" alt="theme" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492670.png?raw=true" alt="theme" width="400"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492676.png?raw=true" alt="theme" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492681.png?raw=true" alt="theme" width="400"/>
</td>
</tr>
</table>


- Change App Fontsize

<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492590.png?raw=true" alt="font" width="600"/>


10. **Managing your API keys**

From the API keys settings, you can add, remove, view or edit a key
- To add a key you will need to put a name, the value and choose the API key service (i.e. YouTube, Gemini, Deepgram...)
- Refresh the API keys once you do any new operation on them

<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492641.png?raw=true" alt="Gemini API Key" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724520151.png?raw=true" alt="api" width="400"/>
</td>
</tr>
</table>



---

## App Screenshots and Liquid Galaxy Visualizations

### App Screenshots:

<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492442.png?raw=true" alt="Screenshot 1" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492578.png?raw=true" alt="Screenshot 2" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492582.png?raw=true" alt="Screenshot 3" width="250"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492584.png?raw=true" alt="Screenshot 4" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492637.png?raw=true" alt="Screenshot 5" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492644.png?raw=true" alt="Screenshot 6" width="250"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492895.png?raw=true" alt="Screenshot 8" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724492979.png?raw=true" alt="Screenshot 9" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493032.png?raw=true" alt="Screenshot 10" width="250"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493042.png?raw=true" alt="Screenshot 11" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493069.png?raw=true" alt="Screenshot 12" width="250"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot_1724493099.png?raw=true" alt="Screenshot 13" width="250"/>
</td>
</tr>
</table>



### Liquid Galaxy Visualizations:

<table>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20205526.png?raw=true" alt="Screenshot 1" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20210041.png?raw=true" alt="Screenshot 2" width="400"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20205559.png?raw=true" alt="Screenshot 3" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20210224.png?raw=true" alt="Screenshot 4" width="400"/>
</td>
</tr>
<tr>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20210359.png?raw=true" alt="Screenshot 5" width="400"/>
</td>
<td>
<img src="https://github.com/LiquidGalaxyLAB/LG-Gemma-AI-Touristic-info-tool/blob/main/ai_touristic_info_tool/assets/screenshots/Screenshot%202024-08-24%20210435.png?raw=true" alt="Screenshot 6" width="400"/>
</td>
</tr>
</table>


---

## Enhancement and Future Plans

While the main features are complete, future enhancements may include:
- Adding a chat function for users to inquire about specific places.
- Leveraging Gemini’s multimodality to allow users to upload images for location-based insights.

## Technical Documentation

For more detailed technical information, please refer to the [Wiki]().

## Contribution
To contribute to the project, you can help by testing the app, reporting issues, or contributing code. Here’s how you can get involved:

### Testing and Reporting Issues:
- Test the App: Use the app extensively and report any bugs or performance issues you encounter.
- Report Issues: If you find any bugs or have suggestions for improvements, please create a new issue in the repository.
  
### Code Contributions:
- Fork the repository
- Create a new branch (git checkout -b feature-branch)
- Commit your changes (git commit -m 'Add feature')
- Push to the branch (git push origin feature-branch)
- Open a Pull Request: Submit a pull request to the main repository for review.
  
You can also contribute by suggesting or working on new features.

We appreciate all forms of contribution and look forward to your involvement!


## Project Info 

This project was initiated as a Google Summer of Code 2024 project with Liquid Galaxy Org. The project was developed by:

- **Mahinour Elsarky**: Project Developer and GSoC 2024 contributor, [Email](mahinouralaa2002@gmail.com) , [LinkedIn](https://www.linkedin.com/in/mahinour-elsarky-122958216/), [GitHub](https://github.com/Mahy02)
- **Claudia Diosan**: Mentor
- **Andreu Ibañez**: Liquid Galaxy Org. Admin




<br>


Copyright (C) 2024 Mahinour Elsarky

