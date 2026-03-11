package com.sena.crudCafetin.Service.IService;

import com.sena.crudCafetin.Dto.request.UserRequest;
import com.sena.crudCafetin.Dto.response.UserResponse;

import java.util.List;

public interface IUserService {

    List<UserResponse> findAll();
    UserResponse findById(Integer id);
    UserResponse save(UserRequest request);
    UserResponse update(Integer id, UserRequest request);
    void delete(Integer id);

}
