/* ============================================
   MIGRATION: Replenishment Requests System
   Created: 2025-12-04
   Description: Adds replenishment request functionality for housekeeping inspections
   ============================================ */

USE hotel_manager_db;

/* ============================================
   DROP EXISTING PROCEDURES IF ANY
   ============================================ */
DROP PROCEDURE IF EXISTS sp_create_replenishment_request;
DROP PROCEDURE IF EXISTS sp_update_replenishment_status;

/* ============================================
   CREATE REPLENISHMENT_REQUESTS TABLE
   ============================================ */
CREATE TABLE IF NOT EXISTS replenishment_requests (
    request_id      INT AUTO_INCREMENT PRIMARY KEY,
    inspection_id   INT NOT NULL,
    amenity_id      INT NOT NULL,
    quantity_requested INT NOT NULL DEFAULT 1,
    reason          TEXT,
    status          VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    requested_by    INT NOT NULL,
    approved_by     INT NULL,
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    FOREIGN KEY (inspection_id) REFERENCES room_inspections(inspection_id),
    FOREIGN KEY (amenity_id)    REFERENCES amenities(amenity_id),
    FOREIGN KEY (requested_by)  REFERENCES users(user_id),
    FOREIGN KEY (approved_by)   REFERENCES users(user_id),
    
    INDEX idx_status (status),
    INDEX idx_inspection (inspection_id),
    INDEX idx_requested_by (requested_by),
    INDEX idx_created_at (created_at)
);

/* ============================================
   STORED PROCEDURES
   ============================================ */

DELIMITER $$

/* CREATE REPLENISHMENT REQUEST */
CREATE PROCEDURE sp_create_replenishment_request(
    IN p_inspection_id INT,
    IN p_amenity_id INT,
    IN p_quantity INT,
    IN p_reason TEXT,
    IN p_requested_by INT,
    OUT p_id INT
)
BEGIN
    INSERT INTO replenishment_requests(
        inspection_id, 
        amenity_id, 
        quantity_requested, 
        reason, 
        status, 
        requested_by
    )
    VALUES(
        p_inspection_id, 
        p_amenity_id, 
        p_quantity, 
        p_reason, 
        'PENDING', 
        p_requested_by
    );
    
    SET p_id = LAST_INSERT_ID();
END $$

/* UPDATE REPLENISHMENT REQUEST STATUS */
CREATE PROCEDURE sp_update_replenishment_status(
    IN p_request_id INT,
    IN p_status VARCHAR(20),
    IN p_approved_by INT
)
BEGIN
    UPDATE replenishment_requests
    SET status = p_status,
        approved_by = p_approved_by,
        updated_at = CURRENT_TIMESTAMP
    WHERE request_id = p_request_id;
END $$

DELIMITER ;

/* ============================================
   VERIFICATION
   ============================================ */
SELECT 'Replenishment requests migration completed successfully' AS status;
DESCRIBE replenishment_requests;
