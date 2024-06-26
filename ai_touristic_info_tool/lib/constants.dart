import 'package:ai_touristic_info_tool/models/places_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LgAppColors {
  static const Color lgColor1 = Color(0xFF537DC0);
  static const Color lgColor2 = Color(0xFFE54E3E);
  static const Color lgColor3 = Color(0xFFF6B915);
  static const Color lgColor4 = Color(0xFF4CB15F);
}

class ButtonColors {
  static const Color mapButton = Color.fromARGB(255, 146, 199, 255);
  static const Color photoButton = Color.fromARGB(255, 146, 240, 146);
  static const Color musicButton = Color.fromARGB(255, 180, 150, 237);
  static const Color audioButton = Color.fromARGB(255, 246, 180, 87);
  static const Color promptButton = Color.fromARGB(148, 255, 237, 70);
  static const Color locationButton = Color.fromARGB(255, 246, 120, 116);
}

class FontAppColors {
  static const Color primaryFont = Colors.black;
  static const Color secondaryFont = Colors.white;
}

class PrimaryAppColors {
  static const Color gradient1 = Color(0xFF243558);
  static const Color gradient2 = Color(0xFF4F73BF);
  static const Color gradient3 = Color(0xFF6988C9);
  static const Color gradient4 = Color(0xFF8096C5);
  static const Color buttonColors = Color(0xFF556EA5);
  static const Color accentColor = Color.fromARGB(120, 252, 171, 21);
  static const Color innerBackground = Colors.white;
}

// class DarkAppColors {
//   static const Color primary1 = Color(0xFF9647FA);
//   static const Color primary2 = Color(0xFFBC9FE1);
//   static const Color primary3 = Color(0xFFD3B4F9);
//   static const Color background = Colors.white;
// }

// class GreenAppColors {
//   static const Color primary1 = Color(0xFF9647FA);
//   static const Color primary2 = Color(0xFFBC9FE1);
//   static const Color primary3 = Color(0xFFD3B4F9);
//   static const Color background = Colors.white;
// }

// class LilacAppColors {
//   static const Color primary1 = Color(0xFF9647FA);
//   static const Color primary2 = Color(0xFFBC9FE1);
//   static const Color primary3 = Color(0xFFD3B4F9);
//   static const Color background = Colors.white;
// }

// class OrangeAppColors {
//   static const Color primary1 = Color(0xFF9647FA);
//   static const Color primary2 = Color(0xFFBC9FE1);
//   static const Color primary3 = Color(0xFFD3B4F9);
//   static const Color background = Colors.white;
// }

// class BeigeAppColors {
//   static const Color primary1 = Color(0xFF9647FA);
//   static const Color primary2 = Color(0xFFBC9FE1);
//   static const Color primary3 = Color(0xFFD3B4F9);
//   static const Color background = Colors.white;
// }

