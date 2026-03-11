package com.sena.crudCafetin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

import com.sena.crudCafetin.Dto.request.RoleRequest;
import com.sena.crudCafetin.Dto.response.RoleResponse;
import com.sena.crudCafetin.Service.IService.IRoleService;

@RestController
@RequestMapping("/api/role")
public class RoleController {

     @Autowired
    private IRoleService roleService;

    @GetMapping
    public List<RoleResponse> findAll() {
        return roleService.findAll();
    }

    @GetMapping("/{id}")
    public RoleResponse findById(@PathVariable Integer id) {
        return roleService.findById(id);
    }

    @PostMapping
    public RoleResponse save(@RequestBody RoleRequest request) {
        return roleService.save(request);
    }

    @PutMapping("/{id}")
    public RoleResponse update(@PathVariable Integer id,
                              @RequestBody RoleRequest request) {
        return roleService.update(id, request);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        roleService.delete(id);
    }

}
