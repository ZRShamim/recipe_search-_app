# Make a Dish - A recipe searching app

<p>
  A recipe search app with cool UI. Search meal in search bar, also can save your meal in food detail page for cook it later.
</p>

<table>
  <tr>
    <td>Splash Screen</td>
     <td>Search Result Page</td>
     <td>Details Page</td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/ZRShamim/recipe_search-_app/main/assets/screenshots/splash_screen.png" width=270 ></td>
    <td><img src="https://raw.githubusercontent.com/ZRShamim/recipe_search-_app/main/assets/screenshots/save_page.png" width=270 ></td>
    <td><img src="https://raw.githubusercontent.com/ZRShamim/recipe_search-_app/main/assets/screenshots/recipe_details.png" width=270 ></td>
  </tr>
 </table>
 <table>
  <tr>
    <td>Recipe Details</td>
    <td><img src="https://github.com/ZRShamim/recipe_search-_app/blob/main/assets/screenshots/l_saved_rec.png" width=620  ></td>
  </tr>
  <tr>
    <td>Recipe list with Search Bar</td>
    <td><img src="https://raw.githubusercontent.com/ZRShamim/recipe_search-_app/main/assets/screenshots/l_saved_rec.png" width=620  ></td>
  </tr>
  <tr>
    <td>Recipe list with Category Slider</td>
    <td><img src="https://raw.githubusercontent.com/ZRShamim/recipe_search-_app/main/assets/screenshots/l_saved_rec_2.png" width=620  ></td>
  </tr>
 </table>

## Project Environment:
```
Flutter 2.5.3 • channel stable • https://github.com/flutter/flutter.git
Framework • revision 18116933e7 (6 weeks ago) • 2021-10-15 10:46:35 -0700
Engine • revision d3ea636dc5
Tools • Dart 2.14.4
```

## Code Flow:
For managing state I am using provider ^6.0.1. All the screens are in pages folder and UI components are inside widget folder.

```
└── lib/
    ├── pages/
    │   └── different UI pages
    ├── providers/
    │   └── state management
    ├── widgets/
    │   └── UI components
    └── styles/
        └── colors
    
```
## Feature List
```
├── Search recipe in search bar
├── Details page
└── Save recipe for later use

```

## Api and others: 
```
The MealDb: https://www.themealdb.com/api.php
Firbase: For saving the recipe.
```

## To-DO
```
├── Add User Authentication
└── Add more information in detail page
```

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
