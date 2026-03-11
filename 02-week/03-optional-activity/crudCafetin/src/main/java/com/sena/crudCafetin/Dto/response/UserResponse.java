package com.sena.crudCafetin.Dto.response;

public class UserResponse {

    private Integer id;
    private String userName;
    private Integer personId;
    
    public UserResponse() {}
    
    public UserResponse(Integer id, String userName, Integer personId) {
        this.id = id;
        this.userName = userName;
        this.personId = personId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    


}
