package com.sena.crudCafetin.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.entity.Role;

@Repository
public interface IRoleRepository extends JpaRepository<Role, Integer> {

}
