# MATLAB-Data-Tagging-Tool-GUI (Version 0.3 beta)
This tool was developed in MATLAB 9.4.0.813654 (R2018a)
## Purpose of the GUI Tool
This MATLAB GUI was developed for tagging photoplethysmogram amplitude signals with risk levels, as a preparation for future analysis of the data with machine learning & deep learning techniques.  
The data-tagging Tool can be modified for other tagging tasks.  
For users who do not have access to data, you can play with 'fake_data_for_testing.mat' to learn how this GUI tool works.
## Introduction of the GUI objects/elements
![alt text](files_for_readme/GUI_objects_no_Mosaic.png 'GUI of the data-tagging tool')
#### 1. Signal plot
Horizontal axis is __identical__ for all signals, ranging from -20 min to 60 min, with baseline start at 0 min. Two red reference lines are the start and the end of the true baseline.  
Vertical axis is __identical__ for all signals by default, ranging from 0 to 2, but you can set it to be flexible by uncheck the "Fix Y-axis" checkbox. Two black reference lines are 95% maximum value (which is always 1) and 0.5 respectively.  
Current signal index number and total number of signals is shown in the title of the plot.  
Preview signals have a non-positive index number while signals to tag have a positive index number.
#### 2. Load Data
Load the signals to be tagged.
#### 3. Load work
Load your unfinished work to continue working on the tags.
#### 4. Reset work
Reset all the tags you have marked.
#### 5. Previous
Show the previous signal.  
Hotkey for this push button: alt + leftarrow
#### 6. Next
Show the next signal.  
Hotkey for this push button: alt + rightarrow
#### 7. Jump to
Jump to a certain signal according to the index number.
#### 8. Author/Marker
Name of the researcher/clinician who tags the signal.
#### 9. Save work
Save your work.  
This push button was placed far away from the load and the reset buttons to prevent misclicks.
#### 10. Risk level tagging buttons
Tag the current signal with a certain risk level.  
Hotkey1: alt + {RL}  
Hotkey2: alt + numpad{RL}   
substitute {RL} with the actual risk level of the signal that you want to tag. e.g. alt + 2, alt + numpad2  
The number keys represented by {RL} are located to the top of 'qwerty' region of the keyboard. If you have a full size (104-key-keyboard) keyboard, you will have a numpad to the right of the arrow keys, numpad{RL} refers to the number keys in the numpad.  
In addition, there is one more hotkey for tagging risk level 0: alt + backquote  
'backquote' is the key locating to the left of '1'. It looks like \` or ~ on your keyboard.
#### 11. Tagging history
The tags you assigned during this work period.
The purpose of showing this information is for clinicians to confirm that they had assigned the intended risk level for the signal i.e. to prevent misclicks, especially when GUI automatically moves to the next signal after clinicians tag the latest signal. Thus the history is cleared after "Load Work", because all saved work are assumed to have no misclicks, just like the situation that you will not have the "undo" option after opening a saved file.  
## General Work Flow
1. Launch the GUI tool by running PPGa_Tag_Tool.m in MATLAB.  
2. All signals are shown in random orders, and normalized to 95% maximum value of themselves. After you load the data, you will be first shown some preview signals from a wide range of different risk levels to give you an overall impression of the signals. The preview signals will have non-positive index number (shown in the title of the signal plot) and the risk level tagging tools will be disabled during preview.
3. As you move forward to the signals to be tagged (signals with a positive index number), the risk level tagging tools will be enabled, and you can begin tagging the signals with either mouse clicks or hotkeys.
4. Each signal will be repeated twice (for a total time of 3, for each signal) for consistency check.
5. You can save your work at any time and finish them later. To save your work, first and last name are needed.
6. Once you finished tagging, a "Thank You!" message will pop out as a reminder.

## Known Mac version MATLAB bug while using hotkeys
In Mac, by default (at least for macOS 10.13), if you press and hold some key with character accents popup (e.g. 'a', 'e', 's', etc.), a row of character accents will be triggered (as shown in the image below)  
![alt text](files_for_readme/character_accents_popup.png 'character accents popup')  
If you trigger the character accents popup in the GUI tool, the tool will not be able to capture any subsequent key presses of non-functional keys (e.g. '1', 'a')  
I have checked this problem with MATLAB support, and unfortunately there is no workaround within MATLAB at this time. The development team of MATLAB is currently investigating a solution so that this bug can be fixed in some future release of MATLAB.
#### Temporary solution
1. Save your work. Close the GUI. Relaunch the GUI. Load data and your saved work. You need to do this every time you encounter the bug.
2. Disable the character accents popup and enable key repeats by executing the following command in the Mac terminal:
```
defaults write -g ApplePressAndHoldEnabled -bool false
```
Once the command has being executed, relaunch MATLAB and relaunch the GUI tool to make the changes effective. You will not encounter the same bug again until you change the settings back by executing the following command in the Mac terminal:
```
defaults write -g ApplePressAndHoldEnabled -bool true
```
Relaunch MATLAB to make the changes effective.
