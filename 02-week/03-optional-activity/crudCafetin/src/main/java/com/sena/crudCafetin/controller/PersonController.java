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

import com.sena.crudCafetin.Dto.request.PersonRequest;
import com.sena.crudCafetin.Dto.response.PersonResponse;
import com.sena.crudCafetin.Service.IService.IPersonService;

@RestController
@RequestMapping("/api/person")
public class PersonController {

    @Autowired
    private IPersonService personService;

    
    @GetMapping
    public List<PersonResponse> findAll() {
        return personService.findAll();
    }

    @GetMapping("/{id}")
    public PersonResponse findById(@PathVariable Integer id) {
        return personService.findById(id);
    }

    @PostMapping
    public PersonResponse save(@RequestBody PersonRequest request) {
        return personService.save(request);
    }

    @PutMapping("/{id}")
    public PersonResponse update(@PathVariable Integer id,
                                @RequestBody PersonRequest request) {
        return personService.update(id, request);
    }

    @DeleteMapping("/{id}")
    public void delete(@PathVariable Integer id) {
        personService.delete(id);
    }
}

