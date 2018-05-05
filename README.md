# Canvas Craete Quiz


### Problem Statement

If an instructor wants to create the quizzes for his course, he need follow a set of steps and need to to do it manually. If an instructor has set of rules designed for the quizzes, he/she can replicate the same quizzes for other courses.

### Proposed Solution

Need to design a script which first fetches all the courses available. Once we have a list of courses, will ask for specific course for which an instructor is interested to create a quiz. After making the selection for a respective course, other part scripts will create a quiz with the predefined set of rules.

### Script Description

First, take the user's input such as course name and the quiz details like quiz name, description, type, the time limit
Fetch all the courses belongs to the respective instructor with the help of  course API (<canvas_url>/api/v1/accounts/self/course)
Filter the courses based on the user provided course name
If we found the courses for the user's specified requirement make a call to create the quizzes
It will take the quiz details and make a post call to create the quizzes (/api/v1/courses/:course_id/quizzes)
Notify based on the response to the user.


### Code Snippet
[Ruby File](final_ruby.rb)
 
### References

[Courses - Canvas LMS REST API Documentation](https://canvas.instructure.com/doc/api/courses.html)

[Quizzes - Canvas LMS REST API Documentation](https://canvas.instructure.com/doc/api/quizzes.html#method.quizzes/quizzes_api.create)

### Canvas Post
[Link](https://community.canvaslms.com/docs/DOC-14601)
