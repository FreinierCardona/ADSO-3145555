package com.sena.crudCafetin.mapper;

import com.sena.crudCafetin.Dto.request.PersonRequest;
import com.sena.crudCafetin.Dto.response.PersonResponse;
import com.sena.crudCafetin.entity.Person;

public class PersonMapper {

    // Request a Entity
    public static Person toEntity(PersonRequest request){
        Person person = new Person();
        person.setName(request.getName());
        person.setLastName(request.getLastName());
        person.setEmail(request.getEmail());
        return person;
    }

    // Entity a Response
    public static PersonResponse toResponse(Person person){
        return new PersonResponse(
            person.getId(),
            person.getName(),
            person.getLastName(),
            person.getEmail()
        );
    }
}
