package com.sena.crudCafetin.Service.SecurityService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sena.crudCafetin.Entity.Security.User;
import com.sena.crudCafetin.Mapper.SecurityMapper.UserMapper;
import com.sena.crudCafetin.Repository.SecurityRepository.IUserRepository;
import com.sena.crudCafetin.Service.IService.SecurityIService.IUserService;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.UserRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.UserResponse;

import java.util.List;

import com.sena.crudCafetin.Entity.Security.Person;
import com.sena.crudCafetin.Repository.SecurityRepository.IPersonRepository;



@Service
public class UserService implements IUserService {

    @Autowired
    private IUserRepository userRepository;

    @Autowired
    private IPersonRepository personRepository;

    // Listar todos los usuarios
    @Override
    public List<UserResponse> findAll(){
        return userRepository.findAll()
                .stream()
                .map(UserMapper::toResponse)
                .toList();
    }

    // Buscar usuario por id
    @Override
    public UserResponse findById(Integer id){
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario con id "+id + " No encontrado "));
        return UserMapper.toResponse(user);
    }

    // Crear un nuevo usuario
    @Override
    public UserResponse save (UserRequest request){

        // Verificar que la persona asociada exista
        Person person = personRepository.findById(request.getPersonId())
                .orElseThrow(() -> new RuntimeException("Persona con id "+request.getPersonId() + " No encontrada "));

        User user = UserMapper.toEntity(request, person);
        
        user = userRepository.save(user);
        return UserMapper.toResponse(user);
    }

    // Actualizar un usuario existente
    @Override
    public UserResponse update (Integer id, UserRequest request){
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario con id "+id + " No encontrado "));

        // Verificar que la persona asociada exista
        Person person = personRepository.findById(request.getPersonId())
                .orElseThrow(() -> new RuntimeException("Persona con id "+request.getPersonId() + " No encontrada "));

        // Actualizar los campos del usuario con los datos del request
        user.setUserName(request.getUserName());
        user.setPassword(request.getPassword());
        user.setPerson(person);

        user = userRepository.save(user);
        return UserMapper.toResponse(user);
    }

    @Override
    public void delete (Integer id){
        User user = userRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuario con id "+id + " No encontrado "));
        userRepository.delete(user);
    }


}
