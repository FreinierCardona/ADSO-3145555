package com.sena.crudCafetin.Dto.BillDto.BillRequest;

public class BillDetailsRequest {

    private Long productId;
    private Integer quantity;

    public BillDetailsRequest() {
    }

    public BillDetailsRequest(Long productId, Integer quantity) {
        this.productId = productId;
        this.quantity = quantity;
    }

    public Long getProductId() {
        return productId;
    }

    public void setProductId(Long productId) {
        this.productId = productId;
    }

    public Integer getQuantity() {
        return quantity;
    }

    public void setQuantity(Integer quantity) {
        this.quantity = quantity;
    }

    

}
