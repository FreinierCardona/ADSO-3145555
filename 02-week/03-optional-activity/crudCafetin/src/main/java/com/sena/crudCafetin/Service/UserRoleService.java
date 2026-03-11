package com.sena.crudCafetin.Service;

import com.sena.crudCafetin.Dto.request.UserRoleRequest;
import com.sena.crudCafetin.Dto.response.UserRoleResponse;
import com.sena.crudCafetin.Service.IService.IUserRoleService;
import com.sena.crudCafetin.entity.UserRole;
import com.sena.crudCafetin.entity.User;
import com.sena.crudCafetin.entity.Role;
import com.sena.crudCafetin.mapper.UserRoleMapper;
import com.sena.crudCafetin.repository.IUserRoleRepository;
import com.sena.crudCafetin.repository.IUserRepository;
import com.sena.crudCafetin.repository.IRoleRepository;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserRoleService implements IUserRoleService {

    @Autowired
    private IUserRoleRepository userRoleRepository;

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private IRoleRepository roleRepository;

    @Override
    public List<UserRoleResponse> findAll() {
        return userRoleRepository.findAll()
                .stream()
                .map(UserRoleMapper::toResponse)
                .toList();
    }

    @Override
    public UserRoleResponse findById(Integer id) {
        UserRole userRole = userRoleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserRole con id "+id + " No encontrado "));
        return UserRoleMapper.toResponse(userRole);
    }   

    @Override
    public UserRoleResponse save(UserRoleRequest request){
        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario con id "+request.getUserId() + " No encontrado "));

        Role role = roleRepository.findById(request.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol con id "+request.getRoleId() + " No encontrado "));

        UserRole userRole = new UserRole();
        userRole.setUser(user);
        userRole.setRole(role);

        userRole = userRoleRepository.save(userRole);
        return UserRoleMapper.toResponse(userRole);
    }

    @Override
    public UserRoleResponse update(Integer id, UserRoleRequest request){
        UserRole userRole = userRoleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserRole con id "+id + " No encontrado "));

        User user = userRepository.findById(request.getUserId())
                .orElseThrow(() -> new RuntimeException("Usuario con id "+request.getUserId() + " No encontrado "));

        Role role = roleRepository.findById(request.getRoleId())
                .orElseThrow(() -> new RuntimeException("Rol con id "+request.getRoleId() + " No encontrado "));

        userRole.setUser(user);
        userRole.setRole(role);

        userRole = userRoleRepository.save(userRole);
        return UserRoleMapper.toResponse(userRole);
    }

    @Override
    public void delete(Integer id) {
        UserRole userRole = userRoleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("UserRole con id "+id + " No encontrado "));
        userRoleRepository.delete(userRole);
    }   

}
