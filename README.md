#  Smarter iOS Calculator

Ahmed Al-Zahrani

Smarter iOS calculator created as assignment #2 of CS193P (iOS Application Developement) at Stanford University.

- Lectures can be found for free on Youtube starting [here](https://www.youtube.com/watch?v=HitSIzPM_6E)

- A google drive with the relevant slides/lecture notes/reading and programming assignments can be found [here](https://drive.google.com/drive/folders/0B2jVD1XhtYtRc3F2ZnZ4ZUVFODg)

- The specific assignment specs for this assignment can be found within this directory as a PDF


This assignment expands upon the capabilities of the simple calculator from assignment 1 by allowing for variables to be used as input, as well as allowing for an undo button.

Additionally, the calculator brain was tweaked such that instead of making changes to public vars result, isPending, and description, there is now a method evaluate that is constantly called from the Controller and returns a tuple of the current result if any), the current Bool representing whether or not a binary operation is pending, as well as the current description of operations to be displayed for the user.
