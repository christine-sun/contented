# contented

Demo video: https://youtu.be/6jADKte--WQ

## Overview
contented is a content creation management application that incorporates intention-setting, automated platform posts, and other features to motivate and support creators 

### 1. User Stories
* User can login
* User can create a new account
* User can add a new content task
* User can categorize content based on social media platform
* User can "check off" completed content tasks
* User can view upcoming tasks in the week and month
* User can categorize tasks into one project and have different calendar views depending on the project
* User can view content performance metrics
* User can find popular YouTube videos for a certain topic and directly add comments from the app
* User can enable dark mode
* User can color-categorize tasks
* User can add other users to manage the same tasks
* Gamification elements where completing tasks lets users gain points in the app

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

## Schema 
### Models
Task
| Property | Type  | Description  |  
|---|---|---|
| objectId  | String  | unique id for the task (default field) |  
| title  |  String | the title of the task  |  
| ideaDump  | String  | the description/ideas for the task  | 
| dueDate | DateTime | the due date for the task |
| platforms | Dictionary | Key is the platform String. Value is Boolean. If it's not in the dictionary at all, it was not assigned for this task |
| type | String | the type of the task, whether it's story, short, or long |
| completed | Boolean | determine whether task is completed or not. |
|User|Object|the user that created these tasks |
| image | Image | an image the user wants to associate with the task |

User
| Property | Type  | Description  |  
|---|---|---|
| objectId  | String  | unique id for the task (default field) |
| username |String||
| password |String||
|profile picture|image|
| platforms | Array | the array of social media platforms |

Idea
| Property | Type  | Description  |  
|---|---|---|
| objectId  | String  | unique id for the task (default field) |
etc for other channels| | |
| title | String | this idea's title
| location |String| where the idea is saved on the idea board |
| User |Object| the user that created this idea|


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
```
PFObject *task = [PFObject objectWithClassName:@"Task"];
gameScore[@"title"] = self.titleText.text;
gameScore[@"description"] = self.descriptionText.text;
```
* Analytics
    * (Read/GET) Get information about user's post statistics

### Milestones

There are a total of 20 days to work on this personal project.

Milestone 1 - Implement account creation (sign up, log in, log out) (<1 day)
- Set up Parse database
- Parse code
- Screen navigation

Milestone 2 - Creation mode for tasks (2 days)
- Create Task data model
- Configure Task class on Parse
- Create views
- Save user input 
- Segue to story, short, or long view based on type
- Upload to parse
- Notification for setting a task
- Connect camera?

Milestone 3 - Create task stream (2 days)
- Set up table view cells
- Set up table view cell headers
- Set up sections within table view and group based on date due/database
- Create UI for table view cells that show social media platforms associated with task (set image views to nil if platform is NOT in the dictionary)
- Create segue to details view
- Connect API that generates inspirational quotes
- Handle double tap gesture for quick task completion

Milestone 4 - Details View of task (2 days)
- Build view
- Handle updating the title/description/platforms when user chooses to edit
- Handle completing pushes
- Handle deleting the task when completed
- Notification for completing task

Milestone 5 - Analytics Tab (4 days)
- Obtain YouTube API authorization credentials
- Fetch current subscriber count when first logged in
- Display analytics with API and graph library

Milestone 6 - Idea Board (4 days)
- Add ability to add a new idea
- Move idea around on board
- Tap on idea to show option to delete it

Milestone 7 - Filter Tasks (2 days)
- Add filtering pop up options
- Enable user to change home view to completed or specified platform

Milestone 9 - UI (2 days)
- Add animations for when tasks are created and completed
- Create an introduction guide for when users are new to the app

Extra features: 
- Top videos commenting feature
- Show a list of completed tasks and allow users to un-complete the task
- Filter by platform on task stream
- Show platform button image and title, transition from black and white to color when creating
- collection view possibly for platform buttons
- have initial walkthrough screen on first sign up that shows importance of intention-setting and concept of pushes for platforms
- change color of stream cell depending on type of task
- create another tab for completed tasks
- login screen logic more laid out --> if you didn't have an account, notif, and also sign up is separate screen. forgot password
- google calendar integration to add tasks to a contented calendar to account

Credits
- Filtering Dropdown View
https://github.com/lminhtm/LMDropdownView
- Charts library
https://github.com/danielgindi/Charts
- Draggable View
https://github.com/andreamazz/UIView-draggable
