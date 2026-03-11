package com.sena.crudCafetin.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.entity.User;

@Repository
public interface IUserRepository extends JpaRepository<User, Integer> {


}
