package com.sena.crudCafetin.Repository.BillRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.Entity.Bill.Bill;

@Repository
public interface IBillRepository extends JpaRepository <Bill, Integer> {

}
