
<h1> KadMotion

<h2> Description 
<h4>> This is a project that integrates computer vision with machine learning applied to audio and visuals. Processing gets pixel data, collected by a built-in camera or webcam (Capture class), and it sends it through the WekInputHelper and Wekinator, where it will be filtered and mapped through the machine learning algorithms.
Finally, ChucK will receive the final data, which will be used to control a system of sine waves.

<h2> Instructions

<h4>> This project includes four main parts, which should be ran independently:
>>  1. PDE Files: Run from the Processing application.
>>  1. WekInputHelper File: Open motionInputHelper.inputproj.
>>  1. Wekinator Files: Open Motion/WekinatorProject/WekinatorProject.wekproj.
>>  1. Demo Script - ChucK Files (.ck): Open and run init.ck from miniAudicle.

> Usage: Every time the camera "detect" movement, it will show it on the screen, and it will have an effect on the audio elements of the demo chuck script.

<h2> Feature Extractor
<h4>>> In its current state, "KadMotion" is a feature extractor that tracks movement (with a few minor tweaks to fit this Kadenze assignment) by receiving camera input, and comparing the current state of the pixels with the previous frame, and sending out three "motion index values":
>> 1. Overall pixel change
>> 1. Changes on the left side of the screen
>> 1. Changes on the right side of the screen

> These values are normalized; 0 indicates no movement, and higher values indicate more movement.




