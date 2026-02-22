### Milestone 1 - Round 1 Questions

1. Data Modeling (food_data.json): This is the most critical part. Could you define the structure for a single food item in food_data.json?

Example: Should it be { "name": "Chicken Breast", "measurement_unit": "oz", "macro_type": "protein" }?
- an initial implementation of the food data is available in assets/food_data.json but a couple examples are 
  {
    "item": "Ham",
    "measurement": "1-1/2 oz",
    "categories": [
      "protien"
    ]
  }
  and
    {
    "item": "Yogurt",
    "measurement": "1/2 cup",
    "categories": [
      "protein","carbohydrate"
    ]
  }

  but I like having measurement_unit and using macro_type instead of category.  Can you create a food_data_v2.json with these changes??

- another note about the food item, some of the measurement_units are per item, ie, almonds and other nuts are per nut and not by oz

Is the "point" value always 1 per unit of measurement (e.g.,1 point per oz/gram), or does each food have a unique point value (e.g., { "name": "Almonds", "points_per_oz": 2.5, ... })?
- each food has a unique point value as outlined in food_data.json

2. Daily Allotment Calculation: The spec mentions an allotment based on user characteristics (e.g., weight).

For V1, should this be a hardcoded, static value (e.g., 15 points for each macro)?
Or, should we include a simple form for the user to set their own daily point goals?A full calculation based on weight/gender can be a future milestone.
- for V1 this will be a hardcoded value, but make sure to use an object in a data service in the data layer to deliver the value since it will eventually come from a setting

3. Meal and Entry Logic:

What defines a "Meal"? Should it have a title (e.g., "Breakfast", "Lunch", "Dinner") or just a timestamp?
- lets go with a timestamp for now

When adding a food entry, the user enters a "point amount" (e.g., 1.25). Does this mean they are consuming 1.25 servings of the food's base measurement (e.g., 1.25 oz of chicken)?
- if I understand you correctly the answer is yes.  I personally use this system and what I'll do for lunch where I have an allotment of 5p/5c/5f, I'll weigh out 5oz of chicken for my full protien allotment.  But I could also have a lunch that has 3.5oz of Ground beef (which is 3.5 points) and 1.5oz of cheese (which is 1.5 points) for a total of 5 points for my protien allotment.  Please ask further questions if you need further clarification.

4.UI/UX Flow (Create Meal Screen):

Could you confirm the intended workflow? Is it:
Search and tap a food item.
The item appears in the bottom "selected" list.
User then enters the desired "point amount" in a number field for that list item.
Should the searchable list disappear or remain visible after an item is selected?
- None of these, for Milestone 1 I only want to display the list of hardcoded meals, that is retreived from a data service in the data layer, onto the Meal Screen.  It's not actually "creating" a meal, that'll happen in another Milestone.

5. Scope for Milestone 1:

INITIAL_SPEC.md mentions creating hardcoded JSON for meals across multiple days. Will you provide this structure, or should we define a simple Meal model (e.g., { "date": "...", "label": "...", "foods": [...] }) and I'll create the placeholder data?
- let's define a simple data model, with the understanding that we'll may have to iterate to get to the final product.

The "nice to have" SMS reporting feature requires a new dependency (url_launcher or similar). Shall we defer this entirely to a future milestone to keep V1 focused?
- let's skip this for now, it is well outside the scope of V1

Notes on Proposed Plan
1. As noted above food_data.json ALREADY exists in the assets folder, but will need to be modified into ANOTHER file, please keep the existing food_data.json available for reference if needed.
2. Don't worry about SharedPreferences for persistence for V1, we're going to stick with hardcoded or in-memeory data.

---
### Milestone 1 - Round 2 Questions

1.  **`FoodItem` Model Confirmation:** I will create a `food_data_v2.json` file. Does the following JSON structure meet your requirements for a single food item? It separates amount from units and cleans up the categories.

    ```json
    {
      "id": "turkey_breast",
      "name": "Turkey breast",
      "measurement_amount": 1.0,
      "measurement_unit": "oz",
      "macro_types": ["protein"]
    }
    ```
    *   **Note:** For items like "Almonds" (measured as "6"), the `measurement_unit` would be "each". For "1-1/2 oz" items, `measurement_amount` would be `1.5`. Is this handling acceptable?

    - this all looks good, yes in the example above, 1.5 is acceptable

2.  **`Meal` and `MealEntry` Model Confirmation:** For the hardcoded data in Milestone 1, I plan to use the following structure internally within the app's data layer. Does this look correct?

    *   **A `Meal`**, which is just a list of entries with a timestamp:
        ```json
        {
          "timestamp": "2026-02-19T12:00:00Z",
          "entries": [ ... ]
        }
        ```
    *   **A `MealEntry`** within that list, which links to a food item and records the points consumed:
        ```json
        {
          "food_id": "turkey_breast",
          "points": 2.5
        }
        ```
    *   In this example, the user consumed 2.5 points of "Turkey breast", which would equate to 2.5 oz.

    - this also looks good

### Milestone 2 - Round 1 Questions

Thank you for providing the overview for Milestone 2. Before I build out the task list and begin implementation, I'd like to clarify a few points to ensure I understand the requirements completely.

1.  **Date/Time of Meal**: When creating a *new* meal, how should the `timestamp` be determined? Should it default to the current date and time? Or should the user be able to select the date and time?

- lets default to current date/time for now

2.  **Meal Grouping**: Meals are currently grouped by day. Should a new meal be associated with a specific day? If so, does the user select the day, or does it default to "today"?

- default to today for now

3.  **"Pinning" Behavior**:
    *   When a food item is checked and "pinned" to the top, should it be removed from its original position in the list?
    no, let's keep it in the list to reduce complexity for now
    *   When an item is un-pinned (unchecked), should it return to its original position in the list?
    no, let's keep it in the list to reduce complexity for now
    *   Is there a specific order for pinned items (e.g., chronological, alphabetical)?
    for now, lets just keep them in the order the user adds them

4.  **"Edit Meal" CTA**: Where exactly should the "Edit" CTA be located on the `MealsScreen`? Should it be an icon button on each `MealListItem`?
- display the edit icon to the right of the "Meal at xxx" text for each MealListItem card

5.  **"Meal Screen" Title**: Should the "Meal Screen" have a dynamic title, such as "Create Meal" when creating and "Edit Meal" when editing?
- yes, dynamic title would be good

6.  **"Save" CTA Text**: Should the CTA text change based on the mode (e.g., "Add Meal" for create, "Save Changes" for edit)?
- just use Save

7.  **Data Refresh Mechanism**: The overview mentions "A mechanism will be needed to signal the MealBloc that new meals data is available". My proposed solution is for the "Meal Screen" to pop with a result (e.g., `true` if a meal was saved), which would then trigger the `MealsBloc` to reload its data. Is this approach acceptable, or do you have another mechanism in mind (e.g., a shared stream/service)?
- let's go with a stream

8.  **Input Validation**: Should there be any input validation for the text field (e.g., non-negative numbers only)? The overview mentions "2 significant digits" - should I enforce this with formatting or validation?
- the portion value should be a non-negative double, ie 2.25, 3.5, 6
9.  **Navigation Library**: The PRD mentions `go_router`. Should I use `go_router` to handle the navigation between the `MealsScreen` and the new "Meal Screen"? If so, what should the route path be for the new screen (e.g., `/meal`, `/meal/:id`)?
- yes, use go_router with path '/meal/:id'.  use uuid when creating the id.  i assume this means the Meal object needs an id field

Please let me know your thoughts on these questions. Once I have these clarifications, I will be able to create a more accurate and comprehensive task list for Milestone 2.

