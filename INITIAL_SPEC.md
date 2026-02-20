## 1. Overview
MacroTrace is a Flutter project allowing the user to track and report their macro nutrient intake to better manage their health.  The application utilizes a list of foods, each entry contains an amount by volume or weight and the macro list the food relates to.  This amount of the food dictates a single point toward their daily allotment of that macro.  For example, a male weighing 200lbs could have an allotment of 15 carbs, 15 protiens and 15 fats a day.  1 oz of chicken is 1 point and now they have 14 left. 

## 2. Technical Notes
- Use a Clean architecture layout
- Keep SOLID programming principles in mind
- State management through BLoC thinking of BLoCs as ViewModels
- GetIt for dependency injection
- GoRouter for navigation
- Keep as much business logic out of the UI layer as possible, either move it to the BLoC or UseCases to make it easier to write headless tests

## 3. Workflow Notes
- For v1, the food entries are supplied by an external json file in the assets folder titled food_data.json.
- The user should be able to quickly add entries for a meal from a FAB.

## 4. Screens
- The Meals screen is the default screen when the app is opened.
## 4.1 Meals screen
- The Meals screen shows each meal, containing the food entries for the day.
- The user can move forward and back between days
- The user should be able to remove a meal.  The remove CTA triggers a confirmation dialog.
- A FAB CTA allows the user to add a meal.  This navigates the user to the Create a meal screen.
- The FAB CTA adds a meal for the specified day, meaning the user can go do a previous day and add a meal for that day via the FAB CTA.
### 4.2 Create a meal screen
- When entering a meal, the user is presented with a searchable list on the top of the screen and a list of selected foods at the bottom.  The selected list contains the measured amount and allows the user to enter an number (1, 1.25 etc.) indicating how many points they have of the food item in the meal.  Given the measurement amount and the point amount, the total weight is calculated and shown.  This should all be in a single row of a scrollable list.  The row also has a delete CTA allowing the user to remove the entry.  The Remove CTA triggers a confirmation dialog before actually removing the entry.

## 5. Nice to haves
- If it's not to difficult, allow the user to report a meal or full days meals to another person via a text message.  The text should be "nicely" formated.

## 6. Misc
- The implementation plan should contain milestones allowing the developer to check on the progress of the implementation.  
- v1 should persist meals, containing the entries of the chosen food, along with the time and a label in a Map saved to Shared Preferences.


## 7. Milestones
- The overall plan will be created in Milestones.  Each Milestone will utilize 1 or more GitHub branches to manage the code changes.  Code will not be written for features outside the current Milestone although changes to the PRD.md may be made as more understanding of the application is gained.

### 7.1 Milestone 1
#### 7.1.1 Goals
1. Get minimal functionality to get something work and enough data structures and content to start to create evaluation tests to ensure agents are creating the correct code.
#### 7.1.2 Tasks
1. Create Clean folder structure
2. Create Meals screen that displays a hardcode list of meals from the data layer
3. Work with me to create hardcode json of multiple meals on multiple days that will be used to display on Meal screen
4. User can navigate through the days containing the meals  