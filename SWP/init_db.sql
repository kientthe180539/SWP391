/* ============================================
   DROP + CREATE DATABASE
   ============================================ */
DROP DATABASE IF EXISTS hotel_manager_db;
CREATE DATABASE hotel_manager_db;
USE hotel_manager_db;


/* ============================================
   DROP ALL PROCEDURES (phòng khi chạy lại)
   ============================================ */

DROP PROCEDURE IF EXISTS sp_create_role;
DROP PROCEDURE IF EXISTS sp_create_user;
DROP PROCEDURE IF EXISTS sp_create_room_type;
DROP PROCEDURE IF EXISTS sp_create_room;
DROP PROCEDURE IF EXISTS sp_create_booking;
DROP PROCEDURE IF EXISTS sp_create_feedback;
DROP PROCEDURE IF EXISTS sp_create_issue_report;
DROP PROCEDURE IF EXISTS sp_create_housekeeping_task;
DROP PROCEDURE IF EXISTS sp_create_staff_assignment;

DROP PROCEDURE IF EXISTS sp_create_amenity;
DROP PROCEDURE IF EXISTS sp_assign_amenity_to_room_type;
DROP PROCEDURE IF EXISTS sp_create_room_inspection;
DROP PROCEDURE IF EXISTS sp_add_inspection_detail;


/* ============================================
   CREATE TABLES
   ============================================ */

