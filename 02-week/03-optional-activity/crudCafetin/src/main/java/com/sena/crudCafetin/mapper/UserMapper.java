package com.sena.crudCafetin.mapper;

import com.sena.crudCafetin.Dto.response.UserResponse;
import com.sena.crudCafetin.Dto.request.UserRequest;
import com.sena.crudCafetin.entity.User;
import com.sena.crudCafetin.entity.Person;

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
