package com.sena.crudCafetin.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.entity.Person;

@Repository
public interface IPersonRepository extends JpaRepository <Person, Integer>{

}
