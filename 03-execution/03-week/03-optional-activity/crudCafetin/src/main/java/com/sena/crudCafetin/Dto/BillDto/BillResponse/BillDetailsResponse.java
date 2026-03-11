package com.sena.crudCafetin.Dto.BillDto.BillResponse;

public class BillDetailsResponse {

    private Integer id;
    private Integer quantity;
    private Integer product_id;
    private String productName;

    public BillDetailsResponse() {
    }

    public BillDetailsResponse(Integer id, Integer quantity, Integer product_id, String productName) {
        this.id = id;
        this.quantity = quantity;
        this.product_id = product_id;
        this.productName = productName;
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

    public Integer getProduct_id() {
        return product_id;
    }

    public void setProduct_id(Integer product_id) {
        this.product_id = product_id;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    
}
