package com.sena.crudCafetin.Repository.BillRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.Entity.Bill.BillDetails;    

@Repository
public interface IBillDetailsRepository extends JpaRepository<BillDetails, Integer> {

}
