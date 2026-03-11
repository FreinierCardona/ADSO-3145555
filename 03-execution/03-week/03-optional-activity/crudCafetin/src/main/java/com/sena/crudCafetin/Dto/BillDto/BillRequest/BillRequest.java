package com.sena.crudCafetin.Dto.BillDto.BillRequest;

import java.util.List;

public class BillRequest {

    private String billNumber;
    private String customerName;
    private String date;
    private List<BillDetailsRequest> billDetails;   
    
    public BillRequest() {
    }

    public BillRequest(String billNumber, String customerName, String date, List<BillDetailsRequest> billDetails) {
        this.billNumber = billNumber;
        this.customerName = customerName;
        this.date = date;
        this.billDetails = billDetails;
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

    public List<BillDetailsRequest> getBillDetails() {
        return billDetails;
    }

    public void setBillDetails(List<BillDetailsRequest> billDetails) {
        this.billDetails = billDetails;
    }

    

}
