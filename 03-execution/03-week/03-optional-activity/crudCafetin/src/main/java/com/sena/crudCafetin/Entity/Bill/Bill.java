package com.sena.crudCafetin.Entity.Bill;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name = "bills")
public class Bill {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column (name = "bill_number", nullable = false)
    private String billNumber;

    @Column (name = "customer_name", nullable = false)
    private String customerName;

    @Column ( name = "date", nullable = false)
    private String date;

    @Column (name = "total_price", nullable = false)
    private Double totalPrice;


    // Relación uno a muchos con BillDetails
    @OneToMany(mappedBy = "bill", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<BillDetails> billDetails;


    // Constructor, getters y setters
    
    public Bill() {}

    public Bill(Integer id, String billNumber, String customerName, String date, Double totalPrice,
            List<BillDetails> billDetails) {
        this.id = id;
        this.billNumber = billNumber;
        this.customerName = customerName;
        this.date = date;
        this.totalPrice = totalPrice;
        this.billDetails = billDetails;
    }
    
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getBillNumber() {
        return billNumber;
    }

    public void setBillNumber(String billNumber) {
        this.billNumber = billNumber;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public List<BillDetails> getBillDetails() {
        return billDetails;
    }

    public void setBillDetails(List<BillDetails> billDetails) {
        this.billDetails = billDetails;
    }

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    


}
