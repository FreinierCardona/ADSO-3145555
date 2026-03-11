package com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest;

public class RoleRequest {

    private String name;

    public RoleRequest() {
    }

    public RoleRequest(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    
}
