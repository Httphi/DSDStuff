-- 1) Create & select a schema
CREATE DATABASE IF NOT EXISTS booking_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE booking_db;

-- 2) Users
CREATE TABLE users (
  user_id    INT AUTO_INCREMENT PRIMARY KEY,
  name       VARCHAR(100) NOT NULL,
  email      VARCHAR(120) NOT NULL UNIQUE,
  role       ENUM('student','staff','admin') NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3) Rooms
CREATE TABLE room (
  room_id    INT AUTO_INCREMENT PRIMARY KEY,
  room_code  VARCHAR(20)  NOT NULL UNIQUE,
  name       VARCHAR(100) NOT NULL,
  location   VARCHAR(120) NOT NULL,
  capacity   INT NOT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CHECK (capacity >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4) Features (lookup)
CREATE TABLE feature (
  feature_id   INT AUTO_INCREMENT PRIMARY KEY,
  feature_name VARCHAR(60) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5) RoomFeature (Room ↔ Feature bridge)
CREATE TABLE room_feature (
  room_id   INT NOT NULL,
  feature_id INT NOT NULL,
  PRIMARY KEY (room_id, feature_id),
  CONSTRAINT fk_rf_room     FOREIGN KEY (room_id)   REFERENCES room(room_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_rf_feature  FOREIGN KEY (feature_id) REFERENCES feature(feature_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6) Bookings
CREATE TABLE booking (
  booking_id  INT AUTO_INCREMENT PRIMARY KEY,
  room_id     INT NOT NULL,
  user_id     INT NOT NULL,     -- requester
  start_time  DATETIME NOT NULL,
  end_time    DATETIME NOT NULL,
  purpose     VARCHAR(200),
  status      ENUM('pending','approved','rejected','cancelled') NOT NULL DEFAULT 'pending',
  created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_b_room FOREIGN KEY (room_id) REFERENCES room(room_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_b_user FOREIGN KEY (user_id) REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CHECK (end_time > start_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Helpful indexes
CREATE INDEX idx_booking_room_time ON booking(room_id, start_time, end_time);
CREATE INDEX idx_booking_user      ON booking(user_id);

-- 7) Approval (0/1 per booking)
CREATE TABLE approval (
  approval_id INT AUTO_INCREMENT PRIMARY KEY,
  booking_id  INT NOT NULL UNIQUE,
  approver_id INT NOT NULL,
  decision    ENUM('approved','rejected') NOT NULL,
  decision_at DATETIME NOT NULL,
  remarks     VARCHAR(200),
  CONSTRAINT fk_appr_booking  FOREIGN KEY (booking_id)  REFERENCES booking(booking_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_appr_approver FOREIGN KEY (approver_id) REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8) BookingAttendee (optional many-to-many)
CREATE TABLE booking_attendee (
  booking_id INT NOT NULL,
  user_id    INT NOT NULL,
  PRIMARY KEY (booking_id, user_id),
  CONSTRAINT fk_ba_booking FOREIGN KEY (booking_id) REFERENCES booking(booking_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ba_user    FOREIGN KEY (user_id)    REFERENCES users(user_id)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
