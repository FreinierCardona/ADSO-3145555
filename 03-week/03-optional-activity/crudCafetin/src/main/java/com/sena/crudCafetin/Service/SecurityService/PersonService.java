package com.sena.crudCafetin.Service.SecurityService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import com.sena.crudCafetin.Entity.Security.Person;
import com.sena.crudCafetin.Mapper.SecurityMapper.PersonMapper;
import com.sena.crudCafetin.Repository.SecurityRepository.IPersonRepository;
import com.sena.crudCafetin.Service.IService.SecurityIService.IPersonService;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.PersonRequest;

import java.util.List;


import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.PersonResponse;

@Service
public class PersonService implements IPersonService {

    @Autowired
    private IPersonRepository IPersonRepository;

    // Listar todas las personas
    @Override
    public List<PersonResponse> findAll() {
        return IPersonRepository.findAll()
                .stream()
                .map(PersonMapper::toResponse)
                .toList();
    }

    // Buscar persona por id
    @Override
    public PersonResponse findById(Integer id){
        Person person = IPersonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona con id "+id + " No encontrada "));
        return PersonMapper.toResponse(person);
    }

    // Crear una nueva persona
    @Override
    public PersonResponse save (PersonRequest request){
        Person person = PersonMapper.toEntity(request);
        person = IPersonRepository.save(person);
        return PersonMapper.toResponse(person);
    }

    // Actualizar una persona existente
    @Override
    public PersonResponse update (Integer id, PersonRequest request){
        Person person = IPersonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona con id "+id + " No encontrada "));

        // Actualizar los campos de la persona con los datos del request
        person.setName(request.getName());
        person.setLastName(request.getLastName());
        person.setEmail(request.getEmail());

        person = IPersonRepository.save(person);
        return PersonMapper.toResponse(person);
    }

    // Eliminar una persona por id
    @Override
    public void delete (Integer id){
        Person person = IPersonRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Persona con id "+id + " No encontrada "));
        IPersonRepository.delete(person);
    }
}
