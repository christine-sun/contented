# Original App Design Project

# contented

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
contented is a content creation management application that incorporates intention-setting and other follower-boosting methods to motivate and support creators 

### App Evaluation
- **Category:** Productivity
- **Mobile:** Since the app is intended to be intuitive and easily accessible, mobile is the main focus for contented's MVP, though expansion to a companion web-app is possible for the future. Weekly notifications for content intention-setting also depends on mobile's readiness for users.
- **Story:** Enables users to plan content creation goals across social media platforms 
- **Market:** People interested in content creation and growing a following on the internet could utilize this app.
- **Habit:** Users set intentions at the beginning of each week and, depending on how often they want to post, check in multiple times throughout the week to ensure they stay on track.
- **Scope:** contented would start out with a focus on intention-setting and have a view of the content creator's week/month. Later versions would include tools to help boost creator's following, such as pointing out where to comment on popular YouTube videos to draw attention to user's channel. Later versions could also incorporate social aspects for multiple users to work on a certain handle and/or support each other.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**

* User can login
* User can create a new account
* User can add a new content task
* User can categorize content based on social media platform
* User can "check off" completed content tasks
* User can view upcoming tasks in the week and month

**Optional Nice-to-have Stories**

* User can categorize tasks into one project and have different calendar views depending on the project
* User can view content performance metrics
* User can find popular YouTube videos for a certain topic and directly add comments from the app
* User can enable dark mode
* User can color-categorize tasks
* User can add other users to manage the same tasks
* Incorporate gamification elements where completing tasks lets users gain points in the app

### 2. Screen Archetypes

* Login/Register
   * User can login
   * User can create a new account
* Stream
   * User can view upcoming tasks in the week and month
* Detail
    * User can "check off" completed content tasks
* Creation
    * User can add a new content task
    * User can categorize content based on social media platform
* Analytics
    * User can view how their recent posts have been performing

Nice to have
* Profile
    * User can view content performance metrics
    * Incorporate gamification elements where completing tasks lets users gain points in the app

* Calendar
    * User can view upcoming tasks in the week and month

* Settings
    * User can enable dark mode
    * User can add other users to manage the same tasks



### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Task Stream
* Creation
* Calendar

**Flow Navigation** (Screen to Screen)

* Login Screen
    => Task Stream
* Stream
    => Detail
* Calendar
    => Detail
* Creation
    => None
* Detail
    => None

## Wireframes

For best viewing quality see:
https://imgur.com/a/dbl3uCM

![](https://i.imgur.com/V8z86B4.jpg)

![](https://i.imgur.com/UxQqQeG.jpg)

![](https://i.imgur.com/346MdAN.png)

### [BONUS] Digital Wireframes & Mockups
Content Stream 
![](https://i.imgur.com/ChgWcwK.png)

Calendar 
![](https://i.imgur.com/1oyEQeQ.png)

Creation
![](https://i.imgur.com/hoAglZt.png)

Analytics

![](https://i.imgur.com/76whKAk.png)


### [BONUS] Interactive Prototype

## Schema 
### Models
Task
| Property | Type  | Description  |  
|---|---|---|
| objectId  | String  | unique id for the task (default field) |  
| title  |  String | the title of the task  |  
| description  | String  | the description/ideas for the task  | 
| dateDue | DateTime | the due date for the task |
| platforms | Dictionary | Key is the platform String. Value is Boolean. If it's not in the dictionary at all, it was not assigned for this task |
| type | Number | the type of the task, with 0 = story, 1 = short, and 2 = long. We should make this a defined enum https://riptutorial.com/objective-c/example/15598/defining-an-enum |
| status | Boolean | determine whether task is completed or not. After user edits the task, check whether all channels have been marked as completed. If true, then this status is true. Or create a method like "getStatus" that will check through the Dictionary so we do not have to keep status in sync with Dictionary |
|User|Object|the user that created these tasks |

User
| Property | Type  | Description  |  
|---|---|---|
| objectId  | String  | unique id for the task (default field) |
| initialSubs | Number | the amount of subscribers the User has when they first connect to the app |
|YouTube ID| Number| user's youtube account
etc for other channels| | |
| Tasks | Array| this user's tasks
| username |String||
| password |String||
|profile picture|image|

### Networking
**List of network requests by screen**
* Stream
   * (Read/GET) Fetch all upcoming tasks
* Detail
    * (Update/PUT) Change title/description of task
    * (Update/PUT) Change whether task for a platform has been checked off
    * (Delete/DELETE) Task has been completed
* Creation
    * (Update/PUT) Create new task with title, description, and pushes
* Analytics
    * (Read/GET) Get information about user's post statistics
- [Create basic snippets for each Parse network request]
- [OPTIONAL: List endpoints if using existing API such as Yelp]

### Milestones

There are a total of 20 days to work on this personal project.

Milestone 1 - Implement account creation (sign up, log in, log out) (<1 day)
- Set up Parse database
- Parse code
- Screen navigation

Milestone 2 - Creation mode for tasks (3 days)
- Create Task data model
- Configure Task class on Parse
- Create views
- Save user input 
- Segue to story, short, or long view based on type
- Upload to parse
- Notification for setting a task
- Connect camera?

Milestone 3 - Create task stream (4 days)
- Set up table view cells
- Set up table view cell headers
- Set up sections within table view and group based on date due/database
- Create UI for table view cells that show social media platforms associated with task (set image views to nil if platform is NOT in the dictionary)
- Create segue to details view
- Connect API that generates inspirational quotes
- Handle double tap gesture for quick task completion

Milestone 4 - Details View of task (3 days)
- Build view
- Handle updating the title/description/platforms when user chooses to edit
- Handle completing pushes
- Handle deleting the task when completed
- Notification for completing task

Milestone 5 - Analytics Tab (4 days)
- Obtain YouTube API authorization credentials
- Fetch current subscriber count when first logged in
- Display analytics with API and graph library

Milestone 6 - Notification (1 day)
- Send weekly notifications on Sunday evenings to be intentional for one's tasks

Milestone 7 - UI (2 days)
- Add animations for when tasks are created and completed
- Add phone vibration modes for when tasks are completed
- Create a dark mode
- Create an introduction guide for when users are new to the app

Remaining time: 
-Top videos commenting feature
-Show a list of completed tasks and allow users to un-complete the task
-Filter by platform on task stream
