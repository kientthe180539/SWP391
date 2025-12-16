/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model;

import java.time.LocalDate;
import java.time.LocalDateTime;

public class HousekeepingTask {

    public enum TaskStatus {
        NEW,
        IN_PROGRESS,
        DONE
    }

    public enum TaskType {
        CLEANING,
        INSPECTION,
        CHECKIN,
        CHECKOUT
    }

    private Integer taskId;
    private Integer roomId;
    private Integer assignedTo;
    private LocalDate taskDate;
    private TaskType taskType;
    private TaskStatus status;
    private String note;
    private Integer createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public HousekeepingTask() {
    }

    public HousekeepingTask(Integer taskId,
            Integer roomId,
            Integer assignedTo,
            LocalDate taskDate,
            TaskType taskType,
            TaskStatus status,
            String note,
            Integer createdBy,
            LocalDateTime createdAt,
            LocalDateTime updatedAt) {

        setTaskId(taskId);
        setRoomId(roomId);
        setAssignedTo(assignedTo);
        setTaskDate(taskDate);
        setTaskType(taskType != null ? taskType : TaskType.CLEANING);
        setStatus(status != null ? status : TaskStatus.NEW);
        setNote(note);
        setCreatedBy(createdBy);
        setCreatedAt(createdAt);
        setUpdatedAt(updatedAt);
    }

    public Integer getTaskId() {
        return taskId;
    }

    public void setTaskId(Integer taskId) {
        this.taskId = taskId;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        if (roomId == null) {
            throw new IllegalArgumentException("Room id cannot be null");
        }
        this.roomId = roomId;
    }

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        if (assignedTo == null) {
            throw new IllegalArgumentException("AssignedTo user id cannot be null");
        }
        this.assignedTo = assignedTo;
    }

    public LocalDate getTaskDate() {
        return taskDate;
    }

    public void setTaskDate(LocalDate taskDate) {
        if (taskDate == null) {
            throw new IllegalArgumentException("Task date cannot be null");
        }
        this.taskDate = taskDate;
    }

    public TaskType getTaskType() {
        return taskType;
    }

    public void setTaskType(TaskType taskType) {
        if (taskType == null) {
            throw new IllegalArgumentException("Task type cannot be null");
        }
        this.taskType = taskType;
    }

    public void setTaskType(String typeStr) {
        if (typeStr == null) {
            throw new IllegalArgumentException("Task type string cannot be null");
        }
        this.taskType = TaskType.valueOf(typeStr);
    }

    public TaskStatus getStatus() {
        return status;
    }

    public void setStatus(TaskStatus status) {
        if (status == null) {
            throw new IllegalArgumentException("Task status cannot be null");
        }
        this.status = status;
    }

    public void setStatus(String statusStr) {
        if (statusStr == null) {
            throw new IllegalArgumentException("Task status string cannot be null");
        }
        this.status = TaskStatus.valueOf(statusStr);
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = (note == null ? null : note.trim());
    }

    public Integer getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(Integer createdBy) {
        // có thể null
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
