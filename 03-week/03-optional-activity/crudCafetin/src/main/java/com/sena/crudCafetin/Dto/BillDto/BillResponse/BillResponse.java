package com.sena.crudCafetin.Dto.BillDto.BillResponse;

import java.util.List;

public class BillResponse {

    private Integer id;
    private String billNumber;
    private String customerName;
    private String date;
    private Double totalPrice;
    private List<BillDetailsResponse> billDetails;

    public BillResponse() {
    }

    public BillResponse(Integer id, String billNumber, String customerName, String date, Double totalPrice,
            List<BillDetailsResponse> billDetails) {
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

    public Double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(Double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public List<BillDetailsResponse> getBillDetails() {
        return billDetails;
    }

    public void setBillDetails(List<BillDetailsResponse> billDetails) {
        this.billDetails = billDetails;
    }

    
}
