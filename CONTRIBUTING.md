Contributing Guidelines  🤝🏽🍀:

This documentation contains a set of guidelines to help you during the contribution process.
We are happy to welcome all the contributions from anyone willing to improve/add new scripts to this project. Thank you for helping out and remember, no contribution is too small.
Each participant/contributor will be assigned 2 issues (max) at a time to work.
Participants/contributors have 7 days to complete issues. After that issues will be assigned to others.
Participants/contributors have to comment on issues they would like to work on, and mentors will assign you.
Issues will be assigned on a first-come, first-serve basis.
Participants/contributors can also open their issues, but it needs to be verified and labeled by a mentor.
Before opening a new issue, please check if it is already created or not.
Pull requests will be merged after being reviewed by a mentor.
Create a pull request from a branch other than main.
It might take a day to review your pull request. Please have patience and be nice.
We all are here to learn. You are allowed to make mistakes. That's how you learn, right!
Pull Requests review criteria:
Please fill the PR template properly while making a PR
You must add your code file into the respective folders.
Your work must be original, written by you not copied from other resources.
You must comment on your code where necessary.
For frontend changes kindly share screenshots and work samples of your work before sending a PR.
Follow the proper style guides for your work.
For any queries or discussions, please drop a message in our SWOC slack channel or DWOC discord server
Submitting Contributions👩‍💻👨‍💻
Below you will find the process and workflow used to review and merge your changes.
Step 0: Find an issue 🔍
Take a look at the Existing Issues or create your own Issues!
Wait for the Issue to be assigned to you after which you can start working on it.
Note: Every change in this project should/must have an associated issue.

Step 1: Fork the Project 🍴
Fork this Repository. This will create a Local Copy of this Repository on your Github Profile. Keep a reference to the original project in an upstream remote.
$ git clone https://github.com/<your-username>/Community-Website  
$ cd <repo-name>  
$ git remote add upstream https://github.com/HITK-TECH-Community/Community-Website 
 

Update your forked repo before working.
$ git remote update  
$ git checkout <branch-name>  
$ git rebase upstream/<branch-name>  
 
Step 2 : Branch 🔖
Create a new branch. Use its name to identify the issue you are addressing.
# It will create a new branch with the name Branch_Name and switch to that branch 
$ git checkout -b branch_name  
 
Step 3: Work on the issue assigned 📕
Work on the issue(s) assigned to you.
Add all the files/folders needed.
After you've made changes or made your contribution to the project add changes to the branch you've just created by:
# To add all new files to branch Branch_Name  
$ git add.  
 
# To add only a few files to Branch_Name
$ git add <some files>
 
Step 4: Commit
To commit give a descriptive message for the convenience of the reviewer by:
# This message get associated with all files you have changed  
$ git commit -m "message"  
 
Commit message guidelines
Each commit message consists of a header, a body and a footer. The header has a special format that includes a type, a scope and a subject:
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
 
Any line of the commit message cannot be longer than 100 characters! This allows the message to be easier to read on GitHub as well as in various git tools
Example commit message
feat(Profile): display QR code
 
fetch the QR code from API and display it on the Profile page (ProfileFragment.kt)
 
fixes #1234
 
A good rule of thumb for the commit message is to have a present tense verb, followed by whatever it is you're doing in as much detail as possible in 50 chars. Capitalize words correctly and follow general English.
For more details, visit
Git commit message guidelines
Writing Good Commit Messages: A Practical Git Guide
Step 5: Work Remotely
Now you are ready to your work to the remote repository.
When your work is ready and complies with the project conventions, upload your changes to your fork:
# To push your work to your remote repository  
$ git push -u origin <branch_name>  
 
Here is how your branch will look.

Step 6: Pull Request 🎣
Go to your repository in the browser and click on compare and pull requests. Then add a title and description to your pull request that explains your contribution.

Voila! Your Pull Request has been submitted and will be reviewed by the moderators and merged.🥳
 
Guidelines for raising a pull request:
Each pull request should have an appropriate and short title like "Fixed Bug in Upload Page"
Describe your intended changes in the description section of the pull request (Use bullet points and phrases)
Refrain from using phrases like "Hi, I am ..", "Please merge me this OPR", "Thank You..", etc. We are only interested in technical parts
Attach a screenshot/clip of the change(s)
Make sure to refer to the respective issue in the respective PR using phrases like Resolves #issue_number or Closes #issue_number.
Please be patient enough. The project maintainers/mentors would review it as per their schedule. Please do not start putting comments like "Please check this" etc.
Although we support feedback from everyone in all phases of development, it is highly advised not to put any negative comments in other participant's pull requests.
Always keep a note of the deadline.
Need more help?🤔
You can refer to the following articles on the basics of Git and Github and also contact the Project Mentors, in case you are stuck:
Forking a Repo
Cloning a Repo
How to create a Pull Request
Getting started with Git and GitHub
Learn GitHub from Scratch
Tip from us😇
It always takes time to understand and learn. So, do not worry at all. We know you have got this!💪
Open Source Program Grading
Mexili Winter of Code
Distribution
Difficulty
Score
Easy
25
Medium
50
Hard
100

Allotment:
When accepting the PR, add the following label before merging it. user=:score=, e.g. if the user sansyrox has filled a relevant PR and you are allotting 100 marks to him, add the following label user=sansyrox:score=100 to the PR.
IEEE DTU Cross Winter of Code
Distribution
Difficulty
Score
Easy
-
Medium
-
Hard
-

Allotment:
Add labels to PRs
Maintain a Contributor.MD for CrossWoC
JGEC Winter of Code
Distribution
Difficulty
Score
Easy
1
Medium
3
Hard
5

Allotment:
Add labels to PRs [ Must add JWOC label]
Maintain an excel sheet
Mentee Name
GitHub Profile
PR Number
Easy
Medium
Hard
Total Points

GirlScript Summer of Code 2021
Difficulty
Intent
Score
Level0
GSSOC Minor Documentation
 
Level1
GSSOC Major Documentation
 
Level2
GSSOC Bug fixing, adding small features
 
Level3
GSSOC New features, major bug fixing.
 

Allotment:
Add labels to PRs [ Must add gssoc21 label]
 
