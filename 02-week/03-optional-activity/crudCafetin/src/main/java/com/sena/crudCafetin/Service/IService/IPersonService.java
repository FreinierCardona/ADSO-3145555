package com.sena.crudCafetin.Service.IService;

import java.util.List;
import com.sena.crudCafetin.Dto.request.PersonRequest;
import com.sena.crudCafetin.Dto.response.PersonResponse;


public interface IPersonService {

    List<PersonResponse> findAll();
    PersonResponse findById(Integer id);
    PersonResponse save(PersonRequest request);
    PersonResponse update(Integer id, PersonRequest request);
    void delete(Integer id);

}
