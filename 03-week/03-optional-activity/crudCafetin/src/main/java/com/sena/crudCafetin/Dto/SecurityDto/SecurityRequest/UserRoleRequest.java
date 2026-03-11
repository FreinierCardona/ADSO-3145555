package com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest;

public class UserRoleRequest {

    private Integer userId;
    private Integer roleId;

    public UserRoleRequest() {}

    public UserRoleRequest(Integer userId, Integer roleId) {
        this.userId = userId;
        this.roleId = roleId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    
}
