# Foucault Pendulum

Make "Foucault Pendulum" using Phoenix LiveView.  
[Foucault Pendulum : Wikipedia](https://en.wikipedia.org/wiki/Foucault_pendulum)
  

## Screen shot 

![fp_preview2](https://user-images.githubusercontent.com/36530245/111269411-f41e8780-8671-11eb-83ba-a54fea1e1a21.gif)

## Description
This Project show Foucault pendulums movement by latitude information.
The left side in web page show latitude, and the right side show the floor of Pantheon.
In this floor, there is a projection of the movement of the pendulum.

This process made by Phoenix Liveview.
There are virtual time and x, y coordinator infomation in socket, and the elixir module calculate the pendulum's position using this information.
Phoenix Liveview can show this calculated results rapidly by using web socket.

## Website
https://fp.breakfolly.com/ 

