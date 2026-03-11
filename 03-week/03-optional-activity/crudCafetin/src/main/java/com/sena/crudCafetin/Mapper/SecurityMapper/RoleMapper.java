package com.sena.crudCafetin.Mapper.SecurityMapper;

import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.RoleRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.RoleResponse;
import com.sena.crudCafetin.Entity.Security.Role;

public class RoleMapper {

    public static Role toEntity (RoleRequest request){
        Role role = new Role();
        role.setName(request.getName());
        return role;
    }
    public static RoleResponse toResponse (Role role){
        return new RoleResponse(
                role.getId(),
                role.getName()
        );
    }

}
