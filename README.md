# IntelliKitchen 

| Contributor                                                   | Role                      |
| ---                                                           | ---                       |
| Yilun Hao                     | Senior System Analyst     |
| Qiao Rong                   | Business Analyst          |
| Jiaming Zhang             | Software Architect        |
| David Cheung                    | Software Development Lead |
| Jiangnan Xu                      | Database Specialist       |
| Duolan Ouyang               | User Interface Specialist |
| [Jessica Zhong](https://github.com/acisseJZhong)              | Project Manager           |
| Jialu Xu                  | Quality Assurance Lead    |
| Dawei Wang         | Algorithm Specialist      |
| [Kaixun Zhang](https://github.com/Lucas610)              | Algorithm Specialist       |

### Introduction
As busy students who focus on studying, we always forget to use our food in the fridge and lead to waste, which is very environmentally unfriendly. Sometimes we also forget to do the chores, 
such as cleaning the house and washing the dishes. Therefore, we develop IntelliKitchen, a convenient, simple, and effective mobile application that can lead you to an easier and more relaxing life. It can keep track of expiration dates of the food in your fridge, generates recipes based on food expiration dates, and assists your chores by sending notifications based on your chores plan. With the above functionalities, our users can have a clear overview of their fridges and manage their food properly to minimize potential food wastes.


### Sign in Credentials
For testing purposes, we have created an outlook account and a Gmail account to adapt to two different sign in options. Please see the provided sign in credentials below.

Email: intellikitchen@outlook.com</br>
Password: cse110gogary!

Email: intellikitchentest001@gmail.com</br>
Password: cse110gogary!


### Requirements
This application must be run on an iOS platform. 
The User must have an Internet connection while using the application. 
Minimum Specs: 
        - iPhone 11 
        - iOS version 13.4 or above
        - Xcode version 11.4 or above

### Installation Instructions
1. Download the app from GitHub. 
2. Open the terminal, go to the directory and execute `pod install`(if it doesn't work out, first run `sudo gem install cocoapods`). 


### How to Run on the Simulator
1. Use a MacBook to open Xcode, and run the file "IntelliKitchen.xcworkspace" inside the directory. 
2. Select the "IntelliKitchen" scheme if it's not the current scheme. 
3. Select the iPhone version(we only support iPhone 11) you want to test on. 
4. Click on the "Run" button. 
5. When you finish building the project, and the simulator pops up, you can start testing.

### How to Run on the iPhone 11
1. Use a MacBook to open Xcode, and run the file "IntelliKitchen.xcworkspace" inside the directory. 
2. Select the "IntelliKitchen" scheme if it's not the current scheme. 
3. Select the iPhone version(in this case will be your own iPhone 11) you want to test on. 
4. On the left side, click on the icon “IntelliKitchen” on the top left corner.
5. On the main page, click on the “Signing & Capabilities” on the top bar.
6. Choose your own team in the “Team” setting.
7. Change “com.xu.IntelliKitchen” to something else, for example “com.xxx.IntelliKichen”.
8. Click on the “Try Again” button in the status.
9. Click on the "Run" button. 
10. When you finish building the project, and the simulator pops up, you can start testing.

### Known bugs
Expected behavior: After the user signs in with Google, the app shall redirect the user to the home page without displaying any alert.

- Actual behavior: Before the app redirects the user to the profile page, it may display the error “Please fill in all fields.” on the home page for a few seconds. It may also sometimes have less than a second delay on the sign in page before the app redirects the users to the profile page.

Expected behavior: In my chores list, if the user first turns on the remind function by clicking the “Remind” button, and then chooses to finish the chore, and the user will receive the notifications for later repeating tasks. 

- Actual behavior: In my chores list, if the user first turns on the remind function by clicking the “Remind” button, and then chooses to finish the chore, and the user will no longer receive the notifications for later repeating tasks. 

Expected behavior: When the user clicks on “View My Favorites”, and comments under the recipes from this list, and then goes back to the view my favorite list, it will double the amount of the recipes that was previously commented.


- Actual behavior: When the user clicks on “View My Favorites”, and comments under the recipes from this list, and then goes back to the view my favorite list, the number of recipes on this favorite list should remain the same. 

Expected behavior: After the user rates a recipe and clicks on the “Submit” button, the pop-up window shall disappear, and both the average rating and the number of people rated on the recipe detail page should automatically be updated. 

- Actual behavior: After the user rates a recipe and clicks on the “Submit” button, the pop-up window shall disappear, and both the average rating and the number of people rated on the recipe detail page will not be updated. Both of the data will be updated when we re-enter this page.

Expected behavior: When the user clicks on a recipe that has a very long recipe title,  the user is able to see both the recipe title, the recipe rating, and the recipe image separately.

- Actual behavior: When the user clicks on a recipe that has a very long recipe title, the 
recipe title may overflow and cover the recipe rating or/and the recipe image.

Expected behavior: When the user clicks into the recipe to see the details, the recipe name and the recipe details should match.

- Actual behavior: When the user clicks into the recipe to see the details, the recipe name 
and the recipe details don't match for a few certain recipes. (It’s because our database store the wrong information)

### Notes
After the user enters the recipe name/ingredients they want to search and click the “search” button, a recipe list will pop up. There might be repetitive recipe pictures. However, even if they have the same recipe picture shown, the recipes are actually different. They have either different ingredients or different instructions.

### Contacts for Technical Support
Jessica Zhong  --  Project Manager                         (858)900-5337
David Cheung   --  Software Development Lead               (415)269-4604
