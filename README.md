# Enrollment System

## Setup Instructions

1. **Install Swift**: You will need Swift 5.0 or higher installed.

2. **Run the Program**:
- Open the `EnrollmentSystem.swift` file in Xcode or any other text editor of your choice.
- You can execute the program by running:
  ```
  swift EnrollmentSystem.swift
  ```

## Example of System Usage

The system allows students to enroll in courses and validates their eligibility based on age and prerequisites. Here's a quick example of how it works

swift
let student = Student(name: "John Doe", age: 20, studentID: "S001")
let course = Course(title: "Swift Programming", availableSlots: 2)
let enrollmentSystem = EnrollmentSystem()

enrollmentSystem.addCourse(course: course)
enrollmentSystem.addStudent(student: student)

enrollmentSystem.enrollStudentInCourse(student: student, course: course, minAge: 21, prerequisite: "CS101")