final fontType = GoogleFonts.montserrat().fontFamily;
const double titleSize = 40;
const double headingSize = 35;
const double textSize = 20;



 Map<String, List<PlacesModel>> defaultDataConst = {
      'Attractions in London, UK': [
        PlacesModel(
          name: 'Tower of London',
          address: '166 London Bridge, London SE1 2AX',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A historic castle and former royal palace, known for its gruesome past as a royal palace, prison, and execution site.',
          price: '£20.70',
          ratings: 4.8,
          amenities: 'Guided tours, Gift shop, Cafe',
          latitude: 51.5081,
          longitude: -0.0759,
        ),
        PlacesModel(
          name: 'Buckingham Palace',
          address: 'Buckingham Palace, London SW1A 1AA',
          city: 'London',
          country: 'United Kingdom',
          description:
              'The official residence of the Queen of England, known for its iconic Changing of the Guard ceremony.',
          price: 'Free entry',
          ratings: 4.9,
          amenities: 'Guided tours, Gift shop, Gardens',
          latitude: 51.501366,
          longitude: -0.141890,
        ),
        PlacesModel(
          name: 'Hyde Park',
          address: 'Hyde Park, London W2 2BB',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A vast and popular park in central London, known for its lakes, gardens, and open-air events.',
          price: 'Free entry',
          ratings: 4.7,
          amenities: 'Picnic spots, Boating, Playground',
          latitude: 51.512840,
          longitude: -0.161450,
        ),
        PlacesModel(
          name: 'St. Paul\'s Cathedral',
          address: '1 Cathedral Close, London EC4A 4AA',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A towering cathedral known for its iconic dome and stunning views of London.',
          price: 'Free entry',
          ratings: 4.9,
          amenities: 'Guided tours, Gift shop, Cafe',
          latitude: 51.514360,
          longitude: -0.098360,
        ),
        PlacesModel(
          name: 'The British Museum',
          address: '96-99 Great Russell Street, London WC1A 1AA',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A vast museum housing a vast collection of artifacts from around the world.',
          price: 'Free entry',
          ratings: 4.8,
          amenities: 'Guided tours, Gift shop, Cafe',
          latitude: 51.5194,
          longitude: -0.1270,
        ),
        PlacesModel(
          name: 'Borough Market',
          address: '85-95 Borough High Street, London SE1 1RL',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A vibrant food market offering a wide variety of fresh produce, meats, and other delicacies.',
          price: 'Free entry',
          ratings: 4.8,
          amenities: 'Food stalls, Shopping, Seating area',
          latitude: 51.5055,
          longitude: -0.0905,
        ),
        PlacesModel(
          name: 'Tate Modern',
          address: 'Bankside, London SE1 9TG',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A contemporary art gallery showcasing works from both established and emerging artists.',
          price: 'Free entry',
          ratings: 4.7,
          amenities: 'Guided tours, Gift shop, Cafe',
          latitude: 51.5076,
          longitude: -0.0994,
        ),
        PlacesModel(
          name: 'Camden Market',
          address: 'Camden Road, London NW1 2FB',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A large and diverse market selling clothing, jewelry, food, and other items.',
          price: 'Free entry',
          ratings: 4.8,
          amenities: 'Shopping, Food stalls, Entertainment',
          latitude: 51.5416,
          longitude: -0.1460,
        ),
        PlacesModel(
          name: 'Greenwich Observatory',
          address: '1 Observatory Hill, Greenwich, London SE10 8BB',
          city: 'London',
          country: 'United Kingdom',
          description:
              'A historic observatory known for its association with Greenwich Mean Time (GMT) and maritime history.',
          price: '£16.50',
          ratings: 4.9,
          amenities: 'Guided tours, Planetarium, Cafe',
          latitude: 51.4769,
          longitude: -0.0005,
        ),
        PlacesModel(
          name: "The view from The Shard",
          address: "32 London Bridge St, London SE1 9SG",
          city: "London",
          country: "United Kingdom",
          description:
              "An observation deck offering panoramic views of London from the tallest building in the city.",
          price: "£32.00",
          ratings: 4.7,
          amenities: "360-degree views, Champagne bar, Gift shop",
          latitude: 51.5045,
          longitude: -0.0865,
        )
      ],
      'Top Pizza Places in Cairo Egypt': [
        PlacesModel(
          name: "DI SFORNO PIZZERIA",
          address: "32 Bahgat Ali, Mohammed Mazhar, Zamalek",
          city: "Cairo",
          country: "Egypt",
          description: "Known for their delicious pizzas and great atmosphere.",
          ratings: 4.8,
          amenities: "Dine-in, Takeaway",
          latitude: 30.825001326366202,
          longitude: 31.35365556051414,
        ),
        PlacesModel(
          name: "Casa Della Past",
          address: "10 Gezira sporting club",
          city: "Cairo",
          country: "Egypt",
          description:
              "Serves tasty pizzas and offers both dine -In & take away options.",
          ratings: 4.3,
          amenities: "Dine-in, Takeaway",
          latitude: 30.070722989111506,
          longitude: 31.229232071254188,
        ),
        PlacesModel(
          name: "Olivo Pizzeria & Bar",
          address: "18 Taha Hussein, Abu Al Feda, Zamalek",
          city: "Cairo",
          country: "Egypt",
          description:
              "Offers authentic Italian pizzas and casual dining experience.",
          ratings: 4.2,
          amenities: "Dine-in, Takeaway",
          latitude: 30.091746694202516,
          longitude: 31.22099875549518,
        ),
        PlacesModel(
          name: "CaiRoma",
          address: "19 Youssef El-Gendy",
          city: "Cairo",
          country: "Egypt",
          description:
              "Casual eatery serving sweet & savory pizzas with a focus on perfect Italian pizza.",
          ratings: 4.2,
          amenities: "Italian",
          latitude: 30.04617401175439,
          longitude: 31.2393844674545,
        ),
        PlacesModel(
          name: "Sapori di Carlo",
          address: "49 Mohammed Mazhar",
          city: "Cairo",
          country: "Egypt",
          description: "Serves delicious Italian pizza with friendly service.",
          ratings: 4.5,
          amenities: "Italian",
          latitude: 30.072252708388493,
          longitude: 31.222200373009805,
        ),
      
        PlacesModel(
          name: "What the Crust",
          address: "275 Makram Ebeid St",
          city: "Cairo",
          country: "Egypt",
          description:
              "Casual eatery for sweet & savory pizzas, known for having one of the best pizzas in Egypt.",
          ratings: 4.6,
          amenities: "Pizza",
          latitude: 29.97275528964059,
          longitude: 31.276156900056083,
        ),
        PlacesModel(
          name: "Pane Vino",
          address: "InterContinental Semiramis, Nile Corniche",
          city: "Cairo",
          country: "Egypt",
          description:
              "Serves delicious Italian pizza with a wide variety of toppings.",
          ratings: 4.5,
          amenities: "Italian",
          latitude:   30.043723456031824,
          longitude: 31.232064194439,
        
        ),
        PlacesModel(
          name: "Maison Thomas",
          address: "157, 26th of July St, Mohammed Mazhar, Zamalek,",
          city: "Cairo",
          country: "Egypt",
          description:
              "Serves delicious Italian pizza with a wide variety of toppings.",
          ratings: 4.5,
          amenities: "Italian",
          latitude: 30.073647653792865,
          longitude:  31.223336525995233,
        ),
        PlacesModel(
          name: "900 Degrees Restaurant",
          address: "Downtown mall, New Cairo",
          city: "Cairo",
          country: "Egypt",
          description: "Variety of Neapolitan pizzas in Cairo",
          ratings: 4.3,
          amenities: "Italian, Neapolitan",
          latitude: 30.038356471688655,
          longitude:  31.41009766726725,
        ), 
        PlacesModel(
          name: "Ted's Pizzeria",
          address: "2FRG+P59, WaterWay, New Cairo 1",
          city: "Cairo",
          country: "Egypt",
          description:
              "Authentic Neapolitan pizza with 'All You Can Eat Pizza' option. Choose your toppings for ultimate customization",
          ratings: 4.0,
          amenities: "All you can eat Pizza",
          latitude: 30.063912523919832,
          longitude: 31.481839712643716,
        ) 
      ],
      'Restaurants and Cafes in Italy, Rome': [
        PlacesModel(
          name: "Trattoria Da Augusto",
          address: "Via dei Banchi, 48, 00186 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Classic Roman trattoria serving traditional dishes like cacio e pepe and amatriciana.",
          price: "\$\$",
          ratings: 4.5,
          amenities: "Outdoor seating, Traditional atmosphere",
          latitude: 41.89058478617748,
          longitude: 12.470361752827548,
        ), 
        PlacesModel(
          name: "L’Arcangelo",
          address: "Via del Gambero Rosso, 43, 00186 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Cozy restaurant offering gourmet Roman pasta and seasonal dishes.",
          price: "\$\$\$",
          ratings: 4.8,
          amenities: "Indoor seating, Wine selection",
          latitude: 41.906717057932745,
          longitude: 12.46865149515685,
        ), 
        PlacesModel(
          name: "Ristorante Pizzeria Da Baffetto",
          address: "Via dei Fori Imperiali, 60, 00189 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Legendary pizzeria known for its thin-crust Roman pizza.",
          price: "\$\$",
          ratings: 4.7,
          amenities: "Outdoor seating, Pizza al taglio",
          latitude: 41.89849937359198,
          longitude: 12.470422541187084,
        ), 
        PlacesModel(
          name: "Pizzarium",
          address: "Via Antonio Scarioni, 10, 00187 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Innovative pizzeria serving gourmet pizza with seasonal toppings.",
          price: "\$\$\$",
          ratings: 4.9,
          amenities: "Indoor seating, Wood-fired oven",
          latitude: 41.90681151204747,
          longitude: 12.446617250977372,
        ),  
        PlacesModel(
          name: "La Carbonara",
          address: "Via della Rosetta, 48, 00186 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Traditional Roman trattoria specializing in carbonara pasta.",
          price: "\$\$",
          ratings: 4.4,
          amenities: "Indoor seating, Classic dishes",
          latitude: 41.89798835428056,
          longitude: 12.470873923882506,
        ), 
        PlacesModel(
          name: "Osteria del Gambero Rosso",
          address: "Via del Gambero Rosso, 41, 00186 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Cozy restaurant offering a wide range of Roman dishes and wines.",
          price: "\$\$\$",
          ratings: 4.6,
          amenities: "Indoor seating, Wine pairing",
          latitude: 45.48334740316227,
          longitude:  9.183127579064324,
        ),  
        PlacesModel(
          name: "Ristorante Pizzeria Da Gabriele",
          address: "Via del Polito, 30, 00198 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Traditional pizzeria serving classic Roman pizza al taglio.",
          price: "\$\$",
          ratings: 4.3,
          amenities: "Outdoor seating, Pizza delivery",
          latitude: 45.54559512646351,
          longitude:9.191179273965561,
        ),  
        PlacesModel(
          name: "Gelateria del Teatro",
          address: "Via della Stamperia, 87, 00186 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Iconic gelato shop offering traditional flavors and innovative creations.",
          price: "€1.50-3.00",
          ratings: 4.9,
          amenities: "Indoor seating, Gelato flights",
          latitude: 41.9012449358392,
          longitude: 12.469666261108085,
        ),  
        PlacesModel(
          name: "Formello Gelato",
          address: "Via dei Condotti, 33, 00187 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Gourmet gelato shop serving high-quality flavors and toppings.",
          price: "€2-5",
          ratings: 4.8,
          amenities: "Indoor seating, Gelato workshops",
          latitude: 42.06614601563788,
          longitude:12.400485144989153,
        ),   
        PlacesModel(
          name: "Gelateria Romana",
          address: "Piazza Navona, 33, 00186 Rome, Italy",
          city: "Rome",
          country: "Italy",
          description:
              "Traditional gelato shop offering a wide range of classic flavors.",
          price: "€1.50-3.00",
          ratings: 4.5,
          amenities: "Outdoor seating, Gelato tours",
          latitude: 41.915953152799695,
          longitude: 12.470269975120516,
        ), 
      ],
    };