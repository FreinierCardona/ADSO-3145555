package com.sena.crudCafetin.Mapper.SecurityMapper;

import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.UserRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.UserResponse;
import com.sena.crudCafetin.Entity.Security.Person;
import com.sena.crudCafetin.Entity.Security.User;

public class UserMapper {

    // Request a Entity
    public static User toEntity(UserRequest request, Person person){
        User user = new User();
        user.setUserName(request.getUserName());
        user.setPassword(request.getPassword());
        user.setPerson(person);
        return user;
    }

    // Entity a Response
    public static UserResponse toResponse(User user){
        return new UserResponse(
        user.getId(),
        user.getUserName(),
        user.getPerson().getId()
        );
    }

}
