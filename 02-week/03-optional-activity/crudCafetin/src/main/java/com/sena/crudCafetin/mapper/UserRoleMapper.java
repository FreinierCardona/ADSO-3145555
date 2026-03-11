package com.sena.crudCafetin.mapper;

import com.sena.crudCafetin.Dto.response.UserRoleResponse;
import com.sena.crudCafetin.Dto.request.UserRoleRequest;
import com.sena.crudCafetin.entity.UserRole;
import com.sena.crudCafetin.entity.User;
import com.sena.crudCafetin.entity.Role;

public class UserRoleMapper {

    // Request a Entity
    public static  UserRole toEntity (UserRoleRequest request, User user, Role role){
        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);
        return userRole;
    }

    // Entity a Response 
    public static UserRoleResponse toResponse(UserRole userRole){
        return new UserRoleResponse(
            userRole.getId(),
            userRole.getUser().getId(),
            userRole.getRole().getId()
        );
    }
}
