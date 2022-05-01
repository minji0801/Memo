<div align="center">
  
  <!-- Header -->
  [![header](https://capsule-render.vercel.app/api?type=waving&color=000000&height=250&section=header&text=memo&desc=Simple%20Memo%20App&descAlignY=55&fontSize=75&fontAlignY=35&fontColor=FFFFFF)](https://github.com/minji0801/TimeCalculator)
  
  <!-- Badge -->
  ![GitHub](https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=GitHub&logoColor=white)
  ![iOS](https://img.shields.io/badge/iOS-000000?style=flat-square&logo=iOS&logoColor=white)
  ![Xcode](https://img.shields.io/badge/Xcode-147EFB?style=flat-square&logo=Xcode&logoColor=white)
  ![Swift](https://img.shields.io/badge/Swift-F05138?style=flat-square&logo=Swift&logoColor=white)
  ![Figma](https://img.shields.io/badge/Figma-F24E1E?style=flat-square&logo=Figma&logoColor=white)


<img width="200" src="https://user-images.githubusercontent.com/49383370/166145321-90612c7a-6589-4119-9c36-3b6699fa4500.mov">


</div>

<!-- Navigation -->
# Navigation
1. [Motive](#Motive)
2. [Goals](#Goals)
3. [Note list and search](#Note-list-and-search)
4. [writing notes](#writing-notes)
5. [Edit notes](#Edit-notes)
6. [Delete notes](#Delete-notes)
7. [Design](#Design)

<br/>

<!-- 1. Motive -->
## Motive
It was developed to participate in the ```'The 1st 빡 Coding Con event'``` hosted by the YouTuber ```'개발하는 정대리'```.

[Go to '개발하는 정대리' channel](https://www.youtube.com/c/%EA%B0%9C%EB%B0%9C%ED%95%98%EB%8A%94%EC%A0%95%EB%8C%80%EB%A6%AC)

<br/>

<!-- 2. Goals -->
## Goals
👩🏼‍💻 Screen composition:
- Memo list screen
- Memo detail screen
- Memo editing, writing screen

⭐️ Features:
- Users should be able to see the list of notes they have made
- For memos exposed in the memo list, only one written memo sentence is exposed.
- You can write a memo on the memo page.
- When writing a memo, the number of characters in the written memo is exposed.
- Users should be able to search for notes.
- Users should be able to edit notes.
- Users should be able to delete memos.
- The written memo can be changed to a secret memo.

🔐 Secret Note:
- The memo text is not exposed in the memo list.
- On the memo list screen, “This is a secret memo” or a lock mark is displayed.
- If you click View Details in the memo list, you must enter a password to move to the memo detail screen in case of a secret memo.
- Normal memos can be converted into secret memos on the memo detail screen.
- When setting as a secret memo in the general memo, the password input window appears, and when the password is entered, it is changed to a secret memo.
- Additional functions and screens can be freely added including the above requirements

<br/>

<!-- 3. Note list and search -->
## Note list and search
On the memo list screen, you can view the memos created in a list format and search for memos. Also, you can move to the screen where you can write a memo.

Secret notes cannot be viewed, and a lock icon is displayed.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166103039-2119b5d8-17b5-4a7b-a19f-6e30ebb4c022.png"></p>

You can search for notes that contain what you are looking for by clicking the search bar. Use the ```textDidChange``` method of ```UISearchBarDelegate``` to retrieve the content whenever the search term changes.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166103086-a90db0f0-7757-42de-991c-4d2bbbfee5db.png"></p>

And secret notes can only be viewed by entering a password.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166104100-d3d4181d-c1f0-4dd1-bc5b-0183828ff926.png"></p>

<br/>

<!-- 4. writing notes -->
## writing notes
On the memo writing screen, you can check the number of characters and lock the memo. The keyboard is set to always be visible and the number of characters of what you typed is displayed directly above the keyboard.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166103132-afeaae54-c94f-4645-949e-d0f769e6cb7b.png"></p>

You can lock notes by entering a password. When a password is entered, ```NotificationCenter``` detects it, applies the entered password and updates the lock icon.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166104108-b0fc043f-0fef-4845-9030-a62ca7de5d2a.png"></p>

<br/>

<!-- 5. Edit notes -->
## Edit notes
The edit memo screen uses the memo writing screen. To distinguish between the two, pass the ```isEditing: Bool``` value when accessing the screen. The function is the same as the memo writing screen, but it is different when saving the edited(writied) memo.

In the case of a new memo, ```a new ID value``` is given to save the memo, but when editing an existing memo, ```the existing ID value``` is imported and used.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166103133-c4b80d08-ded1-41a6-b503-1ca6902f2fd1.png"></p>
<br/>

<!-- 6. Delete notes -->
## Delete notes
You can delete a memo on the memo detail screen. Click the Delete button in the pop-up menu to open the Alert window and check again.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166103134-d8bdcb3f-1aa6-485b-8725-da9c677b0ccf.png"></p>

You can delete by sliding the end of the TableView on the memo list screen without going to the memo detail screen. I implemented this using ```UITableView```'s ```trailingSwipeActionsConfigurationForRowAt``` method.

<p align="left"><img width="200" src="https://user-images.githubusercontent.com/49383370/166103922-695b3bfe-57e3-41c8-a776-54fe6493ae9c.png"></p>

<br/>

<!-- 7. Design -->
## Design
### App Icon
I made it simple so that you can know at once that it is a memo app.

<p align="left"><img width="100" src="https://user-images.githubusercontent.com/49383370/166102825-7efa7fd8-6fad-413a-97c7-8ad6659e273f.png"></p>

### UI/UX
<p align="center"><img alt="UI/UX Light Mode" src="https://user-images.githubusercontent.com/49383370/166102878-0df41e69-13b8-4b6f-9fbd-8a5dc1a93d58.png"></p>

<br/>
<br/>

---

<br/>
<br/>

<!-- Footer -->
<div align="center">
  
  <!-- GitHub Stats -->
  <a href="https://github.com/minji0801"><img src="https://github-readme-stats.vercel.app/api?username=minji0801&show_icons=true&theme=dark"/></a>
  
  <br/>
  <br/>
  <br/>
  
  <!-- Hit -->
  <a href="https://github.com/minji0801/Modakyi"><img src="https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fminji0801%2FMemo&count_bg=%23000000&title_bg=%23555555&icon=github.svg&icon_color=%23E7E7E7&title=hits&edge_flat=false"/></a>
</div>
