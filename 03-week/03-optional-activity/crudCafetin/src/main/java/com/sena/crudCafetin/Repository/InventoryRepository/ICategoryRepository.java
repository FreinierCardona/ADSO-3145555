package com.sena.crudCafetin.Repository.InventoryRepository;

import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.sena.crudCafetin.Entity.Inventory.Category;

@Repository
public interface ICategoryRepository extends JpaRepository <Category, Integer>{

}
