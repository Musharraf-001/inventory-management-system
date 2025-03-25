#Importing  Libraries
import mysql.connector
import streamlit as st
import pandas as pd

# Function to  connect to the MySQL database.
def get_connection():
    return mysql.connector.connect(
        host="localhost",
        port=3306,
        user="root",
        password="root",
        database="InventoryManagement"
    )

def create_tables():
    conn = get_connection()
    c = conn.cursor()

      
    # Create Suppliers table with supplier details.
    c.execute("""
    CREATE TABLE IF NOT EXISTS Suppliers (
        supplier_id INT AUTO_INCREMENT PRIMARY KEY,
        supplier_name VARCHAR(255) NOT NULL,
        contact_name VARCHAR(255),
        location_supplier VARCHAR(255),
        phone_supplier VARCHAR(20),
        email_supplier VARCHAR(255),
        address_supplier TEXT
    )""")

    #Create product table with products details
    c.execute("""
    CREATE TABLE IF NOT EXISTS Products (
        product_id INT AUTO_INCREMENT PRIMARY KEY,
        product_name VARCHAR(255) NOT NULL,
        description TEXT,
        price_product DECIMAL(10,2) NOT NULL,
        stock_quantity_product INT NOT NULL,
        supplier_id INT,
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
    )""")

    #create customers table with customer detail
    c.execute("""
    CREATE TABLE IF NOT EXISTS Customers (
        customer_id INT AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(255),
        last_name VARCHAR(255),
        email_customer VARCHAR(255) UNIQUE,
        phone_customer VARCHAR(20),
        address_customer TEXT
    )""")

    #create a orders table with order details
    c.execute("""
    CREATE TABLE IF NOT EXISTS Orders (
        order_id INT AUTO_INCREMENT PRIMARY KEY,
        customer_id INT,
        order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        total_amount DECIMAL(10,2),
        status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Refunded') DEFAULT 'Pending',
        FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
    )""")
    conn.commit()
    conn.close()

def execute_query(query, params=()):
    conn = get_connection()
    c = conn.cursor()
    c.execute(query, params)
    conn.commit()
    conn.close()

def fetch_all(query, params=()):
    conn = get_connection()
    c = conn.cursor()
    c.execute(query, params)
    data = c.fetchall()
    conn.close()
    return data

def view_suppliers():
    return fetch_all("SELECT * FROM Suppliers")

def view_products():
    return fetch_all("SELECT * FROM Products")

def view_customers():
    return fetch_all("SELECT * FROM Customers")

def view_orders():
    return fetch_all("SELECT * FROM Orders")

def delete_record(table, column, value):
    execute_query(f"DELETE FROM {table} WHERE {column} = %s", (value,))

# Streamlit UI
st.title("Inventory Management System")
create_tables()

menu = ["Suppliers", "Products", "Customers", "Orders"]
choice = st.sidebar.selectbox("Menu", menu)

def display_table(data, columns, table, column):
    df = pd.DataFrame(data, columns=columns)
    st.dataframe(df)
    if len(data) > 0:
        delete_id = st.selectbox("Select ID to delete", df[columns[0]])
        if st.button("Delete Record"):
            delete_record(table, column, delete_id)
            st.success("Record deleted successfully!")
            st.experimental_rerun()

if choice == "Suppliers":
    st.subheader("Manage Suppliers")
    name = st.text_input("Supplier Name")
    contact = st.text_input("Contact Name")
    location = st.text_input("Location")
    phone = st.text_input("Phone")
    email = st.text_input("Email")
    address = st.text_area("Address")
    if st.button("Add Supplier"):
        execute_query("INSERT INTO Suppliers (supplier_name, contact_name, location_supplier, phone_supplier, email_supplier, address_supplier) VALUES (%s, %s, %s, %s, %s, %s)", (name, contact, location, phone, email, address))
        st.success("Supplier added successfully!")
    st.subheader("Supplier List")
    display_table(view_suppliers(), ["ID", "Name", "Contact", "Location", "Phone", "Email", "Address"], "Suppliers", "supplier_id")

elif choice == "Products":
    st.subheader("Manage Products")
    name = st.text_input("Product Name")
    desc = st.text_area("Description")
    price = st.number_input("Price", min_value=0.01)
    stock = st.number_input("Stock Quantity", min_value=0)
    suppliers = view_suppliers()
    supplier_dict = {s[0]: s[1] for s in suppliers}
    supplier_id = st.selectbox("Supplier", list(supplier_dict.keys()), format_func=lambda x: supplier_dict[x])
    if st.button("Add Product"):
        execute_query("INSERT INTO Products (product_name, description, price_product, stock_quantity_product, supplier_id) VALUES (%s, %s, %s, %s, %s)", (name, desc, price, stock, supplier_id))
        st.success("Product added successfully!")
    st.subheader("Product List")
    display_table(view_products(), ["ID", "Name", "Description", "Price", "Stock", "Supplier ID"], "Products", "product_id")

elif choice == "Customers":
    st.subheader("Manage Customers")
    first_name = st.text_input("First Name")
    last_name = st.text_input("Last Name")
    email = st.text_input("Email")
    phone = st.text_input("Phone")
    address = st.text_area("Address")
    if st.button("Add Customer"):
        execute_query("INSERT INTO Customers (first_name, last_name, email_customer, phone_customer, address_customer) VALUES (%s, %s, %s, %s, %s)", (first_name, last_name, email, phone, address))
        st.success("Customer added successfully!")
    st.subheader("Customer List")
    display_table(view_customers(), ["ID", "First Name", "Last Name", "Email", "Phone", "Address"], "Customers", "customer_id")

elif choice == "Orders":
    st.subheader("Manage Orders")
    customers = view_customers()
    customer_dict = {c[0]: f"{c[1]} {c[2]}" for c in customers}
    customer_id = st.selectbox("Customer", list(customer_dict.keys()), format_func=lambda x: customer_dict[x])
    order_date = st.date_input("Order Date")
    total_amount = st.number_input("Total Amount", min_value=0.01)
    status = st.selectbox("Order Status", ["Pending", "Shipped", "Delivered", "Cancelled", "Refunded"])
    if st.button("Add Order"):
        execute_query("INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES (%s, %s, %s, %s)", (customer_id, str(order_date), total_amount, status))
        st.success("Order added successfully!")
    st.subheader("Order List")
    display_table(view_orders(), ["ID", "Customer ID", "Order Date", "Total Amount", "Status"], "Orders", "order_id")

