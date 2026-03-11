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

import com.sena.crudCafetin.Dto.request.UserRoleRequest;
import com.sena.crudCafetin.Dto.response.UserRoleResponse;
import com.sena.crudCafetin.Service.IService.IUserRoleService;
import java.util.List;

@RestController
@RequestMapping("/api/user-role")
public class UserRoleController {


    @Autowired
    private IUserRoleService userRoleService;

    @GetMapping
    public List<UserRoleResponse> findAll() {
        return userRoleService.findAll();
    }

    @GetMapping("/{id}")
    public UserRoleResponse findById(@PathVariable Integer id) {
        return userRoleService.findById(id);
    }

    @PostMapping
    public UserRoleResponse save(@RequestBody UserRoleRequest request) {
        return userRoleService.save(request);
    }

    @PutMapping("/{id}")
    public UserRoleResponse update(@PathVariable Integer id,
                                  @RequestBody UserRoleRequest request) {
        return userRoleService.update(id, request);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        userRoleService.delete(id);

    }
}
