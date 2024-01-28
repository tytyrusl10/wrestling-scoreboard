# Wrestling Scoreboard

A wrestling scoreboard that includes a riding time clock. No other wrestling scoreboard apps seem to include collegiate riding time clocks. 

this project was written with Flutter and is deployable to most devices and operating systems.

![image](https://github.com/KJBurnett/wrestling-scoreboard/assets/9143189/666f6271-63f9-4ed8-8cfc-3923c8c0a8f9)


## TODO
- For some reason if you play/pause the clock quickly, the clock will tick twice as fast.
- We should automate the scoring and riding time. For example, create 3 buttons; takedown (3 points), reversal (2 points), escape (1 point) for both blue and red. So 6 buttons total. If a color gets a takedown or a reversal, the riding time should start ticking for that color who is now in top control. If the other color gets an escape, the riding time clock should pause. Additionally ensure the riding time clock pauses when the main clock pauses.
- Figure out how to anchor the widgets and elements so the app is more friendly to resize for different sized monitors.
- Add 3 green lights for rounds/periods
- Add a 4th yellow light for "overtime"
- Make the main clock, and riding time clock modifiable. We should investigate whether it's better to allow the user to directly change the clock via keyboard inputs, or if we should add minute + second buttons which change the time in the event of a mistake on the score's main clock or riding time clock.
- Add the ability to type in the wrestler's names for blue and red color.
- Increase main clock widget size.
