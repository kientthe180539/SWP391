CREATE DATABASE hotel_manager_db;
USE  hotel_manager_db;
CREATE TABLE roles (
    role_id     INT AUTO_INCREMENT PRIMARY KEY,
    role_name   VARCHAR(50) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE users (
    user_id      INT AUTO_INCREMENT PRIMARY KEY,
    username     VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name    VARCHAR(100) NOT NULL,
    email        VARCHAR(100),
    phone        VARCHAR(20),
    role_id      INT NOT NULL,
    is_active    TINYINT(1) DEFAULT 1,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

CREATE TABLE room_types (
    room_type_id   INT AUTO_INCREMENT PRIMARY KEY,
    type_name      VARCHAR(50) NOT NULL,
    description    VARCHAR(255),
    base_price     DECIMAL(10,2) NOT NULL,
    max_occupancy  INT NOT NULL
);

CREATE TABLE rooms (
    room_id      INT AUTO_INCREMENT PRIMARY KEY,
    room_number  VARCHAR(20) NOT NULL,
    room_type_id INT NOT NULL,
    floor        INT,
    status       VARCHAR(20) NOT NULL,  -- AVAILABLE, BOOKED, OCCUPIED, DIRTY, ...
    image_url    VARCHAR(255),
    description  VARCHAR(255),
    is_active    TINYINT(1) DEFAULT 1,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id)
);

CREATE TABLE bookings (
    booking_id    INT AUTO_INCREMENT PRIMARY KEY,
    customer_id   INT NOT NULL,
    room_id       INT NOT NULL,
    checkin_date  DATE NOT NULL,
    checkout_date DATE NOT NULL,
    num_guests    INT,
    status        VARCHAR(20) NOT NULL, -- PENDING, CONFIRMED, ...
    total_amount  DECIMAL(10,2),
    created_by    INT,                  -- user tạo booking
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES users(user_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE feedbacks (
    feedback_id  INT AUTO_INCREMENT PRIMARY KEY,
    booking_id   INT NOT NULL,
    customer_id  INT NOT NULL,
    rating       INT NOT NULL,
    comment      TEXT,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (customer_id) REFERENCES users(user_id)
);

CREATE TABLE issue_reports (
    issue_id     INT AUTO_INCREMENT PRIMARY KEY,
    room_id      INT NOT NULL,
    booking_id   INT,
    reported_by  INT NOT NULL,
    issue_type   VARCHAR(20),          -- SUPPLY, EQUIPMENT, OTHER
    description  TEXT,
    status       VARCHAR(20) NOT NULL, -- NEW, IN_PROGRESS, ...
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (reported_by) REFERENCES users(user_id)
);

CREATE TABLE housekeeping_tasks (
    task_id      INT AUTO_INCREMENT PRIMARY KEY,
    room_id      INT NOT NULL,
    assigned_to  INT NOT NULL,
    task_date    DATE NOT NULL,
    task_type    VARCHAR(20),          -- CLEANING, INSPECTION
    status       VARCHAR(20) NOT NULL, -- NEW, IN_PROGRESS, DONE
    note         VARCHAR(255),
    created_by   INT,
    created_at   DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

CREATE TABLE staff_assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id   INT NOT NULL,
    work_date     DATE NOT NULL,
    shift_type    VARCHAR(20),         -- MORNING, AFTERNOON, NIGHT
    status        VARCHAR(20),         -- ON_SHIFT, OFF_SHIFT, ABSENT
    created_at    DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES users(user_id)
);

DELIMITER $$

/* =========================
   1. ROLES
   ========================= */
CREATE PROCEDURE sp_create_role (
    IN  p_role_name   VARCHAR(50),
    IN  p_description VARCHAR(255),
    OUT p_new_role_id INT
)
BEGIN
    INSERT INTO roles (role_name, description)
    VALUES (p_role_name, p_description);

    SET p_new_role_id = LAST_INSERT_ID();
END $$


/* =========================
   2. USERS
   ========================= */
CREATE PROCEDURE sp_create_user (
    IN  p_username      VARCHAR(50),
    IN  p_password_hash VARCHAR(255),
    IN  p_full_name     VARCHAR(100),
    IN  p_email         VARCHAR(100),
    IN  p_phone         VARCHAR(20),
    IN  p_role_id       INT,
    IN  p_is_active     TINYINT(1),
    OUT p_new_user_id   INT
)
BEGIN
    INSERT INTO users (
        username, password_hash, full_name,
        email, phone, role_id, is_active
    )
    VALUES (
        p_username, p_password_hash, p_full_name,
        p_email, p_phone, p_role_id, p_is_active
    );

    SET p_new_user_id = LAST_INSERT_ID();
END $$


/* =========================
   3. ROOM_TYPES
   ========================= */
CREATE PROCEDURE sp_create_room_type (
    IN  p_type_name     VARCHAR(50),
    IN  p_description   VARCHAR(255),
    IN  p_base_price    DECIMAL(10,2),
    IN  p_max_occupancy INT,
    OUT p_new_room_type_id INT
)
BEGIN
    INSERT INTO room_types (
        type_name, description, base_price, max_occupancy
    )
    VALUES (
        p_type_name, p_description, p_base_price, p_max_occupancy
    );

    SET p_new_room_type_id = LAST_INSERT_ID();
END $$


/* =========================
   4. ROOMS
   ========================= */
CREATE PROCEDURE sp_create_room (
    IN  p_room_number  VARCHAR(20),
    IN  p_room_type_id INT,
    IN  p_floor        INT,
    IN  p_status       VARCHAR(20),
    IN  p_image_url    VARCHAR(255),
    IN  p_description  VARCHAR(255),
    IN  p_is_active    TINYINT(1),
    OUT p_new_room_id  INT
)
BEGIN
    INSERT INTO rooms (
        room_number, room_type_id, floor,
        status, image_url, description, is_active
    )
    VALUES (
        p_room_number, p_room_type_id, p_floor,
        p_status, p_image_url, p_description, p_is_active
    );

    SET p_new_room_id = LAST_INSERT_ID();
END $$


/* =========================
   5. BOOKINGS
   ========================= */
CREATE PROCEDURE sp_create_booking (
    IN  p_customer_id   INT,
    IN  p_room_id       INT,
    IN  p_checkin_date  DATE,
    IN  p_checkout_date DATE,
    IN  p_num_guests    INT,
    IN  p_status        VARCHAR(20),   -- ví dụ: 'PENDING'
    IN  p_total_amount  DECIMAL(10,2),
    IN  p_created_by    INT,           -- user tạo (customer hoặc receptionist)
    OUT p_new_booking_id INT
)
BEGIN
    INSERT INTO bookings (
        customer_id, room_id, checkin_date, checkout_date,
        num_guests, status, total_amount,
        created_by
    )
    VALUES (
        p_customer_id, p_room_id, p_checkin_date, p_checkout_date,
        p_num_guests, p_status, p_total_amount,
        p_created_by
    );

    SET p_new_booking_id = LAST_INSERT_ID();
END $$


/* =========================
   6. FEEDBACKS
   ========================= */
CREATE PROCEDURE sp_create_feedback (
    IN  p_booking_id  INT,
    IN  p_customer_id INT,
    IN  p_rating      INT,
    IN  p_comment     TEXT,
    OUT p_new_feedback_id INT
)
BEGIN
    INSERT INTO feedbacks (
        booking_id, customer_id, rating, comment
    )
    VALUES (
        p_booking_id, p_customer_id, p_rating, p_comment
    );

    SET p_new_feedback_id = LAST_INSERT_ID();
END $$


/* =========================
   7. ISSUE_REPORTS
   ========================= */
CREATE PROCEDURE sp_create_issue_report (
    IN  p_room_id     INT,
    IN  p_booking_id  INT,        -- cho phép NULL nếu không gắn booking
    IN  p_reported_by INT,
    IN  p_issue_type  VARCHAR(20),   -- SUPPLY/EQUIPMENT/OTHER
    IN  p_description TEXT,
    IN  p_status      VARCHAR(20),   -- NEW, ...
    OUT p_new_issue_id INT
)
BEGIN
    INSERT INTO issue_reports (
        room_id, booking_id, reported_by,
        issue_type, description, status
    )
    VALUES (
        p_room_id, p_booking_id, p_reported_by,
        p_issue_type, p_description, p_status
    );

    SET p_new_issue_id = LAST_INSERT_ID();
END $$


/* =========================
   8. HOUSEKEEPING_TASKS
   ========================= */
CREATE PROCEDURE sp_create_housekeeping_task (
    IN  p_room_id     INT,
    IN  p_assigned_to INT,
    IN  p_task_date   DATE,
    IN  p_task_type   VARCHAR(20),   -- CLEANING/INSPECTION
    IN  p_status      VARCHAR(20),   -- NEW, ...
    IN  p_note        VARCHAR(255),
    IN  p_created_by  INT,
    OUT p_new_task_id INT
)
BEGIN
    INSERT INTO housekeeping_tasks (
        room_id, assigned_to, task_date,
        task_type, status, note,
        created_by
    )
    VALUES (
        p_room_id, p_assigned_to, p_task_date,
        p_task_type, p_status, p_note,
        p_created_by
    );

    SET p_new_task_id = LAST_INSERT_ID();
END $$


/* =========================
   9. STAFF_ASSIGNMENTS
   ========================= */
CREATE PROCEDURE sp_create_staff_assignment (
    IN  p_employee_id INT,
    IN  p_work_date   DATE,
    IN  p_shift_type  VARCHAR(20),   -- MORNING/AFTERNOON/NIGHT
    IN  p_status      VARCHAR(20),   -- ON_SHIFT/OFF_SHIFT/ABSENT
    OUT p_new_assignment_id INT
)
BEGIN
    INSERT INTO staff_assignments (
        employee_id, work_date, shift_type, status
    )
    VALUES (
        p_employee_id, p_work_date, p_shift_type, p_status
    );

    SET p_new_assignment_id = LAST_INSERT_ID();
END $$

DELIMITER ;

/* ============================================
   SAMPLE DATA – HOTEL SYSTEM
   Mỗi bảng 10 dòng, dùng stored procedures
   ============================================ */

-- ROLES -------------------------------------------------

SET @role_customer_id      := 0;
SET @role_receptionist_id  := 0;
SET @role_housekeeping_id  := 0;
SET @role_owner_id         := 0;
SET @role_admin_id         := 0;

CALL sp_create_role('CUSTOMER',     'Khách hàng đặt phòng', @role_customer_id);
CALL sp_create_role('RECEPTIONIST', 'Lễ tân',               @role_receptionist_id);
CALL sp_create_role('HOUSEKEEPING', 'Nhân viên buồng phòng',@role_housekeeping_id);
CALL sp_create_role('OWNER',        'Chủ khách sạn',        @role_owner_id);
CALL sp_create_role('ADMIN',        'Quản trị hệ thống',    @role_admin_id);

-- thêm vài role “thừa” cho đủ 10 dòng
SET @tmp := 0;
CALL sp_create_role('MANAGER',      'Quản lý chung', @tmp);
CALL sp_create_role('ACCOUNTANT',   'Kế toán',       @tmp);
CALL sp_create_role('SECURITY',     'Bảo vệ',        @tmp);
CALL sp_create_role('IT_SUPPORT',   'Hỗ trợ IT',     @tmp);
CALL sp_create_role('INTERN',       'Thực tập sinh', @tmp);

-- USERS -------------------------------------------------

SET @u_cust1_id := 0;
SET @u_cust2_id := 0;
SET @u_cust3_id := 0;
SET @u_cust4_id := 0;
SET @u_rec1_id  := 0;
SET @u_rec2_id  := 0;
SET @u_hk1_id   := 0;
SET @u_hk2_id   := 0;
SET @u_owner_id := 0;
SET @u_admin_id := 0;

/*
    SHA-256("123456") = 
    8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92
*/
SET @pwd123 := '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92';

-- 4 Customer
CALL sp_create_user('cust01', @pwd123, 'Khách hàng 01', 'cust01@example.com', '0900000001', @role_customer_id, 1, @u_cust1_id);
CALL sp_create_user('cust02', @pwd123, 'Khách hàng 02', 'cust02@example.com', '0900000002', @role_customer_id, 1, @u_cust2_id);
CALL sp_create_user('cust03', @pwd123, 'Khách hàng 03', 'cust03@example.com', '0900000003', @role_customer_id, 1, @u_cust3_id);
CALL sp_create_user('cust04', @pwd123, 'Khách hàng 04', 'cust04@example.com', '0900000004', @role_customer_id, 1, @u_cust4_id);

-- 2 Receptionist
CALL sp_create_user('rec01', @pwd123, 'Lễ tân 01', 'rec01@example.com', '0900000011', @role_receptionist_id, 1, @u_rec1_id);
CALL sp_create_user('rec02', @pwd123, 'Lễ tân 02', 'rec02@example.com', '0900000012', @role_receptionist_id, 1, @u_rec2_id);

-- 2 Housekeeping
CALL sp_create_user('hk01', @pwd123, 'Buồng phòng 01', 'hk01@example.com', '0900000021', @role_housekeeping_id, 1, @u_hk1_id);
CALL sp_create_user('hk02', @pwd123, 'Buồng phòng 02', 'hk02@example.com', '0900000022', @role_housekeeping_id, 1, @u_hk2_id);

-- 1 Owner
CALL sp_create_user('owner01', @pwd123, 'Chủ khách sạn', 'owner01@example.com', '0900000031', @role_owner_id, 1, @u_owner_id);

-- 1 Admin
CALL sp_create_user('admin01', @pwd123, 'Quản trị hệ thống', 'admin01@example.com', '0900000041', @role_admin_id, 1, @u_admin_id);


-- ROOM_TYPES --------------------------------------------

SET @rt_std_id    := 0;
SET @rt_dlx_id    := 0;
SET @rt_suite_id  := 0;

CALL sp_create_room_type('Standard', 'Phòng tiêu chuẩn', 500000, 2, @rt_std_id);
CALL sp_create_room_type('Deluxe',   'Phòng cao cấp',    800000, 3, @rt_dlx_id);
CALL sp_create_room_type('Suite',    'Phòng suite',      1200000,4, @rt_suite_id);

-- thêm 7 loại cho đủ 10
CALL sp_create_room_type('Family',     'Phòng gia đình',     1000000,4, @tmp);
CALL sp_create_room_type('Twin',       'Phòng 2 giường đơn', 550000, 2, @tmp);
CALL sp_create_room_type('Double',     'Phòng 1 giường đôi', 600000, 2, @tmp);
CALL sp_create_room_type('Superior',   'Phòng superior',     700000, 2, @tmp);
CALL sp_create_room_type('Executive',  'Phòng executive',    1500000,2, @tmp);
CALL sp_create_room_type('Presidential','Phòng tổng thống', 3000000,4, @tmp);
CALL sp_create_room_type('Economy',    'Phòng giá rẻ',       400000, 2, @tmp);

-- ROOMS -------------------------------------------------

SET @room101_id := 0;
SET @room102_id := 0;
SET @room103_id := 0;
SET @room104_id := 0;
SET @room105_id := 0;
SET @room201_id := 0;
SET @room202_id := 0;
SET @room203_id := 0;
SET @room204_id := 0;
SET @room205_id := 0;

CALL sp_create_room('101', @rt_std_id,   1, 'AVAILABLE',  NULL, 'Standard 101',   1, @room101_id);
CALL sp_create_room('102', @rt_std_id,   1, 'AVAILABLE',  NULL, 'Standard 102',   1, @room102_id);
CALL sp_create_room('103', @rt_std_id,   1, 'DIRTY',      NULL, 'Standard 103',   1, @room103_id);
CALL sp_create_room('104', @rt_dlx_id,   1, 'BOOKED',     NULL, 'Deluxe 104',     1, @room104_id);
CALL sp_create_room('105', @rt_dlx_id,   1, 'OCCUPIED',   NULL, 'Deluxe 105',     1, @room105_id);

CALL sp_create_room('201', @rt_suite_id, 2, 'AVAILABLE',  NULL, 'Suite 201',      1, @room201_id);
CALL sp_create_room('202', @rt_suite_id, 2, 'DIRTY',      NULL, 'Suite 202',      1, @room202_id);
CALL sp_create_room('203', @rt_std_id,   2, 'MAINTENANCE',NULL, 'Standard 203',   1, @room203_id);
CALL sp_create_room('204', @rt_dlx_id,   2, 'AVAILABLE',  NULL, 'Deluxe 204',     1, @room204_id);
CALL sp_create_room('205', @rt_std_id,   2, 'AVAILABLE',  NULL, 'Standard 205',   1, @room205_id);

-- BOOKINGS ----------------------------------------------

SET @b1_id := 0;
SET @b2_id := 0;
SET @b3_id := 0;
SET @b4_id := 0;
SET @b5_id := 0;
SET @b6_id := 0;
SET @b7_id := 0;
SET @b8_id := 0;
SET @b9_id := 0;
SET @b10_id := 0;

CALL sp_create_booking(@u_cust1_id, @room101_id, '2025-01-05', '2025-01-07', 2, 'PENDING',    1000000, @u_cust1_id, @b1_id);
CALL sp_create_booking(@u_cust1_id, @room102_id, '2025-02-01', '2025-02-03', 2, 'CONFIRMED',  1200000, @u_cust1_id, @b2_id);
CALL sp_create_booking(@u_cust2_id, @room103_id, '2025-01-10', '2025-01-12', 1, 'CANCELLED',   800000, @u_cust2_id, @b3_id);
CALL sp_create_booking(@u_cust2_id, @room104_id, '2025-01-15', '2025-01-18', 3, 'CHECKED_IN', 2400000, @u_rec1_id,  @b4_id);
CALL sp_create_booking(@u_cust3_id, @room105_id, '2024-12-20', '2024-12-22', 2, 'CHECKED_OUT',1600000, @u_rec1_id,  @b5_id);
CALL sp_create_booking(@u_cust3_id, @room201_id, '2025-03-01', '2025-03-04', 2, 'PENDING',    3600000, @u_cust3_id, @b6_id);
CALL sp_create_booking(@u_cust4_id, @room202_id, '2025-01-25', '2025-01-26', 1, 'NO_SHOW',     600000, @u_rec2_id,  @b7_id);
CALL sp_create_booking(@u_cust4_id, @room203_id, '2025-02-10', '2025-02-12', 2, 'CONFIRMED',  1000000, @u_rec2_id,  @b8_id);
CALL sp_create_booking(@u_cust1_id, @room204_id, '2025-02-20', '2025-02-22', 2, 'CHECKED_OUT',1600000, @u_rec1_id,  @b9_id);
CALL sp_create_booking(@u_cust2_id, @room205_id, '2025-03-05', '2025-03-07', 2, 'PENDING',    1000000, @u_cust2_id, @b10_id);

-- FEEDBACKS ---------------------------------------------

SET @fb1_id := 0;
SET @fb2_id := 0;
SET @fb3_id := 0;
SET @fb4_id := 0;
SET @fb5_id := 0;
SET @fb6_id := 0;
SET @fb7_id := 0;
SET @fb8_id := 0;
SET @fb9_id := 0;
SET @fb10_id := 0;

CALL sp_create_feedback(@b5_id,  @u_cust3_id, 5, 'Phòng sạch sẽ, nhân viên thân thiện.', @fb1_id);
CALL sp_create_feedback(@b9_id,  @u_cust1_id, 4, 'Dịch vụ tốt, hơi ồn.',                 @fb2_id);
CALL sp_create_feedback(@b3_id,  @u_cust2_id, 3, 'Hủy phòng nhưng hỗ trợ ổn.',          @fb3_id);
CALL sp_create_feedback(@b4_id,  @u_cust2_id, 4, 'Check-in nhanh, phòng đẹp.',           @fb4_id);
CALL sp_create_feedback(@b2_id,  @u_cust1_id, 5, 'Rất hài lòng.',                        @fb5_id);
CALL sp_create_feedback(@b7_id,  @u_cust4_id, 2, 'Không đến được, mong cải thiện.',      @fb6_id);
CALL sp_create_feedback(@b1_id,  @u_cust1_id, 3, 'Phòng ổn, giá hợp lý.',                @fb7_id);
CALL sp_create_feedback(@b6_id,  @u_cust3_id, 4, 'Suite rộng rãi.',                      @fb8_id);
CALL sp_create_feedback(@b8_id,  @u_cust4_id, 5, 'Nhân viên lễ tân nhiệt tình.',         @fb9_id);
CALL sp_create_feedback(@b10_id, @u_cust2_id, 4, 'Đang chờ kỳ nghỉ này.',                @fb10_id);

-- ISSUE_REPORTS -----------------------------------------

SET @iss1_id := 0;
SET @iss2_id := 0;
SET @iss3_id := 0;
SET @iss4_id := 0;
SET @iss5_id := 0;
SET @iss6_id := 0;
SET @iss7_id := 0;
SET @iss8_id := 0;
SET @iss9_id := 0;
SET @iss10_id := 0;

CALL sp_create_issue_report(@room101_id, @b1_id,  @u_cust1_id, 'SUPPLY',    'Thiếu khăn tắm.',                'NEW',         @iss1_id);
CALL sp_create_issue_report(@room102_id, @b2_id,  @u_cust1_id, 'EQUIPMENT', 'Tivi không lên nguồn.',         'IN_PROGRESS', @iss2_id);
CALL sp_create_issue_report(@room103_id, NULL,    @u_hk1_id,   'SUPPLY',    'Hết nước suối mini.',           'NEW',         @iss3_id);
CALL sp_create_issue_report(@room104_id, @b4_id,  @u_cust2_id, 'EQUIPMENT', 'Máy lạnh kêu to.',              'RESOLVED',    @iss4_id);
CALL sp_create_issue_report(@room105_id, @b5_id,  @u_cust3_id, 'OTHER',     'Khách phàn nàn về tiếng ồn.',   'CLOSED',      @iss5_id);
CALL sp_create_issue_report(@room201_id, @b6_id,  @u_cust3_id, 'SUPPLY',    'Thiếu bàn chải đánh răng.',     'NEW',         @iss6_id);
CALL sp_create_issue_report(@room202_id, @b7_id,  @u_rec2_id,  'EQUIPMENT', 'Bóng đèn cháy.',                'IN_PROGRESS', @iss7_id);
CALL sp_create_issue_report(@room203_id, @b8_id,  @u_hk2_id,   'EQUIPMENT', 'Vòi sen rò rỉ.',                'NEW',         @iss8_id);
CALL sp_create_issue_report(@room204_id, @b9_id,  @u_cust1_id, 'SUPPLY',    'Thiếu dép đi trong phòng.',     'RESOLVED',    @iss9_id);
CALL sp_create_issue_report(@room205_id, @b10_id, @u_cust2_id, 'OTHER',     'Cần thêm gối.',                 'NEW',         @iss10_id);

-- HOUSEKEEPING_TASKS ------------------------------------

SET @task1_id := 0;
SET @task2_id := 0;
SET @task3_id := 0;
SET @task4_id := 0;
SET @task5_id := 0;
SET @task6_id := 0;
SET @task7_id := 0;
SET @task8_id := 0;
SET @task9_id := 0;
SET @task10_id := 0;

CALL sp_create_housekeeping_task(@room103_id, @u_hk1_id, '2025-01-12', 'CLEANING',  'NEW',         'Dọn phòng sau check-out.',         @u_rec1_id, @task1_id);
CALL sp_create_housekeeping_task(@room105_id, @u_hk2_id, '2024-12-22', 'CLEANING',  'DONE',        'Đã dọn phòng.',                    @u_rec1_id, @task2_id);
CALL sp_create_housekeeping_task(@room202_id, @u_hk1_id, '2025-01-26', 'CLEANING',  'IN_PROGRESS', 'Đang dọn sau no-show.',           @u_rec2_id, @task3_id);
CALL sp_create_housekeeping_task(@room201_id, @u_hk2_id, '2025-03-04', 'INSPECTION','NEW',         'Kiểm tra phòng suite.',           @u_owner_id,@task4_id);
CALL sp_create_housekeeping_task(@room203_id, @u_hk1_id, '2025-02-12', 'CLEANING',  'NEW',         'Dọn phòng sau bảo trì.',          @u_rec2_id, @task5_id);
CALL sp_create_housekeeping_task(@room101_id, @u_hk2_id, '2025-01-07', 'CLEANING',  'DONE',        'Khách check-out, đã dọn.',        @u_rec1_id, @task6_id);
CALL sp_create_housekeeping_task(@room102_id, @u_hk1_id, '2025-02-03', 'CLEANING',  'NEW',         'Chuẩn bị cho khách mới.',         @u_rec1_id, @task7_id);
CALL sp_create_housekeeping_task(@room104_id, @u_hk2_id, '2025-01-18', 'CLEANING',  'DONE',        'Dọn sau đoàn khách 3 người.',     @u_rec1_id, @task8_id);
CALL sp_create_housekeeping_task(@room204_id, @u_hk1_id, '2025-02-22', 'CLEANING',  'DONE',        'Dọn phòng sau kỳ nghỉ.',          @u_rec2_id, @task9_id);
CALL sp_create_housekeeping_task(@room205_id, @u_hk2_id, '2025-03-07', 'CLEANING',  'NEW',         'Chuẩn bị phòng cho booking mới.', @u_rec2_id, @task10_id);

-- STAFF_ASSIGNMENTS -------------------------------------

SET @sa1_id := 0;
SET @sa2_id := 0;
SET @sa3_id := 0;
SET @sa4_id := 0;
SET @sa5_id := 0;
SET @sa6_id := 0;
SET @sa7_id := 0;
SET @sa8_id := 0;
SET @sa9_id := 0;
SET @sa10_id := 0;

CALL sp_create_staff_assignment(@u_rec1_id, '2025-01-05', 'MORNING',   'ON_SHIFT',  @sa1_id);
CALL sp_create_staff_assignment(@u_rec2_id, '2025-01-05', 'AFTERNOON', 'ON_SHIFT',  @sa2_id);
CALL sp_create_staff_assignment(@u_hk1_id,  '2025-01-05', 'MORNING',   'ON_SHIFT',  @sa3_id);
CALL sp_create_staff_assignment(@u_hk2_id,  '2025-01-05', 'AFTERNOON', 'ON_SHIFT',  @sa4_id);
CALL sp_create_staff_assignment(@u_rec1_id, '2025-01-06', 'MORNING',   'ON_SHIFT',  @sa5_id);
CALL sp_create_staff_assignment(@u_rec2_id, '2025-01-06', 'AFTERNOON', 'OFF_SHIFT', @sa6_id);
CALL sp_create_staff_assignment(@u_hk1_id,  '2025-01-06', 'MORNING',   'ABSENT',    @sa7_id);
CALL sp_create_staff_assignment(@u_hk2_id,  '2025-01-06', 'AFTERNOON', 'ON_SHIFT',  @sa8_id);
CALL sp_create_staff_assignment(@u_owner_id,'2025-01-06', 'MORNING',   'ON_SHIFT',  @sa9_id);
CALL sp_create_staff_assignment(@u_admin_id,'2025-01-06', 'MORNING',   'ON_SHIFT',  @sa10_id);

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

