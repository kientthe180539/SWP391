/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class StaffAssignment {

    public enum ShiftType {
        MORNING,
        AFTERNOON,
        NIGHT
    }

    public enum StaffStatus {
        ON_SHIFT,
        OFF_SHIFT,
        ABSENT
    }

    private Integer assignmentId;
    private Integer employeeId;
    private String employeeName; // Transient field for display
    private LocalDate workDate;
    private ShiftType shiftType;
    private StaffStatus status;
    private boolean isAccountActive; // Transient field for account status
    private LocalDateTime createdAt;

    public StaffAssignment() {
    }

    public StaffAssignment(Integer assignmentId,
            Integer employeeId,
            LocalDate workDate,
            ShiftType shiftType,
            StaffStatus status,
            LocalDateTime createdAt) {

        setAssignmentId(assignmentId);
        setEmployeeId(employeeId);
        setWorkDate(workDate);
        setShiftType(shiftType != null ? shiftType : ShiftType.MORNING);
        setStatus(status != null ? status : StaffStatus.ON_SHIFT);
        setCreatedAt(createdAt);
    }

    public Integer getAssignmentId() {
        return assignmentId;
    }

    public void setAssignmentId(Integer assignmentId) {
        this.assignmentId = assignmentId;
    }

    public Integer getEmployeeId() {
        return employeeId;
    }

    public void setEmployeeId(Integer employeeId) {
        if (employeeId == null) {
            throw new IllegalArgumentException("Employee id cannot be null");
        }
        this.employeeId = employeeId;
    }

    public String getEmployeeName() {
        return employeeName;
    }

    public void setEmployeeName(String employeeName) {
        this.employeeName = employeeName;
    }

    public LocalDate getWorkDate() {
        return workDate;
    }

    public void setWorkDate(LocalDate workDate) {
        if (workDate == null) {
            throw new IllegalArgumentException("Work date cannot be null");
        }
        this.workDate = workDate;
    }

    public ShiftType getShiftType() {
        return shiftType;
    }

    public void setShiftType(ShiftType shiftType) {
        if (shiftType == null) {
            throw new IllegalArgumentException("Shift type cannot be null");
        }
        this.shiftType = shiftType;
    }

    public void setShiftType(String typeStr) {
        if (typeStr == null) {
            throw new IllegalArgumentException("Shift type string cannot be null");
        }
        this.shiftType = ShiftType.valueOf(typeStr);
    }

    public StaffStatus getStatus() {
        return status;
    }

    public void setStatus(StaffStatus status) {
        if (status == null) {
            throw new IllegalArgumentException("Staff status cannot be null");
        }
        this.status = status;
    }

    public void setStatus(String statusStr) {
        if (statusStr == null) {
            throw new IllegalArgumentException("Staff status string cannot be null");
        }
        this.status = StaffStatus.valueOf(statusStr);
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isAccountActive() {
        return isAccountActive;
    }

    public void setAccountActive(boolean accountActive) {
        isAccountActive = accountActive;
    }
}
