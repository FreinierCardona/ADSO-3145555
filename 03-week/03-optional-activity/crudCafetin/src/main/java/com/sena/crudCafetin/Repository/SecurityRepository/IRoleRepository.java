package com.sena.crudCafetin.Repository.SecurityRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.crudCafetin.Entity.Security.Role;

@Repository
public interface IRoleRepository extends JpaRepository<Role, Integer> {

}
