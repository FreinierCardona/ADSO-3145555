package com.sena.crudCafetin.Repository.InventoryRepository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.sena.crudCafetin.Entity.Inventory.Product;

@Repository
public interface IProductRepository extends JpaRepository <Product, Integer> {

}
