import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:times_now/app/common/app_bar_common.dart';
import 'package:times_now/app/common/bottom_navgation_bar.dart';
import '../controllers/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<bool> isExpanded; // List to hold the expanded state for each category

  _HomeViewState() : isExpanded = []; // Initialize the list

  @override
  void initState() {
    super.initState();
    // Initialize the expanded state for each meal category
    isExpanded = List<bool>.filled(3,
        false); // Change 3 to mealCategories.length if you get the categories dynamically
  }

  @override
  Widget build(BuildContext context) {
    // Example meal data translated to English
    final mealCategories = [
      {
        "id": 3,
        "name": "Weight Loss Package (100g Protein)",
        "image": "http://54.170.183.211/meal_category_images/65101df50acfd.jpg",
        "meal_plans": [
          {
            "id": 9,
            "name": "2 Meals + Snack",
            "meal_types": "1 Breakfast, 1 Main Dish, 1 Snack",
            "short_description": "700 - 850 Calories"
          },
          {
            "id": 10,
            "name": "3 Meals + Snack",
            "meal_types": "1 Breakfast, 2 Main Dishes, 1 Snack",
            "short_description": "900 - 1200 Calories"
          },
          {
            "id": 11,
            "name": "4 Meals + Snack",
            "meal_types": "1 Breakfast, 3 Main Dishes, 1 Snack",
            "short_description": "1300 - 1600 Calories"
          },
          {
            "id": 12,
            "name": "5 Meals + Snack",
            "meal_types": "1 Breakfast, 4 Main Dishes, 1 Snack",
            "short_description": "1400 - 2000 Calories"
          }
        ]
      },
      {
        "id": 2,
        "name": "Fitness Package (150g Protein)",
        "image": "http://54.170.183.211/meal_category_images/65101e73a2480.jpg",
        "meal_plans": [
          {
            "id": 5,
            "name": "2 Meals + Snack",
            "meal_types": "1 Breakfast, 1 Main Dish, 1 Snack",
            "short_description": "1050 - 1275 Calories"
          },
          {
            "id": 6,
            "name": "3 Meals + Snack",
            "meal_types": "1 Breakfast, 2 Main Dishes, 1 Snack",
            "short_description": "1350 - 1800 Calories"
          },
          {
            "id": 7,
            "name": "4 Meals + Snack",
            "meal_types": "1 Breakfast, 3 Main Dishes, 1 Snack",
            "short_description": "1950 - 2400 Calories"
          },
          {
            "id": 8,
            "name": "5 Meals + Snack",
            "meal_types": "1 Breakfast, 4 Main Dishes, 1 Snack",
            "short_description": "2100 - 3000 Calories"
          }
        ]
      },
      {
        "id": 1,
        "name": "Bulking Package (200g Protein)",
        "image": "http://54.170.183.211/meal_category_images/65101eb0028a2.jpg",
        "meal_plans": [
          {
            "id": 1,
            "name": "2 Meals + Snack",
            "meal_types": "1 Breakfast, 1 Main Dish, 1 Snack",
            "short_description": "1400 - 1700 Calories"
          },
          {
            "id": 2,
            "name": "3 Meals + Snack",
            "meal_types": "1 Breakfast, 2 Main Dishes, 1 Snack",
            "short_description": "1800 - 2400 Calories"
          },
          {
            "id": 3,
            "name": "4 Meals + Snack",
            "meal_types": "1 Breakfast, 3 Main Dishes, 1 Snack",
            "short_description": "2600 - 3200 Calories"
          },
          {
            "id": 4,
            "name": "5 Meals + Snack",
            "meal_types": "1 Breakfast, 4 Main Dishes, 1 Snack",
            "short_description": "2800 - 4000 Calories"
          }
        ]
      }
    ];

    return Scaffold(
      appBar: const CustomAppBar(title: 'PROTENIUM'),
      body: Column(
        children: [
          Image.asset(
            'assets/images/top_banner.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 180,
          ),
          // Dynamic ListView for meal categories
          Expanded(
            child: ListView.builder(
              itemCount: mealCategories.length,
              itemBuilder: (context, index) {
                dynamic category = mealCategories[index];

                return Stack(
                  children: [
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Image.network(
                            category['image'],
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: 200,
                          ),
                          Container(
                            width: double.infinity,
                            // padding: const EdgeInsets.symmetric(
                            //     vertical: 12,
                            //     horizontal: 16), // Padding inside the container
                            color: Colors.black.withOpacity(0.5),
                            child: Row(
                              children: [
                                // SizedBox(
                                //   width: 40,
                                // ),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Text(
                                    category['name'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.2,
                                      // shadows: [
                                      //   Shadow(
                                      //     blurRadius: 5.0,
                                      //     color: Colors.black.withOpacity(1),
                                      //     offset: Offset(2.0, 2.0),
                                      //   ),
                                      // ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Show meal plans if expanded
                          if (isExpanded[index])
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: category['meal_plans']
                                    .map<Widget>((mealPlan) {
                                  return ListTile(
                                    title: Text(mealPlan['name']),
                                    subtitle:
                                        Text(mealPlan['short_description']),
                                  );
                                }).toList(),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 0, // Align to the bottom of the card
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isExpanded[index] =
                                !isExpanded[index]; // Toggle the expanded state
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white, // Circle container color
                          ),
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            isExpanded[index]
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            color: const Color.fromRGBO(
                                93, 167, 163, 1), // Icon color
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: 0,
        onTap: (index) {
          if (kDebugMode) {
            print('Tapped on index: $index');
          }
        },
      ),
    );
  }
}
