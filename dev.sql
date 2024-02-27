-- define a select statement to get all students enrolled in a course
-- and the course name, location name, and instructor name.
SELECT
	students.first_name,
	students.last_name,
	subjects.course_name,
	locations.location_name,
	staffs.first_name AS instructor_first_name,
	staffs.last_name AS instructor_last_name
FROM
	courses.students
JOIN
	courses.registrations
ON
	students.student_id = registrations.student_id
JOIN
	courses.registration_items
ON
	registrations.registration_id = registration_items.registration_id
JOIN
	curriculum.subjects
ON
	registration_items.course_id = subjects.course_id
JOIN
	courses.staffs
ON
	registrations.staff_id = staffs.staff_id
JOIN
	courses.locations
ON
	registrations.location_id = locations.location_id;


-- write an index to improve the performance of the query
CREATE INDEX idx_student_id ON courses.students (student_id);
CREATE INDEX idx_registration_id ON courses.registrations (registration_id);
CREATE INDEX idx_course_id ON curriculum.subjects (course_id);

-- define a stored procedure to get course enrollment by location

CREATE PROCEDURE courses.get_course_enrollment_by_location
    @location_id INT
AS
BEGIN
    SELECT
        subjects.course_name,
        COUNT(registrations.registration_id) AS enrollment
    FROM
        courses.registrations
    JOIN
        courses.registration_items
    ON
        registrations.registration_id = registration_items.registration_id
    JOIN
        curriculum.subjects
    ON
        registration_items.course_id = subjects.course_id
    WHERE
        registrations.location_id = @location_id
    GROUP BY
        subjects.course_name;
END;
```