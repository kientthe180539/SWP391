package Model;

public class Role {

    private Integer roleId;
    private String roleName;
    private String description;

    public Role() {
    }

    public Role(Integer roleId, String roleName, String description) {
        setRoleId(roleId);
        setRoleName(roleName);
        setDescription(description);
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId; // có thể null nếu chưa lưu DB
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        if (roleName == null || roleName.isBlank()) {
            throw new IllegalArgumentException("Role name cannot be null or blank");
        }
        this.roleName = roleName.trim();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = (description == null ? null : description.trim());
    }

    @Override
    public String toString() {
        return "Role{" +
                "roleId=" + roleId +
                ", roleName='" + roleName + '\'' +
                ", description='" + description + '\'' +
                '}';
    }
}