/* ROLES */
CREATE TABLE roles (
    role_id     INT AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

/* USERS */
CREATE TABLE users (
    user_id       INT AUTO_INCREMENT PRIMARY KEY,
    username      VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name     VARCHAR(100) NOT NULL,
    email         VARCHAR(100),
    phone         VARCHAR(20),
    role_id       INT NOT NULL,
    is_active     TINYINT(1) DEFAULT 1,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

/* ROOM TYPES */
CREATE TABLE room_types (
    room_type_id   INT AUTO_INCREMENT PRIMARY KEY,
    type_name      VARCHAR(50) NOT NULL,
    description    VARCHAR(255),
    base_price     DECIMAL(10,2) NOT NULL,
    max_occupancy  INT NOT NULL
);

/* ROOMS */
CREATE TABLE rooms (
    room_id      INT AUTO_INCREMENT PRIMARY KEY,
    room_number  VARCHAR(20) NOT NULL,
    room_type_id INT NOT NULL,
    floor        INT,
    status       VARCHAR(20) NOT NULL,
    image_url    VARCHAR(255),
    description  VARCHAR(255),
    is_active    TINYINT(1) DEFAULT 1,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
);

/* BOOKINGS */
CREATE TABLE bookings (
    booking_id    INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    room_id       INT NOT NULL,
    checkin_date  DATE NOT NULL,
    checkout_date DATE NOT NULL,
    num_guests    INT,
    status        VARCHAR(20) NOT NULL,
    total_amount  DECIMAL(10,2),
    created_by    INT,
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

/* FEEDBACKS */
CREATE TABLE feedbacks (
    feedback_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id  INT NOT NULL,
    customer_id INT NOT NULL,
    rating      INT NOT NULL,
    comment     TEXT,
    created_at  DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

/* ISSUE REPORTS */
CREATE TABLE issue_reports (
    issue_id     INT AUTO_INCREMENT PRIMARY KEY,
    room_id      INT NOT NULL,
    booking_id   INT,
    reported_by  INT NOT NULL,
    issue_type   VARCHAR(20),
    description  TEXT,
    status       VARCHAR(20) NOT NULL,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id)     REFERENCES rooms(room_id),
    FOREIGN KEY (booking_id)  REFERENCES bookings(booking_id),
    FOREIGN KEY (reported_by) REFERENCES users(user_id)
);

/* HOUSEKEEPING TASKS */
CREATE TABLE housekeeping_tasks (
    task_id      INT AUTO_INCREMENT PRIMARY KEY,
    room_id      INT NOT NULL,
    assigned_to  INT NOT NULL,
    task_date    DATE NOT NULL,
    task_type    VARCHAR(20),
    status       VARCHAR(20),
    note         VARCHAR(255),
    created_by   INT,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id)     REFERENCES rooms(room_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    FOREIGN KEY (created_by)  REFERENCES users(user_id)
);

/* STAFF ASSIGNMENTS */
CREATE TABLE staff_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id   INT NOT NULL,
    work_date     DATE NOT NULL,
    shift_type    VARCHAR(20),
    status        VARCHAR(20),
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES users(user_id)
);


/* ============================================
   NEW TABLES (AMENITIES SYSTEM)
   ============================================ */

CREATE TABLE amenities (
    amenity_id   INT AUTO_INCREMENT PRIMARY KEY,
    name         VARCHAR(100) NOT NULL,
    description  VARCHAR(255),
    price        DECIMAL(10,2) DEFAULT 0.00,
    is_active    TINYINT(1) DEFAULT 1
);

CREATE TABLE room_type_amenities (
    id               INT AUTO_INCREMENT PRIMARY KEY,
    room_type_id     INT NOT NULL,
    amenity_id       INT NOT NULL,
    default_quantity INT DEFAULT 1,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id),
    FOREIGN KEY (amenity_id)   REFERENCES amenities(amenity_id)
);

CREATE TABLE room_inspections (
    inspection_id   INT AUTO_INCREMENT PRIMARY KEY,
    booking_id      INT NULL,
    room_id         INT NOT NULL,
    inspector_id    INT NOT NULL,
    inspection_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    type            VARCHAR(20) NOT NULL,
    note            TEXT,
    FOREIGN KEY (booking_id)   REFERENCES bookings(booking_id),
    FOREIGN KEY (room_id)      REFERENCES rooms(room_id),
    FOREIGN KEY (inspector_id) REFERENCES users(user_id)
);

CREATE TABLE inspection_details (
    detail_id        INT AUTO_INCREMENT PRIMARY KEY,
    inspection_id    INT NOT NULL,
    amenity_id       INT NOT NULL,
    quantity_actual  INT DEFAULT 0,
    condition_status VARCHAR(20) NOT NULL,
    comment          TEXT,
    FOREIGN KEY (inspection_id) REFERENCES room_inspections(inspection_id),
    FOREIGN KEY (amenity_id)    REFERENCES amenities(amenity_id)
);



/* ============================================
   STORED PROCEDURES
   ============================================ */

DELIMITER $$

/* ROLES */
CREATE PROCEDURE sp_create_role(
    IN p_role_name VARCHAR(50),
    IN p_description VARCHAR(255),
    OUT p_id INT
)
BEGIN
    INSERT INTO roles(role_name, description)
    VALUES (p_role_name, p_description);
    SET p_id = LAST_INSERT_ID();
END $$

/* USERS */
CREATE PROCEDURE sp_create_user(
    IN p_username VARCHAR(50),
    IN p_password_hash VARCHAR(255),
    IN p_full_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_role_id INT,
    IN p_active TINYINT(1),
    OUT p_id INT
)
BEGIN
    INSERT INTO users(username, password_hash, full_name, email, phone, role_id, is_active)
    VALUES(p_username, p_password_hash, p_full_name, p_email, p_phone, p_role_id, p_active);

    SET p_id = LAST_INSERT_ID();
END $$

/* ROOM TYPES */
CREATE PROCEDURE sp_create_room_type(
    IN p_name VARCHAR(50),
    IN p_desc VARCHAR(255),
    IN p_price DECIMAL(10,2),
    IN p_max INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO room_types(type_name, description, base_price, max_occupancy)
    VALUES(p_name, p_desc, p_price, p_max);

    SET p_id = LAST_INSERT_ID();
END $$

/* ROOMS */
CREATE PROCEDURE sp_create_room(
    IN p_number VARCHAR(20),
    IN p_type INT,
    IN p_floor INT,
    IN p_status VARCHAR(20),
    IN p_img VARCHAR(255),
    IN p_desc VARCHAR(255),
    IN p_active TINYINT(1),
    OUT p_id INT
)
BEGIN
    INSERT INTO rooms(room_number, room_type_id, floor, status, image_url, description, is_active)
    VALUES(p_number, p_type, p_floor, p_status, p_img, p_desc, p_active);

    SET p_id = LAST_INSERT_ID();
END $$

/* BOOKINGS */
CREATE PROCEDURE sp_create_booking(
    IN p_cust INT,
    IN p_room INT,
    IN p_ci DATE,
    IN p_co DATE,
    IN p_guest INT,
    IN p_status VARCHAR(20),
    IN p_amount DECIMAL(10,2),
    IN p_creator INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO bookings(customer_id, room_id, checkin_date, checkout_date, num_guests, status, total_amount, created_by)
    VALUES(p_cust, p_room, p_ci, p_co, p_guest, p_status, p_amount, p_creator);

    SET p_id = LAST_INSERT_ID();
END $$

/* FEEDBACK */
CREATE PROCEDURE sp_create_feedback(
    IN p_booking INT,
    IN p_customer INT,
    IN p_rating INT,
    IN p_comment TEXT,
    OUT p_id INT
)
BEGIN
    INSERT INTO feedbacks(booking_id, customer_id, rating, comment)
    VALUES(p_booking, p_customer, p_rating, p_comment);

    SET p_id = LAST_INSERT_ID();
END $$

/* ISSUE */
CREATE PROCEDURE sp_create_issue_report(
    IN p_room INT,
    IN p_booking INT,
    IN p_by INT,
    IN p_type VARCHAR(20),
    IN p_desc TEXT,
    IN p_status VARCHAR(20),
    OUT p_id INT
)
BEGIN
    INSERT INTO issue_reports(room_id, booking_id, reported_by, issue_type, description, status)
    VALUES(p_room, p_booking, p_by, p_type, p_desc, p_status);

    SET p_id = LAST_INSERT_ID();
END $$

/* HOUSEKEEPING */
CREATE PROCEDURE sp_create_housekeeping_task(
    IN p_room INT,
    IN p_emp INT,
    IN p_date DATE,
    IN p_type VARCHAR(20),
    IN p_status VARCHAR(20),
    IN p_note VARCHAR(255),
    IN p_creator INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO housekeeping_tasks(room_id, assigned_to, task_date, task_type, status, note, created_by)
    VALUES(p_room, p_emp, p_date, p_type, p_status, p_note, p_creator);

    SET p_id = LAST_INSERT_ID();
END $$

/* STAFF ASSIGNMENTS */
CREATE PROCEDURE sp_create_staff_assignment(
    IN p_emp INT,
    IN p_date DATE,
    IN p_shift VARCHAR(20),
    IN p_status VARCHAR(20),
    OUT p_id INT
)
BEGIN
    INSERT INTO staff_assignments(employee_id, work_date, shift_type, status)
    VALUES(p_emp, p_date, p_shift, p_status);

    SET p_id = LAST_INSERT_ID();
END $$

/* NEW — CREATE AMENITY */
CREATE PROCEDURE sp_create_amenity(
    IN p_name VARCHAR(100),
    IN p_desc VARCHAR(255),
    IN p_price DECIMAL(10,2),
    OUT p_id INT
)
BEGIN
    INSERT INTO amenities(name, description, price)
    VALUES(p_name, p_desc, p_price);

    SET p_id = LAST_INSERT_ID();
END $$

/* NEW — ASSIGN AMENITY TO ROOM TYPE */
CREATE PROCEDURE sp_assign_amenity_to_room_type(
    IN p_room_type INT,
    IN p_amenity INT,
    IN p_qty INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO room_type_amenities(room_type_id, amenity_id, default_quantity)
    VALUES(p_room_type, p_amenity, p_qty);

    SET p_id = LAST_INSERT_ID();
END $$

/* NEW — CREATE ROOM INSPECTION */
CREATE PROCEDURE sp_create_room_inspection(
    IN p_booking INT,
    IN p_room INT,
    IN p_inspector INT,
    IN p_type VARCHAR(20),
    IN p_note TEXT,
    OUT p_id INT
)
BEGIN
    INSERT INTO room_inspections(booking_id, room_id, inspector_id, type, note)
    VALUES(p_booking, p_room, p_inspector, p_type, p_note);

    SET p_id = LAST_INSERT_ID();
END $$

/* NEW — INSPECTION DETAILS */
CREATE PROCEDURE sp_add_inspection_detail(
    IN p_inspection INT,
    IN p_amenity INT,
    IN p_qty INT,
    IN p_status VARCHAR(20),
    IN p_comment TEXT,
    OUT p_id INT
)
BEGIN
    INSERT INTO inspection_details(inspection_id, amenity_id, quantity_actual, condition_status, comment)
    VALUES(p_inspection, p_amenity, p_qty, p_status, p_comment);

    SET p_id = LAST_INSERT_ID();
END $$

DELIMITER ;


/* ============================================
   SAMPLE DATA — ROLES
   ============================================ */
SET @r_cust := 0;
SET @r_rec := 0;
SET @r_hk := 0;
SET @r_owner := 0;
SET @r_admin := 0;

CALL sp_create_role('CUSTOMER', 'Khách hàng', @r_cust);
CALL sp_create_role('RECEPTIONIST', 'Lễ tân', @r_rec);
CALL sp_create_role('HOUSEKEEPING', 'Buồng phòng', @r_hk);
CALL sp_create_role('OWNER', 'Chủ khách sạn', @r_owner);
CALL sp_create_role('ADMIN', 'Quản trị', @r_admin);

SET @tmp := 0;
CALL sp_create_role('MANAGER', 'Quản lý', @tmp);
CALL sp_create_role('ACCOUNTANT', 'Kế toán', @tmp);
CALL sp_create_role('SECURITY', 'Bảo vệ', @tmp);
CALL sp_create_role('IT_SUPPORT', 'IT Supports', @tmp);
CALL sp_create_role('INTERN', 'Thực tập', @tmp);



/* ============================================
   SAMPLE DATA — USERS
   ============================================ */
SET @pwd := '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92';

SET @u1 := 0;
SET @u2 := 0;
SET @u3 := 0;
SET @u4 := 0;
SET @u5 := 0;
SET @u6 := 0;
SET @u7 := 0;
SET @u8 := 0;
SET @u9 := 0;
SET @u10 := 0;

CALL sp_create_user('cust01', @pwd, 'Khách hàng 01', 'cust01@example.com','0900000001', @r_cust, 1, @u1);
CALL sp_create_user('cust02', @pwd, 'Khách hàng 02', 'cust02@example.com','0900000002', @r_cust, 1, @u2);
CALL sp_create_user('cust03', @pwd, 'Khách hàng 03', 'cust03@example.com','0900000003', @r_cust, 1, @u3);
CALL sp_create_user('cust04', @pwd, 'Khách hàng 04', 'cust04@example.com','0900000004', @r_cust, 1, @u4);

CALL sp_create_user('rec01', @pwd, 'Lễ tân 01', 'rec01@example.com','0900000011', @r_rec, 1, @u5);
CALL sp_create_user('rec02', @pwd, 'Lễ tân 02', 'rec02@example.com','0900000012', @r_rec, 1, @u6);

CALL sp_create_user('hk01', @pwd, 'Buồng phòng 01', 'hk01@example.com','0900000021', @r_hk, 1, @u7);
CALL sp_create_user('hk02', @pwd, 'Buồng phòng 02', 'hk02@example.com','0900000022', @r_hk, 1, @u8);

CALL sp_create_user('owner01', @pwd, 'Chủ khách sạn', 'owner01@example.com','0900000031', @r_owner, 1, @u9);
CALL sp_create_user('admin01', @pwd, 'Quản trị hệ thống', 'admin01@example.com','0900000041', @r_admin, 1, @u10);



/* ============================================
   SAMPLE DATA — ROOM TYPES
   ============================================ */

SET @rt1 := 0;
SET @rt2 := 0;
SET @rt3 := 0;

CALL sp_create_room_type('Standard', 'Phòng tiêu chuẩn', 500000, 2, @rt1);
CALL sp_create_room_type('Deluxe', 'Phòng cao cấp', 800000, 3, @rt2);
CALL sp_create_room_type('Suite', 'Phòng Suite', 1200000, 4, @rt3);

CALL sp_create_room_type('Family','Phòng gia đình',1000000,4,@tmp);
CALL sp_create_room_type('Twin','Phòng 2 giường',550000,2,@tmp);
CALL sp_create_room_type('Double','1 giường đôi',600000,2,@tmp);
CALL sp_create_room_type('Superior','Superior',700000,2,@tmp);
CALL sp_create_room_type('Executive','Executive',1500000,2,@tmp);
CALL sp_create_room_type('Presidential','Tổng thống',3000000,4,@tmp);
CALL sp_create_room_type('Economy','Giá rẻ',400000,2,@tmp);



/* ============================================
   SAMPLE DATA — ROOMS
   ============================================ */
SET @r101 := 0;
SET @r102 := 0;
SET @r103 := 0;
SET @r104 := 0;
SET @r105 := 0;
SET @r201 := 0;
SET @r202 := 0;
SET @r203 := 0;
SET @r204 := 0;
SET @r205 := 0;

CALL sp_create_room('101', @rt1, 1, 'AVAILABLE', NULL, 'Standard 101', 1, @r101);
CALL sp_create_room('102', @rt1, 1, 'AVAILABLE', NULL, 'Standard 102', 1, @r102);
CALL sp_create_room('103', @rt1, 1, 'DIRTY',     NULL, 'Standard 103', 1, @r103);
CALL sp_create_room('104', @rt2, 1, 'BOOKED',    NULL, 'Deluxe 104',   1, @r104);
CALL sp_create_room('105', @rt2, 1, 'OCCUPIED',  NULL, 'Deluxe 105',   1, @r105);

CALL sp_create_room('201', @rt3, 2, 'AVAILABLE', NULL, 'Suite 201',    1, @r201);
CALL sp_create_room('202', @rt3, 2, 'DIRTY',     NULL, 'Suite 202',    1, @r202);
CALL sp_create_room('203', @rt1, 2, 'MAINTENANCE',NULL,'Standard 203',1,@r203);
CALL sp_create_room('204', @rt2, 2, 'AVAILABLE', NULL, 'Deluxe 204',   1, @r204);
CALL sp_create_room('205', @rt1, 2, 'AVAILABLE', NULL, 'Standard 205', 1, @r205);



/* ============================================
   SAMPLE DATA — AMENITIES
   ============================================ */
INSERT INTO amenities(name, price) VALUES
('Bath Towel', 200000),
('Hand Towel', 100000),
('Shampoo Bottle', 50000),
('TV Remote', 500000),
('Hair Dryer', 800000),
('Mini Bar Water', 20000),
('Bed Sheet', 1000000);



/* ============================================
   SAMPLE DATA — ROOM TYPE AMENITIES (STANDARD)
   ============================================ */

INSERT INTO room_type_amenities(room_type_id, amenity_id, default_quantity) VALUES
(@rt1, 1, 2),
(@rt1, 2, 2),
(@rt1, 4, 1),
(@rt1, 5, 1);



/* ============================================
   SAMPLE DATA — BOOKINGS
   ============================================ */

SET @b1 := 0;
SET @b2 := 0;
SET @b3 := 0;
SET @b4 := 0;
SET @b5 := 0;
SET @b6 := 0;
SET @b7 := 0;
SET @b8 := 0;
SET @b9 := 0;
SET @b10 := 0;

CALL sp_create_booking(@u1,@r101,'2025-01-05','2025-01-07',2,'PENDING',1000000,@u1,@b1);
CALL sp_create_booking(@u1,@r102,'2025-02-01','2025-02-03',2,'CONFIRMED',1200000,@u1,@b2);
CALL sp_create_booking(@u2,@r103,'2025-01-10','2025-01-12',1,'CANCELLED',800000,@u2,@b3);
CALL sp_create_booking(@u2,@r104,'2025-01-15','2025-01-18',3,'CHECKED_IN',2400000,@u5,@b4);
CALL sp_create_booking(@u3,@r105,'2024-12-20','2024-12-22',2,'CHECKED_OUT',1600000,@u5,@b5);
CALL sp_create_booking(@u3,@r201,'2025-03-01','2025-03-04',2,'PENDING',3600000,@u3,@b6);
CALL sp_create_booking(@u4,@r202,'2025-01-25','2025-01-26',1,'NO_SHOW',600000,@u6,@b7);
CALL sp_create_booking(@u4,@r203,'2025-02-10','2025-02-12',2,'CONFIRMED',1000000,@u6,@b8);
CALL sp_create_booking(@u1,@r204,'2025-02-20','2025-02-22',2,'CHECKED_OUT',1600000,@u5,@b9);
CALL sp_create_booking(@u2,@r205,'2025-03-05','2025-03-07',2,'PENDING',1000000,@u2,@b10);



/* ============================================
   SAMPLE DATA — FEEDBACKS
   ============================================ */
SET @fb := 0;

CALL sp_create_feedback(@b5,@u3,5,'Phòng sạch sẽ, nhân viên thân thiện.',@fb);
CALL sp_create_feedback(@b9,@u1,4,'Dịch vụ tốt, hơi ồn.',@fb);
CALL sp_create_feedback(@b3,@u2,3,'Hủy phòng nhưng hỗ trợ ổn.',@fb);
CALL sp_create_feedback(@b4,@u2,4,'Check-in nhanh.',@fb);
CALL sp_create_feedback(@b2,@u1,5,'Rất hài lòng.',@fb);
CALL sp_create_feedback(@b7,@u4,2,'Không đến được.',@fb);
CALL sp_create_feedback(@b1,@u1,3,'Phòng ổn.',@fb);
CALL sp_create_feedback(@b6,@u3,4,'Suite rộng.',@fb);
CALL sp_create_feedback(@b8,@u4,5,'Lễ tân tốt.',@fb);
CALL sp_create_feedback(@b10,@u2,4,'Đang chờ kỳ nghỉ.',@fb);



/* ============================================
   SAMPLE DATA — ISSUE REPORTS
   ============================================ */
SET @iss := 0;

CALL sp_create_issue_report(@r101,@b1,@u1,'SUPPLY','Thiếu khăn tắm.','NEW',@iss);
CALL sp_create_issue_report(@r102,@b2,@u1,'EQUIPMENT','Tivi không chạy.','IN_PROGRESS',@iss);
CALL sp_create_issue_report(@r103,NULL,@u7,'SUPPLY','Hết nước suối.','NEW',@iss);
CALL sp_create_issue_report(@r104,@b4,@u2,'EQUIPMENT','Máy lạnh ồn.','RESOLVED',@iss);
CALL sp_create_issue_report(@r105,@b5,@u3,'OTHER','Phàn nàn tiếng ồn.','CLOSED',@iss);
CALL sp_create_issue_report(@r201,@b6,@u3,'SUPPLY','Thiếu bàn chải.','NEW',@iss);
CALL sp_create_issue_report(@r202,@b7,@u6,'EQUIPMENT','Bóng đèn cháy.','IN_PROGRESS',@iss);
CALL sp_create_issue_report(@r203,@b8,@u8,'EQUIPMENT','Vòi sen rò rỉ.','NEW',@iss);
CALL sp_create_issue_report(@r204,@b9,@u1,'SUPPLY','Thiếu dép.','RESOLVED',@iss);
CALL sp_create_issue_report(@r205,@b10,@u2,'OTHER','Cần thêm gối.','NEW',@iss);



/* ============================================
   SAMPLE DATA — HOUSEKEEPING TASKS
   ============================================ */
SET @t := 0;

CALL sp_create_housekeeping_task(@r103,@u7,'2025-01-12','CLEANING','NEW','Dọn sau checkout',@u5,@t);
CALL sp_create_housekeeping_task(@r105,@u8,'2024-12-22','CLEANING','DONE','Đã dọn',@u5,@t);
CALL sp_create_housekeeping_task(@r202,@u7,'2025-01-26','CLEANING','IN_PROGRESS','Đang dọn',@u6,@t);
CALL sp_create_housekeeping_task(@r201,@u8,'2025-03-04','INSPECTION','NEW','Kiểm tra suite',@u9,@t);
CALL sp_create_housekeeping_task(@r203,@u7,'2025-02-12','CLEANING','NEW','Sau bảo trì',@u6,@t);
CALL sp_create_housekeeping_task(@r101,@u8,'2025-01-07','CLEANING','DONE','Khách checkout',@u5,@t);
CALL sp_create_housekeeping_task(@r102,@u7,'2025-02-03','CLEANING','NEW','Chuẩn bị khách mới',@u5,@t);
CALL sp_create_housekeeping_task(@r104,@u8,'2025-01-18','CLEANING','DONE','Dọn sau đoàn khách',@u5,@t);
CALL sp_create_housekeeping_task(@r204,@u7,'2025-02-22','CLEANING','DONE','Sau kỳ nghỉ',@u6,@t);
CALL sp_create_housekeeping_task(@r205,@u8,'2025-03-07','CLEANING','NEW','Chuẩn bị phòng',@u6,@t);



/* ============================================
   SAMPLE DATA — STAFF ASSIGNMENTS
   ============================================ */

SET @sa := 0;

CALL sp_create_staff_assignment(@u5,'2025-01-05','MORNING','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u6,'2025-01-05','AFTERNOON','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u7,'2025-01-05','MORNING','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u8,'2025-01-05','AFTERNOON','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u5,'2025-01-06','MORNING','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u6,'2025-01-06','AFTERNOON','OFF_SHIFT',@sa);
CALL sp_create_staff_assignment(@u7,'2025-01-06','MORNING','ABSENT',@sa);
CALL sp_create_staff_assignment(@u8,'2025-01-06','AFTERNOON','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u9,'2025-01-06','MORNING','ON_SHIFT',@sa);
CALL sp_create_staff_assignment(@u10,'2025-01-06','MORNING','ON_SHIFT',@sa);



/* ============================================
   SAMPLE – ROOM_INSPECTIONS & INSPECTION_DETAILS
   Checkin / Checkout cho tất cả các booking
   ============================================ */

-- Biến lưu inspection_id cho từng booking (checkin / checkout)
SET @insp_b1_ci  := 0;  SET @insp_b1_co  := 0;
SET @insp_b2_ci  := 0;  SET @insp_b2_co  := 0;
SET @insp_b3_ci  := 0;  SET @insp_b3_co  := 0;
SET @insp_b4_ci  := 0;  SET @insp_b4_co  := 0;
SET @insp_b5_ci  := 0;  SET @insp_b5_co  := 0;
SET @insp_b6_ci  := 0;  SET @insp_b6_co  := 0;
SET @insp_b7_ci  := 0;  SET @insp_b7_co  := 0;
SET @insp_b8_ci  := 0;  SET @insp_b8_co  := 0;
SET @insp_b9_ci  := 0;  SET @insp_b9_co  := 0;
SET @insp_b10_ci := 0;  SET @insp_b10_co := 0;

-- =========================
-- TẠO ROOM_INSPECTIONS
-- =========================
-- Booking 1 – Phòng 101 (hk01 = @u7)
CALL sp_create_room_inspection(@b1,  @r101, @u7, 'CHECKIN',
    'Kiểm tra phòng 101 khi khách check-in.', @insp_b1_ci);
CALL sp_create_room_inspection(@b1,  @r101, @u7, 'CHECKOUT',
    'Kiểm tra phòng 101 khi khách check-out.', @insp_b1_co);

-- Booking 2 – Phòng 102 (hk02 = @u8)
CALL sp_create_room_inspection(@b2,  @r102, @u8, 'CHECKIN',
    'Kiểm tra phòng 102 khi khách check-in.', @insp_b2_ci);
CALL sp_create_room_inspection(@b2,  @r102, @u8, 'CHECKOUT',
    'Kiểm tra phòng 102 khi khách check-out.', @insp_b2_co);

-- Booking 3 – Phòng 103 (hk01)
CALL sp_create_room_inspection(@b3,  @r103, @u7, 'CHECKIN',
    'Kiểm tra phòng 103 khi khách check-in.', @insp_b3_ci);
CALL sp_create_room_inspection(@b3,  @r103, @u7, 'CHECKOUT',
    'Kiểm tra phòng 103 khi khách check-out.', @insp_b3_co);

-- Booking 4 – Phòng 104 (hk02)
CALL sp_create_room_inspection(@b4,  @r104, @u8, 'CHECKIN',
    'Kiểm tra phòng 104 khi khách check-in.', @insp_b4_ci);
CALL sp_create_room_inspection(@b4,  @r104, @u8, 'CHECKOUT',
    'Kiểm tra phòng 104 khi khách check-out.', @insp_b4_co);

-- Booking 5 – Phòng 105 (hk01)
CALL sp_create_room_inspection(@b5,  @r105, @u7, 'CHECKIN',
    'Kiểm tra phòng 105 khi khách check-in.', @insp_b5_ci);
CALL sp_create_room_inspection(@b5,  @r105, @u7, 'CHECKOUT',
    'Kiểm tra phòng 105 khi khách check-out.', @insp_b5_co);

-- Booking 6 – Phòng 201 (hk02)
CALL sp_create_room_inspection(@b6,  @r201, @u8, 'CHECKIN',
    'Kiểm tra phòng 201 khi khách check-in.', @insp_b6_ci);
CALL sp_create_room_inspection(@b6,  @r201, @u8, 'CHECKOUT',
    'Kiểm tra phòng 201 khi khách check-out.', @insp_b6_co);

-- Booking 7 – Phòng 202 (hk01)
CALL sp_create_room_inspection(@b7,  @r202, @u7, 'CHECKIN',
    'Kiểm tra phòng 202 khi khách check-in.', @insp_b7_ci);
CALL sp_create_room_inspection(@b7,  @r202, @u7, 'CHECKOUT',
    'Kiểm tra phòng 202 khi khách check-out.', @insp_b7_co);

-- Booking 8 – Phòng 203 (hk02)
CALL sp_create_room_inspection(@b8,  @r203, @u8, 'CHECKIN',
    'Kiểm tra phòng 203 khi khách check-in.', @insp_b8_ci);
CALL sp_create_room_inspection(@b8,  @r203, @u8, 'CHECKOUT',
    'Kiểm tra phòng 203 khi khách check-out.', @insp_b8_co);

-- Booking 9 – Phòng 204 (hk01)
CALL sp_create_room_inspection(@b9,  @r204, @u7, 'CHECKIN',
    'Kiểm tra phòng 204 khi khách check-in.', @insp_b9_ci);
CALL sp_create_room_inspection(@b9,  @r204, @u7, 'CHECKOUT',
    'Kiểm tra phòng 204 khi khách check-out.', @insp_b9_co);

-- Booking 10 – Phòng 205 (hk02)
CALL sp_create_room_inspection(@b10, @r205, @u8, 'CHECKIN',
    'Kiểm tra phòng 205 khi khách check-in.', @insp_b10_ci);
CALL sp_create_room_inspection(@b10, @r205, @u8, 'CHECKOUT',
    'Kiểm tra phòng 205 khi khách check-out.', @insp_b10_co);

-- =========================
-- TẠO INSPECTION_DETAILS
-- =========================

SET @tmp_detail := 0;

-- Lấy id amenities theo tên
SET @am_bath_towel     := 0;
SET @am_hand_towel     := 0;
SET @am_tv_remote      := 0;
SET @am_hair_dryer     := 0;

SELECT amenity_id INTO @am_bath_towel FROM amenities WHERE name = 'Bath Towel'   LIMIT 1;
SELECT amenity_id INTO @am_hand_towel FROM amenities WHERE name = 'Hand Towel'   LIMIT 1;
SELECT amenity_id INTO @am_tv_remote   FROM amenities WHERE name = 'TV Remote'   LIMIT 1;
SELECT amenity_id INTO @am_hair_dryer  FROM amenities WHERE name = 'Hair Dryer'  LIMIT 1;

-- ========== BOOKING 1 (101) ==========
-- CHECKIN: tất cả OK
CALL sp_add_inspection_detail(@insp_b1_ci, @am_bath_towel, 2, 'OK', 'Đủ 2 khăn tắm.',            @tmp_detail);
CALL sp_add_inspection_detail(@insp_b1_ci, @am_hand_towel, 2, 'OK', 'Đủ 2 khăn tay.',            @tmp_detail);
CALL sp_add_inspection_detail(@insp_b1_ci, @am_tv_remote,  1, 'OK', 'Remote TV hoạt động tốt.', @tmp_detail);
CALL sp_add_inspection_detail(@insp_b1_ci, @am_hair_dryer, 1, 'OK', 'Máy sấy hoạt động tốt.',   @tmp_detail);
-- CHECKOUT: thiếu 1 khăn tay
CALL sp_add_inspection_detail(@insp_b1_co, @am_bath_towel, 2, 'OK',      'Đủ 2 khăn tắm.',      @tmp_detail);
CALL sp_add_inspection_detail(@insp_b1_co, @am_hand_towel, 1, 'MISSING', 'Thiếu 1 khăn tay.',   @tmp_detail);
CALL sp_add_inspection_detail(@insp_b1_co, @am_tv_remote,  1, 'OK',      'Remote vẫn đủ.',      @tmp_detail);
CALL sp_add_inspection_detail(@insp_b1_co, @am_hair_dryer, 1, 'OK',      'Máy sấy còn tốt.',    @tmp_detail);

-- ========== BOOKING 2 (102) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b2_ci, @am_bath_towel, 2, 'OK', 'Đủ 2 khăn tắm.',           @tmp_detail);
CALL sp_add_inspection_detail(@insp_b2_ci, @am_hand_towel, 2, 'OK', 'Đủ 2 khăn tay.',           @tmp_detail);
CALL sp_add_inspection_detail(@insp_b2_ci, @am_tv_remote,  1, 'OK', 'Remote OK.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b2_ci, @am_hair_dryer, 1, 'OK', 'Máy sấy OK.',              @tmp_detail);
-- CHECKOUT: remote hỏng
CALL sp_add_inspection_detail(@insp_b2_co, @am_bath_towel, 2, 'OK',      'Đủ khăn tắm.',        @tmp_detail);
CALL sp_add_inspection_detail(@insp_b2_co, @am_hand_towel, 2, 'OK',      'Đủ khăn tay.',        @tmp_detail);
CALL sp_add_inspection_detail(@insp_b2_co, @am_tv_remote,  1, 'DAMAGED', 'Remote bị hỏng nút.', @tmp_detail);
CALL sp_add_inspection_detail(@insp_b2_co, @am_hair_dryer, 1, 'OK',      'Máy sấy bình thường.',@tmp_detail);

-- ========== BOOKING 3 (103) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b3_ci, @am_bath_towel, 2, 'OK', 'Đủ đồ.',                   @tmp_detail);
CALL sp_add_inspection_detail(@insp_b3_ci, @am_hand_towel, 2, 'OK', 'Đủ đồ.',                   @tmp_detail);
CALL sp_add_inspection_detail(@insp_b3_ci, @am_tv_remote,  1, 'OK', 'OK.',                      @tmp_detail);
CALL sp_add_inspection_detail(@insp_b3_ci, @am_hair_dryer, 1, 'OK', 'OK.',                      @tmp_detail);
-- CHECKOUT: khách hủy, phòng vẫn đủ đồ
CALL sp_add_inspection_detail(@insp_b3_co, @am_bath_towel, 2, 'OK', 'Không sử dụng, còn đủ.',   @tmp_detail);
CALL sp_add_inspection_detail(@insp_b3_co, @am_hand_towel, 2, 'OK', 'Không sử dụng, còn đủ.',   @tmp_detail);
CALL sp_add_inspection_detail(@insp_b3_co, @am_tv_remote,  1, 'OK', 'Remote đủ.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b3_co, @am_hair_dryer, 1, 'OK', 'Máy sấy đủ.',              @tmp_detail);

-- ========== BOOKING 4 (104) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b4_ci, @am_bath_towel, 3, 'OK', 'Thêm 1 khăn tắm cho 3 khách.', @tmp_detail);
CALL sp_add_inspection_detail(@insp_b4_ci, @am_hand_towel, 3, 'OK', '3 khăn tay.',                   @tmp_detail);
CALL sp_add_inspection_detail(@insp_b4_ci, @am_tv_remote,  1, 'OK', 'Remote OK.',                    @tmp_detail);
CALL sp_add_inspection_detail(@insp_b4_ci, @am_hair_dryer, 1, 'OK', 'Máy sấy OK.',                   @tmp_detail);
-- CHECKOUT: 1 khăn tắm đã dùng (giặt), còn 2
CALL sp_add_inspection_detail(@insp_b4_co, @am_bath_towel, 2, 'USED',    '1 khăn đã gửi giặt.',     @tmp_detail);
CALL sp_add_inspection_detail(@insp_b4_co, @am_hand_towel, 3, 'USED',    '3 khăn tay đã dùng.',     @tmp_detail);
CALL sp_add_inspection_detail(@insp_b4_co, @am_tv_remote,  1, 'OK',      'Remote OK.',              @tmp_detail);
CALL sp_add_inspection_detail(@insp_b4_co, @am_hair_dryer, 1, 'OK',      'Máy sấy OK.',             @tmp_detail);

-- ========== BOOKING 5 (105) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b5_ci, @am_bath_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b5_ci, @am_hand_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b5_ci, @am_tv_remote,  1, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b5_ci, @am_hair_dryer, 1, 'OK', 'OK.',                          @tmp_detail);
-- CHECKOUT: thiếu 1 khăn tắm
CALL sp_add_inspection_detail(@insp_b5_co, @am_bath_towel, 1, 'MISSING', 'Thiếu 1 khăn tắm.',       @tmp_detail);
CALL sp_add_inspection_detail(@insp_b5_co, @am_hand_towel, 2, 'OK',      'Khăn tay đủ.',            @tmp_detail);
CALL sp_add_inspection_detail(@insp_b5_co, @am_tv_remote,  1, 'OK',      'Remote OK.',              @tmp_detail);
CALL sp_add_inspection_detail(@insp_b5_co, @am_hair_dryer, 1, 'OK',      'Máy sấy OK.',             @tmp_detail);

-- ========== BOOKING 6 (201) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b6_ci, @am_bath_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b6_ci, @am_hand_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b6_ci, @am_tv_remote,  1, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b6_ci, @am_hair_dryer, 1, 'OK', 'OK.',                          @tmp_detail);
-- CHECKOUT
CALL sp_add_inspection_detail(@insp_b6_co, @am_bath_towel, 2, 'USED',    'Đã dùng, gửi giặt.',      @tmp_detail);
CALL sp_add_inspection_detail(@insp_b6_co, @am_hand_towel, 2, 'USED',    'Đã dùng.',                @tmp_detail);
CALL sp_add_inspection_detail(@insp_b6_co, @am_tv_remote,  1, 'OK',      'OK.',                     @tmp_detail);
CALL sp_add_inspection_detail(@insp_b6_co, @am_hair_dryer, 1, 'OK',      'OK.',                     @tmp_detail);

-- ========== BOOKING 7 (202) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b7_ci, @am_bath_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b7_ci, @am_hand_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b7_ci, @am_tv_remote,  1, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b7_ci, @am_hair_dryer, 1, 'OK', 'OK.',                          @tmp_detail);
-- CHECKOUT: khách no-show, phòng vẫn đủ đồ
CALL sp_add_inspection_detail(@insp_b7_co, @am_bath_towel, 2, 'OK', 'Không sử dụng.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b7_co, @am_hand_towel, 2, 'OK', 'Không sử dụng.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b7_co, @am_tv_remote,  1, 'OK', 'Không sử dụng.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b7_co, @am_hair_dryer, 1, 'OK', 'Không sử dụng.',               @tmp_detail);

-- ========== BOOKING 8 (203) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b8_ci, @am_bath_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b8_ci, @am_hand_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b8_ci, @am_tv_remote,  1, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b8_ci, @am_hair_dryer, 1, 'OK', 'OK.',                          @tmp_detail);
-- CHECKOUT
CALL sp_add_inspection_detail(@insp_b8_co, @am_bath_towel, 2, 'USED',    'Đã dùng.',                @tmp_detail);
CALL sp_add_inspection_detail(@insp_b8_co, @am_hand_towel, 2, 'USED',    'Đã dùng.',                @tmp_detail);
CALL sp_add_inspection_detail(@insp_b8_co, @am_tv_remote,  1, 'OK',      'OK.',                     @tmp_detail);
CALL sp_add_inspection_detail(@insp_b8_co, @am_hair_dryer, 1, 'OK',      'OK.',                     @tmp_detail);

-- ========== BOOKING 9 (204) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b9_ci, @am_bath_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b9_ci, @am_hand_towel, 2, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b9_ci, @am_tv_remote,  1, 'OK', 'OK.',                          @tmp_detail);
CALL sp_add_inspection_detail(@insp_b9_ci, @am_hair_dryer, 1, 'OK', 'OK.',                          @tmp_detail);
-- CHECKOUT: thiếu 1 khăn tay
CALL sp_add_inspection_detail(@insp_b9_co, @am_bath_towel, 2, 'OK',      'Đủ khăn tắm.',            @tmp_detail);
CALL sp_add_inspection_detail(@insp_b9_co, @am_hand_towel, 1, 'MISSING', 'Thiếu 1 khăn tay.',       @tmp_detail);
CALL sp_add_inspection_detail(@insp_b9_co, @am_tv_remote,  1, 'OK',      'OK.',                     @tmp_detail);
CALL sp_add_inspection_detail(@insp_b9_co, @am_hair_dryer, 1, 'OK',      'OK.',                     @tmp_detail);

-- ========== BOOKING 10 (205) ==========
-- CHECKIN
CALL sp_add_inspection_detail(@insp_b10_ci, @am_bath_towel, 2, 'OK', 'OK.',                         @tmp_detail);
CALL sp_add_inspection_detail(@insp_b10_ci, @am_hand_towel, 2, 'OK', 'OK.',                         @tmp_detail);
CALL sp_add_inspection_detail(@insp_b10_ci, @am_tv_remote,  1, 'OK', 'OK.',                         @tmp_detail);
CALL sp_add_inspection_detail(@insp_b10_ci, @am_hair_dryer, 1, 'OK', 'OK.',                         @tmp_detail);
-- CHECKOUT
CALL sp_add_inspection_detail(@insp_b10_co, @am_bath_towel, 2, 'USED',    'Đã dùng.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b10_co, @am_hand_towel, 2, 'USED',    'Đã dùng.',               @tmp_detail);
CALL sp_add_inspection_detail(@insp_b10_co, @am_tv_remote,  1, 'OK',      'OK.',                    @tmp_detail);
CALL sp_add_inspection_detail(@insp_b10_co, @am_hair_dryer, 1, 'OK',      'OK.',                    @tmp_detail);



/* ============================================
   THÊM USER MANAGER
   ============================================ */
INSERT INTO users (
    username, password_hash, full_name, email, phone, role_id, is_active, created_at
) VALUES (
    'manager01',
    '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92',
    'Quản lý chung',
    'manager01@example.com',
    '0851234551',
    6,  -- role MANAGER
    1,
    '2025-12-04 04:57:34'
);



/* ============================================
   UPDATE PHONE DEMO
   ============================================ */
UPDATE users
SET phone = CASE user_id
    WHEN  1 THEN '0325123456'  -- cust01
    WHEN  2 THEN '0345123456'  -- cust02
    WHEN  3 THEN '0365123456'  -- cust03
    WHEN  4 THEN '0385123456'  -- cust04
    WHEN  5 THEN '0812345678'  -- rec01
    WHEN  6 THEN '0822345678'  -- rec02
    WHEN  7 THEN '0761234567'  -- hk01
    WHEN  8 THEN '0781234567'  -- hk02
    WHEN  9 THEN '0831234567'  -- owner01
    WHEN 10 THEN '0851234567'  -- admin01
END
WHERE user_id BETWEEN 1 AND 10;

-- Create table replenishment_requests
CREATE TABLE IF NOT EXISTS replenishment_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    inspection_id INT NOT NULL,
    amenity_id INT NOT NULL,
    quantity_requested INT NOT NULL,
    reason TEXT,
    status VARCHAR(20) DEFAULT 'PENDING',
    requested_by INT NOT NULL,
    approved_by INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (inspection_id) REFERENCES room_inspections(inspection_id),
    FOREIGN KEY (amenity_id) REFERENCES amenities(amenity_id),
    FOREIGN KEY (requested_by) REFERENCES users(user_id),
    FOREIGN KEY (approved_by) REFERENCES users(user_id)
);

-- Create Stored Procedure sp_create_replenishment_request
DELIMITER //
CREATE PROCEDURE sp_create_replenishment_request(
    IN p_inspection_id INT,
    IN p_amenity_id INT,
    IN p_quantity INT,
    IN p_reason TEXT,
    IN p_requested_by INT,
    OUT p_request_id INT
)
BEGIN
    INSERT INTO replenishment_requests (inspection_id, amenity_id, quantity_requested, reason, requested_by, status, created_at)
    VALUES (p_inspection_id, p_amenity_id, p_quantity, p_reason, p_requested_by, 'PENDING', NOW());
    
    SET p_request_id = LAST_INSERT_ID();
END //
DELIMITER ;

-- Create Stored Procedure sp_update_replenishment_status
DELIMITER //
CREATE PROCEDURE sp_update_replenishment_status(
    IN p_request_id INT,
    IN p_status VARCHAR(20),
    IN p_approved_by INT
)
BEGIN
    UPDATE replenishment_requests
    SET status = p_status,
        approved_by = p_approved_by,
        updated_at = NOW()
    WHERE request_id = p_request_id;
END //
DELIMITER ;



/* ============================================
   FINISH — SUCCESS
   ============================================ */
SELECT 'DATABASE INIT COMPLETE' AS status;
