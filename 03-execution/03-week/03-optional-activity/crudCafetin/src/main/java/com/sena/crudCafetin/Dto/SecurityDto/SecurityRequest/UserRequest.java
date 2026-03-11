package com.sena.crudCafetin.Dto.SecurityDto.SecurityRequest;

public class UserRequest {

    private String userName;
    private String password;
    private Integer personId;

    public UserRequest() {}

    public UserRequest(String userName, String password, Integer personId) {
        this.userName = userName;
        this.password = password;
        this.personId = personId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getPersonId() {
        return personId;
    }

    public void setPersonId(Integer personId) {
        this.personId = personId;
    }

    
}
