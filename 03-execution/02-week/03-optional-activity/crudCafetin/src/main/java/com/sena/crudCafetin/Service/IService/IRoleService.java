package com.sena.crudCafetin.Service.IService;


import com.sena.crudCafetin.Dto.response.RoleResponse;
import com.sena.crudCafetin.Dto.request.RoleRequest;
import java.util.List;

public interface IRoleService {

    List<RoleResponse> findAll();
    RoleResponse findById(Integer id);
    RoleResponse save(RoleRequest request);
    RoleResponse update(Integer id, RoleRequest request);
    void delete(Integer id);

}
