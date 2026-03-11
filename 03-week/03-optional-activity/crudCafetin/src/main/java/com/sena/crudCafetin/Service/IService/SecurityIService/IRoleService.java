package com.sena.crudCafetin.Service.IService.SecurityIService;


import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.RoleRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.RoleResponse;

import java.util.List;

public interface IRoleService {

    List<RoleResponse> findAll();
    RoleResponse findById(Integer id);
    RoleResponse save(RoleRequest request);
    RoleResponse update(Integer id, RoleRequest request);
    void delete(Integer id);

}
