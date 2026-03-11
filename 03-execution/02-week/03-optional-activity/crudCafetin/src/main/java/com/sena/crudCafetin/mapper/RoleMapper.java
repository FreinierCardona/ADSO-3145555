package com.sena.crudCafetin.mapper;

import com.sena.crudCafetin.Dto.response.RoleResponse;
import com.sena.crudCafetin.entity.Role;

public class RoleMapper {

    public static RoleResponse toResponse (Role role){
        return new RoleResponse(
                role.getId(),
                role.getName()
        );
    }

}
