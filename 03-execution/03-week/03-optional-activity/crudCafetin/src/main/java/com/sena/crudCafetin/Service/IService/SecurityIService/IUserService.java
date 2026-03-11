package com.sena.crudCafetin.Service.IService.SecurityIService;

import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.UserRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.UserResponse;

import java.util.List;

public interface IUserService {

    List<UserResponse> findAll();
    UserResponse findById(Integer id);
    UserResponse save(UserRequest request);
    UserResponse update(Integer id, UserRequest request);
    void delete(Integer id);

}
