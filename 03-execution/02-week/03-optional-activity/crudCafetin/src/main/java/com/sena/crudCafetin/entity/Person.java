package com.sena.crudCafetin.entity;


import jakarta.persistence.*;

@Entity
@Table(name= "person")
public class Person {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column (name= "name", nullable = false)
    private String name;

    @Column (name= "last_name", nullable = false)
    private String lastName;

    @Column (name="email", nullable = false, unique = true)
    private String email;

    // Relacion 1 a 1 con user
    @OneToOne(mappedBy = "person")
    private User user;

    // Constructor, getters y setters
    public Person() { }

    public Person(Integer id, String name, String lastName, String email) {
        this.id = id;
        this.name = name;
        this.lastName = lastName;
        this.email = email;
    }

    public int getId() {
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

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    
}
