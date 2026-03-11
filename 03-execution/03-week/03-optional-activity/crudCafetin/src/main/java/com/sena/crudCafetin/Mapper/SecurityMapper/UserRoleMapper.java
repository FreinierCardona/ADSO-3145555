package com.sena.crudCafetin.Mapper.SecurityMapper;

import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.UserRoleRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.UserRoleResponse;
import com.sena.crudCafetin.Entity.Security.Role;
import com.sena.crudCafetin.Entity.Security.User;
import com.sena.crudCafetin.Entity.Security.UserRole;

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
