package com.sena.crudCafetin.entity;

import jakarta.persistence.*;
import java.util.List;

@Entity
@Table(name= "users")
public class User {

   @Id
   @GeneratedValue(strategy = GenerationType.IDENTITY) 
    private Integer id;

    @Column (name = "userName", nullable = false, unique = true)
    private String userName;

    @Column (name= "password", nullable = false)
    private String password;

    // Relacion 1 a 1 con person
    @OneToOne
    @JoinColumn(name = "person_id", nullable = false, unique = true)
    private Person person;

    // Relacion con UserRole
    @OneToMany(mappedBy = "user")
    private List<UserRole> userRoles;

    // Constructor, getters y setters
    public User() { }

    public User(Integer id, String userName, String password, Person person) {
        this.id = id;
        this.userName = userName;
        this.password = password;
        this.person = person;
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Person getPerson() {
        return person;
    }

    public void setPerson(Person person) {
        this.person = person;
    }

    public List<UserRole> getUserRoles() {
        return userRoles;
    }

    public void setUserRoles(List<UserRole> userRoles) {
        this.userRoles = userRoles;
    }

    
}
