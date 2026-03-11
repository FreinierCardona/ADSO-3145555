package com.sena.crudCafetin.Repository.SecurityRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.sena.crudCafetin.Entity.Security.UserRole;

@Repository
public interface IUserRoleRepository extends JpaRepository<UserRole, Integer> {

}
