# Radar Doppler Processing project 
This project was part of a master level class that i took in Radar Engineering. Here i will provide the Project statement, some explanations, Results, and my code which is well commented and self-explanatory .  

# The Project statment
This project involves fast- and slow-time processing of a 1GHz, pulsed-Doppler radar to generate the range-Doppler map of 5 moving targets. The targets’ range and speed will be randomly generated using matlab functions.

The reflectivity of the finve targets are  1, 0.5, 0.25, 0.25, and 0.1\
The combined echoes from each target is given by:\
<img width="389" alt="Screen Shot 2020-06-03 at 5 52 08 AM" src="https://user-images.githubusercontent.com/57555013/83622885-93004a00-a55e-11ea-99b3-b1f9169cff46.png">

where t is the fast-time and m is the slow-time pulse index. b(t) is the Barker code and k0 is the radar propagation constant.
􏰈
* Fast-Time Processing (Ranging)
Barker codes are used for ranging in this radar. Simulate a 13-chip Barker code. Assume that the pulse width is 10uS. Assume that the detection is clutter limited. Clutter is modeled by assuming that the clutter amplitude in any time sample has a magnitude which is Rayleigh distributed and a phase that is uniformly distributed. Clutter power can be controlled by changing the SCR. A single clutter sample may be modeled by\
𝑐(𝑡, 𝑚) = sqrt( 􏰋−2 × log􏰌(1 − 𝐫𝐚𝐧𝐝)/SCR ) × exp(2𝜋 × 𝐫𝐚𝐧𝐝 × 𝑗) notace that the log is base e\
For fast-time processing use a sampling rate of 10MHz (inter-sample period of 0.1uS. Generate the echo for 100uS (1000 samples) after the transmission of each pulse. For each of the 1000 samples generate an independent value of clutter. Use the matched filter for the Barker code to bin the echoes into (1000+200) range bins. The additional 200 bins is for the beginning and the end, since there will be 100 samples per pulse.

* Slow-Time Processing (Doppler)
Use a PRF of 1000Hz (T = 1ms). Generate the echoes from 1024 pulses in slow-time. Perform slow-time processing by taking the Fourier transform of the 1024 pulses along each of the 1200 range bins. Generate an intensity map (1024x1200) which shows the range and Doppler of each of the 5 targets. Also place a ‘+’ at the actual location of the target, which is known in the simulation. Note the intensity distributions should be centered at these ‘+’s. Convert the slow-time axis to Doppler frequency in Hz and the fast-time axis to range in meters. Note the clutter will be the same for each pulse, i.e. use the same 1000 clutter values for all the pulses.\

Generate the range-Doppler maps for different signal-to-clutter (SCR) ratios: 20dB, 10dB, 3dB, 0dB, -10dB.


# General info and explnations
what is fast time and slow time ?

<img width="1223" alt="Screen Shot 2020-06-03 at 6 21 42 AM" src="https://user-images.githubusercontent.com/57555013/83625829-8f6ec200-a562-11ea-9a88-33bb277afc9c.png">


The Goal is to create a matrix of 1024 range bins, each bin has 1000 pulses.\
Slow time = updates each PRI, means one pulse each time, 1000 pulses, each cube is 1 PRI long in slow time.\
The time within a single pulse is fast time. The time between pulses is slow time.\
Fast-time refers to the number of range bins or range samples for a given pulse representing range delay.\
Slow time is just the number of pulses.\

in fast time different time slots composing a PRI, means inside each PRI, deferent times. We can say we got 1024-time resolution and 1000 PRI
Each pulse in x axis.\
If at x=2, the second pulse, the fast time =10. Then the next pulse at x=3, the target
Still at fast time = 10, means target is not moving.\
If in the next pulse at x=4 we go above to the corresponding y value and the target is moved to
Fast time y= 14 means it’s moving.\
The time within a single pulse is fast time. The time between pulses is slow time.

FFT\
Using FFT we move from slow time to Doppler frequency and from fast time to range.\
Why: because in a moving target the phase information appears in each received pulse.\
Different returns can be separated in Doppler domain instead of time domain.\
so,\
When we move from fast time to Range, each y value become range, 
When we move from slow time to Doppler, each x value become doppler frequency

When two targets in the same y "range" but different x "doppler" it means that the two targets in the same range but with different velocities.\
Doppler frequency and velocities are related by 
If two targets same Doppler but different range means they’re at the same velocity but different ranges.

# Project procedure:
1. Generate five ranges, five speeds, and fife reflectivity using rand functions.

2. Find Echo of each target using the equation, knowing that the echo will always be 2R/C delayed from original signal. So my (to) ia 2R/C.

3. in the echo equation, we get t-2R/C. (t) here is the fast time because we are interested in seeing the echo of each pulse.

4. using barker code for compressing by making pulses go with 180 phase shifts to increase bandwidth without losing resolution. In this radar it’s used for ranging. 

* Starting with Fast time processing (Ranging)
Fast pulse is .1 microseconds, we are generating 100 microseconds, so 1000 samples. \
After each pulse, or each M Slow time, or at each X, we generate a new clutter for each of these 1000 samples.\
I will use a matched filter for barker code to bin the echoes into 1200 range for additional 200 bins.


* Slow-Time Processing (Doppler) 
Using PRF = 1000 Hz, T=1ms and using the echo equation,
I generated 1024 echoes from 1024 pulses and stack these echoes in my (S). 
Then I took FFT of 1024 echoes, or pulses, along 1200 range bins.


# Results

The five targgets in doppler vs range plots:

<img width="558" alt="Screen Shot 2020-06-03 at 5 36 09 AM" src="https://user-images.githubusercontent.com/57555013/83626513-86cabb80-a563-11ea-9650-e3b18a976c22.png">

tarrgets with negetive doppler frequecy are moving away from the radar, and the positive ones are coming toward it.

Echo signal and matched filter output:

<img width="558" alt="Screen Shot 2020-06-03 at 5 36 21 AM" src="https://user-images.githubusercontent.com/57555013/83626822-0193d680-a564-11ea-8f05-7d834a072f27.png">

Notace that whenever we have spile in both the matched filter output and the echo signal, we detect a target.

Data cube:
the daata cube isn't needed for this proejct, but i wanted to plot it in order to see tha barker code phase shifts and the echo of my targets.


<img width="558" alt="Screen Shot 2020-06-03 at 5 36 14 AM" src="https://user-images.githubusercontent.com/57555013/83628203-1cffe100-a566-11ea-9aa8-8431e6cefd53.png">





