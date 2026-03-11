package com.sena.crudCafetin.Entity.Bill;

import jakarta.persistence.*;
import com.sena.crudCafetin.Entity.Inventory.Product;   

@Entity
@Table(name = "bill_details")
public class BillDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column( name = "quantity", nullable = false)
    private Integer quantity;

    // Relación muchos a uno con Bill
    @ManyToOne
    @JoinColumn(name = "bill_id", nullable = false)
    private Bill bill_id;

    // Relación muchos a uno con Product
    @ManyToOne
    @JoinColumn(name = "product_id", nullable = false)
    private Product product_id;

    // Constructor, getters y setters
    public BillDetails() {}

    public BillDetails(Integer id, Integer quantity, Bill bill_id, Product product_id) {
        this.id = id;
        this.quantity = quantity;
        this.bill_id = bill_id;
        this.product_id = product_id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    public Bill getBill_id() {
        return bill_id;
    }

    public void setBill_id(Bill bill_id) {
        this.bill_id = bill_id;
    }

    public Product getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Product product_id) {
        this.product_id = product_id;
    }

    

    
}
