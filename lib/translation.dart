import 'package:get/get.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //
          'lazyPlants': 'LazyPlants',
          'aNewWay': 'A new way to water your plants!',
          'email': 'E-Mail',
          'password': 'Password',
          'login': 'Login',
          'helloThere': 'Hello\nThere!',
          'createAccount': 'Create Account',
          'next': 'Next',
          'cancel': 'Cancel',
          'finish': 'Finish',
          'back': 'Back',
          'needHelp': 'Need help?',
          'ok': 'OK',
          'urlLaunchError': 'Could not launch URL:',
          'useCamera': 'Use Camera',
          'pickGallery': 'Pick from gallery',
          'credentialsIncorrect':
              'Your credentials are incorrect. Try correcting your e-mail or password.',
          'credentialsMissing': 'Empty credentials',
          'somethingWrong': 'Something went wrong.',
          'successfulLogout': 'You successfully logged out.',
          'username': 'Username',
          'loginInstead': 'Login instead?',
          'firstName': 'First Name',
          'lastName': 'Last Name',
          'emailExists': 'This email is already in use.',
          'passworToShort': 'This password is to short.',
          'invalidEmail': 'Invalid Email',

          // homescreen
          'hi': 'Hi',
          'hello': 'Hello',
          'morning': 'Good Morning',
          'afternoon': 'Good Afternoon',
          'evening': 'Good Evening',
          'night': 'Good Night',
          'home_searchText': 'Search plant',
          'home_noPlant': 'There is no plant here. Add one!',

          // navigation drawer
          'home': 'Home',
          'statistics': 'Statistics',
          'howToConnect': 'How to connect?',
          'settings': 'Settings',
          'about': 'About',
          'logout': 'Logout',

          // add plant screens
          'addPlant1_title': 'Add a plant',
          'addPlant1_body':
              'Please ensure your microcontroller is already up and running before you continue!',
          'addPlant1_helpText': 'How do I add my microcontroller?',
          'addPlant1_helpUrl':
              'https://github.com/jdk-21/lazyplants/blob/master/README.md',
          'addPlant2_title': 'What\'s your name?',
          'addPlant2_helpText': 'Name, please',
          'addPlant2_dropDown': 'Select ESP',
          'addPlant2_noName': 'Please, add a name!',
          'addPlant2_noEsp': 'Please, select an ESP from the dropdown!',
          'addPlant2_hintName': 'Totally creative name',
          'addPlant3_title': 'Set your defaults',
          'addPlant3_humidityText':
              'At what percentage should LazyPlants water your plants?',
          'addPlant3_helpHumidityTitle': 'The Humidity Slider:',
          'addPlant3_helpHumidityText':
              '0 represents 0% humidity and 100 represents 100%. If you set the slider to 75%, LazyPlants will water your plant if the humidity is below 75%.',
          'addPlant4_title': 'Take a picture',
        },
        'de_DE': {
          'next': 'Weiter',
          'cancel': 'Abbrechen',
          'finish': 'Beenden',
          'back': 'Zurück',
          'needHelp': 'Brauchst du Hilfe?',
          'ok': 'OK',
          'urlLaunchError': 'URL lässt sich nicht öffnen:',
          'useCamera': 'Benutze Kamera',
          'pickGallery': 'Von Galerie auswählen',

          // homescreen
          'hi': 'Hi',
          'hello': 'Hallo',
          'morning': 'Guten Morgen',
          'afternoon': 'Guten Tag',
          'evening': 'Guten Abend',
          'night': 'Gute Nacht',
          'home_searchText': 'Suche Pflanze',

          // navigation drawer
          'home': 'Home',
          'statistics': 'Statistiken',
          'howToConnect': 'Wie verbinde ich mich?',
          'settings': 'Einstellungen',
          'about': 'Über',
          'logout': 'Logout',

          // add plant screens
          'addPlant1_title': 'Füge eine Pflanze hinzu',
          'addPlant1_body':
              'Versichere dich, dass dein Mikrocontroller an ist und funktioniert.',
          'addPlant1_helpText': 'Wie füge ich meinen Mikrocontroller hinzu?',
          'addPlant1_helpUrl': 'https://github.com/jdk-21/lazyplants/tree/esp',
          'addPlant2_title': 'Name, bitte',
          'addPlant2_helpText': 'Name der Pflanze',
          'addPlant2_hintName': 'Total kreativer Name',
          'addPlant3_title': 'Setze Standards',
          'addPlant3_humidityText':
              'Ab welcher Bodenfeuchtigkeit soll LazyPlants gießen?',
          'addPlant3_helpHumidityTitle': 'Der Feuchtigkeitsregler:',
          'addPlant3_helpHumidityText':
              '0 repräsentiert 0% und 100 repräsentiert 100%. Wenn der Regler bei 75% steht, gießt LazyPlants bei einer Bodenfeuchtigkeit von unter 75%.',
          'addPlant4_title': 'Mache ein Foto',
        }
      };
}
