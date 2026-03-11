package com.sena.crudCafetin.Service.IService;

import com.sena.crudCafetin.Dto.request.UserRoleRequest;
import com.sena.crudCafetin.Dto.response.UserRoleResponse;
import java.util.List;

public interface IUserRoleService {

    List<UserRoleResponse> findAll();
    UserRoleResponse findById(Integer id);
    UserRoleResponse save(UserRoleRequest request);
    UserRoleResponse update(Integer id, UserRoleRequest request);
    void delete(Integer id);

}
