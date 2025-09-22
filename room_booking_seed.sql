INSERT INTO users (name, email, role) VALUES
 ('Alice Lim','alice@utb.edu.bn','student'),
 ('John Tan','john@utb.edu.bn','staff'),
 ('Dr. Noor','noor@utb.edu.bn','admin');

INSERT INTO room (room_code, name, location, capacity) VALUES
 ('B101','Lecture Hall 1','Block B',120),
 ('C202','Computer Lab 2','Block C',40),
 ('D303','Meeting Room','Block D',15);

INSERT INTO booking (room_id, user_id, start_time, end_time, purpose)
VALUES
 (1, 1, '2025-09-25 10:00:00','2025-09-25 12:00:00','Group Study'),
 (2, 2, '2025-09-26 09:00:00','2025-09-26 11:00:00','Training Session');

INSERT INTO approval (booking_id, approver_id, decision, decision_at, remarks)
VALUES
 (1, 3, 'approved', NOW(), 'Approved by admin');

#Highlight the above first to run the code then paste the second code block below

SELECT b.booking_id,
       u.name AS booked_by,
       r.name AS room_name,
       b.start_time,
       b.end_time,
       a.decision
FROM booking b
JOIN users u ON b.user_id = u.user_id
JOIN room r ON b.room_id = r.room_id
LEFT JOIN approval a ON b.booking_id = a.booking_id;

#Step 4 – Verify Data
#Expand your booking_db schema in the left SCHEMAS panel
  → right-click a table (like users) → Select Rows – Limit 1000
  → check that your sample rows are there.
