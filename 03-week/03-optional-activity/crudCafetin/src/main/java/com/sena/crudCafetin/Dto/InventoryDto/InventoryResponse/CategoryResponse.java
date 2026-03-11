package com.sena.crudCafetin.Dto.InventoryDto.InventoryResponse;

public class CategoryResponse {

    private Integer id;
    private String name;
    private String description;
    private Boolean active;
    private Integer productCount;

    public CategoryResponse() {
    }

    public CategoryResponse(Integer id, String name, String description, Boolean active, Integer productCount) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.active = active;
        this.productCount = productCount;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public Integer getProductCount() {
        return productCount;
    }

    public void setProductCount(Integer productCount) {
        this.productCount = productCount;
    }

    
}
