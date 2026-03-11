package com.sena.crudCafetin.Service.IService.SecurityIService;

import java.util.List;

import com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest.PersonRequest;
import com.sena.crudCafetin.Dto.SecurityDto.SecurityResponse.PersonResponse;


public interface IPersonService {

    List<PersonResponse> findAll();
    PersonResponse findById(Integer id);
    PersonResponse save(PersonRequest request);
    PersonResponse update(Integer id, PersonRequest request);
    void delete(Integer id);

}
