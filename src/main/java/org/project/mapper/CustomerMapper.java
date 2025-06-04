package org.project.mapper;

import java.util.List;

import org.project.domain.Customer;

public interface CustomerMapper {
    List<Customer> getAllCustomers();
    List<Customer> searchCustomers(String keyword);
    void deleteCustomer(int userno);
    Customer getCustomerByUserno(int userno);
    void insertCustomer(Customer customer);
    int countById(String id);
}
