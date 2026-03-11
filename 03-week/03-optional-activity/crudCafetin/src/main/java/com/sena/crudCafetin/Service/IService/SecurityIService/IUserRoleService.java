package com.sena.crudCafetin.Service.IService.SecurityIService;

import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.UserRoleRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.UserRoleResponse;

import java.util.List;

public interface IUserRoleService {

    List<UserRoleResponse> findAll();
    UserRoleResponse findById(Integer id);
    UserRoleResponse save(UserRoleRequest request);
    UserRoleResponse update(Integer id, UserRoleRequest request);
    void delete(Integer id);

}
