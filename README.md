
<h2> KadMotion

<h3> Description 
<h5> This is a project that integrates computer vision with machine learning applied to audio and visuals. Processing gets pixel data, collected by a built-in camera or webcam (Capture class), and it sends it through the WekInputHelper and Wekinator, where it will be filtered and mapped through the machine learning algorithms.
Finally, ChucK will receive the final data, which will be used to control a system of sine waves.

<h3> Instructions

<h5> This project includes four main parts, which should be ran independently:
1. PDE Files: Run from the Processing application.
2. WekInputHelper File: Open motionInputHelper.inputproj.
3. Wekinator Files: Open Motion/WekinatorProject/WekinatorProject.wekproj.
4. Demo Script - ChucK Files (.ck): Open and run init.ck from miniAudicle.

Usage: Every time the camera "detects" movement, it will show it on the screen, and it will have an effect on the audio elements of the demo chuck script.

<h3> Feature Extractor
<h5> In its current state, "KadMotion" is a feature extractor that tracks movement (with a few minor tweaks to fit this Kadenze assignment) by receiving camera input, and comparing the current state of the pixels with the previous frame, and sending out three "motion index values":
1. Overall pixel change
2. Changes on the left side of the screen
3. Changes on the right side of the screen

> These values are normalized; 0 indicates no movement, and higher values indicate more movement.




