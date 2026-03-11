package com.sena.crudCafetin.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.entity.UserRole;

@Repository
public interface IUserRoleRepository extends JpaRepository<UserRole, Integer> {

}
