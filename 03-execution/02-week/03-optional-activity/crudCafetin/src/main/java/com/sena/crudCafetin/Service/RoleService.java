package com.sena.crudCafetin.Service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.sena.crudCafetin.Dto.response.RoleResponse;
import com.sena.crudCafetin.Dto.request.RoleRequest;
import com.sena.crudCafetin.mapper.RoleMapper;
import com.sena.crudCafetin.repository.IRoleRepository;
import java.util.List;

import com.sena.crudCafetin.Service.IService.IRoleService;
import com.sena.crudCafetin.entity.Role;

@Service
public class RoleService implements IRoleService {

    @Autowired
    private IRoleRepository roleRepository;

    @Override
    public List<RoleResponse> findAll() {
        return roleRepository.findAll()
                .stream()
                .map(RoleMapper::toResponse)
                .toList();
    }

    @Override
    public RoleResponse findById(Integer id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol con id "+id + " No encontrado "));
        return RoleMapper.toResponse(role);
    }

    @Override
    public RoleResponse save (RoleRequest request){
        Role role = new Role();
        role.setName(request.getName());
        role = roleRepository.save(role);
        return RoleMapper.toResponse(role);
    }

    @Override
    public RoleResponse update (Integer id, RoleRequest request){
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol con id "+id + " No encontrado "));

        // Actualizar el nombre del rol con el dato del request
        role.setName(request.getName());

        role = roleRepository.save(role);
        return RoleMapper.toResponse(role);
    }

    @Override
    public void delete(Integer id) {
        Role role = roleRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Rol con id "+id + " No encontrado "));
        roleRepository.delete(role);
    }

}
