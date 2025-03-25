#Create Database
CREATE DATABASE InventoryManagement;
USE InventoryManagement;

#Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(255) NOT NULL,
    contact_name VARCHAR(255),
    location_supplier varchar(255),
    phone_supplier VARCHAR(20),
    email_supplier VARCHAR(255),
    address_supplier TEXT
);

#Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    price_product DECIMAL(10,2) NOT NULL,
    stock_quantity_product INT NOT NULL,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
);

#Customers Table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email_customer VARCHAR(255) UNIQUE,
    phone_customer VARCHAR(20),
    address_customer TEXT
);

#Orders Table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

#Order_Items Table (Link between Orders and Products)
CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    Description Text,
    price_product  DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

alter table Order_Items add customer_id INT;
 
#Invoices Table
CREATE TABLE Invoices (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT UNIQUE,
    invoice_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2),
    status ENUM('Paid', 'Unpaid', 'Cancelled', 'Refunded') DEFAULT 'Unpaid',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

#Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'Net Banking', 'Cash', 'UPI'),
    Total_amount DECIMAL(10,2),
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id) ON DELETE CASCADE
);

#Users Table (Admin, Staff, Customers)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
	role ENUM('Customer', 'Supplier', 'Admin') NOT NULL
);

ALTER TABLE Users MODIFY role ENUM('Customer', 'Supplier', 'Admin');


#Creation of the data merging in future which I can collabrate with all projects

#Events Table (For future event scheduling)
CREATE TABLE Events (
    event_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    event_name VARCHAR(255) NOT NULL,
    event_date DATE,
    location VARCHAR(255),
	payment_id INT,
    description TEXT,
    FOREIGN KEY (invoice_id) REFERENCES Invoices(invoice_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id) ON DELETE CASCADE
);

#Tickets Table updating 
CREATE TABLE Tickets (
    ticket_id INT PRIMARY KEY AUTO_INCREMENT,
    event_id INT,
    customer_id INT,
    ticket_price DECIMAL(10,2),
    seat_number VARCHAR(50),
    status ENUM('Pending', 'Shipped', 'Delivered', 'Cancelled', 'Refunded') DEFAULT 'Pending',
    FOREIGN KEY (event_id) REFERENCES Events(event_id) ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

#Inserting the values
INSERT INTO Suppliers (supplier_id, supplier_name, contact_name, location_supplier, phone_supplier, email_supplier, address_supplier) VALUES
(101, 'Uma Pvt Ltd', 'Uma', 'Andhra Pradesh', '9522007415', 'Abd@gmail.com', 'Andhra Pradesh'),
(102, 'Praveen Pvt Ltd', 'Praveen', 'Arunachal Pradesh', '9522007416', 'Abd@gmail.com', 'Arunachal Pradesh'),
(103, 'Kavin Pvt Ltd', 'Kavin', 'Assam', '9522007417', 'Abd@gmail.com', 'Assam'),
(104, 'Sandeep Pvt Ltd', 'Sandeep', 'Bihar', '9522007418', 'Abd@gmail.com', 'Bihar'),
(105, 'Jayant Pvt Ltd', 'Jayant', 'Chhattisgarh', '9522007419', 'Abd@gmail.com', 'Chhattisgarh'),
(106, 'Devanesh Pvt Ltd', 'Devanesh', 'Goa', '9522007420', 'Abd@gmail.com', 'Goa'),
(107, 'Arun Pvt Ltd', 'Arun', 'Gujarat', '9522007421', 'Abd@gmail.com', 'Gujarat'),
(108, 'Vishnu Pvt Ltd', 'Vishnu', 'Haryana', '9522007422', 'Abd@gmail.com', 'Haryana'),
(109, 'Hari Pvt Ltd', 'Hari', 'Himachal Pradesh', '9522007423', 'Abd@gmail.com', 'Himachal Pradesh'),
(110, 'Lokesh Pvt Ltd', 'Lokesh', 'Jharkhand', '9522007424', 'Abd@gmail.com', 'Jharkhand'),
(111, 'Mohan Pvt Ltd', 'Mohan', 'Karnataka', '9522007425', 'Abd@gmail.com', 'Karnataka'),
(112, 'Sanjay Pvt Ltd', 'Sanjay', 'Kerala', '9522007426', 'Abd@gmail.com', 'Kerala'),
(113, 'Kesavan Pvt Ltd', 'Kesavan', 'Madhya Pradesh', '9522007427', 'Abd@gmail.com', 'Madhya Pradesh'),
(114, 'Sakthi Pvt Ltd', 'Sakthi', 'Maharashtra', '9522007428', 'Abd@gmail.com', 'Maharashtra'),
(115, 'Dhanesh Pvt Ltd', 'Dhanesh', 'Manipur', '9522007429', 'Abd@gmail.com', 'Manipur');

INSERT INTO Products (product_id, product_name, description, price_product, stock_quantity_product, supplier_id) VALUES
(201, 'Laptop', 'Portable computer', 50000, 60, 101),
(202, 'Smartphone', 'Mobile device', 25000, 50, 102),
(203, 'Headphones', 'Audio accessory', 2000, 100, 103),
(204, 'Smartwatch', 'Wearable tech', 5000, 85, 104),
(205, 'Power Bank', 'Charging device', 500, 50, 105),
(206, 'Notebooks', 'Writing pads', 100, 1000, 106),
(207, 'Printers', 'Document printer', 50000, 100, 107),
(208, 'Stationery Kit', 'Office supplies', 200, 2000, 108),
(209, 'Whiteboards', 'Writing board', 5000, 100, 109),
(210, 'Projector', 'Display device', 10000, 50, 110),
(211, 'Concert Tickets', 'Event entry', 250, 500, 111),
(212, 'Merchandise', 'Branded items', 1000, 50, 112),
(213, 'Gift Cards', 'Prepaid voucher', 500, 300, 113),
(214, 'Birthday Decorations', 'Party decor', 1000, 400, 114),
(215, 'Wedding Essentials', 'Ceremony supplies', 200000, 500, 115);

INSERT INTO Customers (customer_id, first_name, last_name, email_customer, phone_customer, address_customer) VALUES
(301, 'Aarav', 'Sharma', 'aarav123@gmail.com', '9876543210', 'Mumbai'),
(302, 'Vihaan', 'Mehta', 'vihaan.mehta@gmail.com', '8765432109', 'Delhi'),
(303, 'Ishaan', 'Patel', 'ishaan.patel@yahoo.com', '7654321098', 'Bangalore'),
(304, 'Rohan', 'Verma', 'rohan.verma@hotmail.com', '9543216780', 'Hyderabad'),
(305, 'Kabir', 'Rao', 'kabirrao123@gmail.com', '8456789123', 'Chennai'),
(306, 'Ananya', 'Iyer', 'ananya.iyer@gmail.com', '9123456789', 'Kolkata'),
(307, 'Siya', 'Nair', 'siya.nair@yahoo.com', '9988776655', 'Pune'),
(308, 'Avni', 'Kulkarni', 'avni.kulkarni@gmail.com', '8877665544', 'Ahmedabad'),
(309, 'Tanvi', 'Joshi', 'tanvi.joshi@hotmail.com', '9654321789', 'Jaipur'),
(310, 'Meera', 'Desai', 'meera.desai@gmail.com', '8543216789', 'Lucknow'),
(311, 'Arjun', 'Malhotra', 'arjun.malhotra@yahoo.com', '7890654321', 'Chandigarh'),
(312, 'Devansh', 'Bhatia', 'devansh.bhatia@gmail.com', '6789123456', 'Indore'),
(313, 'Kiran', 'Reddy', 'kiran.reddy123@gmail.com', '9123678540', 'Bhopal'),
(314, 'Sneha', 'Choudhury', 'sneha.choudhury@hotmail.com', '8901234567', 'Coimbatore'),
(315, 'Rahul', 'Yadav', 'rahul.yadav@gmail.com', '9567894321', 'Thiruvananthapuram');

INSERT INTO Orders (order_id, customer_id, order_date, total_amount, status) VALUES
(601, 301, '2024-03-18', 1250.5, 'Pending'),
(602, 302, '2024-03-19', 2300, 'Shipped'),
(603, 303, '2024-03-20', 750.75, 'Delivered'),
(604, 304, '2024-03-21', 1899.99, 'Cancelled'),
(605, 305, '2024-03-22', 999.5, 'Refunded'),
(606, 306, '2024-03-23', 450, 'Pending'),
(607, 307, '2024-03-24', 3000, 'Shipped'),
(608, 308, '2024-03-25', 1299.99, 'Delivered'),
(609, 309, '2024-03-26', 500, 'Cancelled'),
(610, 310, '2024-03-27', 750.5, 'Refunded'),
(611, 311, '2024-03-28', 2200, 'Pending'),
(612, 312, '2024-03-29', 1800.75, 'Shipped'),
(613, 313, '2024-03-30', 450.99, 'Delivered'),
(614, 314, '2024-03-31', 1399.49, 'Cancelled'),
(615, 315, '2024-04-01', 2000, 'Refunded');

INSERT INTO Order_Items (order_item_id, order_id, customer_id, product_id, quantity, description, price_product, subtotal) 
VALUES 
(401, 601, 301, 201, 2, 'Laptop', 50000, 100000),
(402, 602, 302, 202, 1, 'Smartphone', 25000, 25000),
(403, 603, 303, 203, 3, 'Headphones', 2000, 6000),
(404, 604, 304, 204, 2, 'Smartwatch', 5000, 10000),
(405, 605, 305, 205, 1, 'Power Bank', 1500, 1500),
(406, 606, 306, 206, 4, 'Notebooks', 250, 1000),
(407, 607, 307, 207, 1, 'Printers', 12000, 12000),
(408, 608, 308, 208, 2, 'Stationery Kit', 500, 1000),
(409, 609, 309, 209, 1, 'Whiteboards', 3500, 3500),
(410, 610, 310, 210, 1, 'Projector', 15000, 15000),
(411, 611, 311, 211, 3, 'Concert Tickets', 1000, 3000),
(412, 612, 312, 212, 2, 'Merchandise', 700, 1400),
(413, 613, 313, 213, 1, 'Gift Cards', 2000, 2000),
(414, 614, 314, 214, 5, 'Birthday Decorations', 500, 2500),
(415, 615, 315, 215, 2, 'Wedding Essentials', 3000, 6000);

INSERT INTO Invoices (invoice_id, order_id, invoice_date, total_amount, status) 
VALUES 
(501, 601, '2024-03-18', 1250.5, 'Unpaid'),
(502, 602, '2024-03-19', 2300, 'Paid'),
(503, 603, '2024-03-20', 750.75, 'Paid'),
(504, 604, '2024-03-21', 1899.99, 'Cancelled'),
(505, 605, '2024-03-22', 999.5, 'Refunded'),
(506, 606, '2024-03-23', 450, 'Unpaid'),
(507, 607, '2024-03-24', 3000, 'Paid'),
(508, 608, '2024-03-25', 1299.99, 'Paid'),
(509, 609, '2024-03-26', 500, 'Cancelled'),
(510, 610, '2024-03-27', 750.5, 'Refunded'),
(511, 611, '2024-03-28', 2200, 'Unpaid'),
(512, 612, '2024-03-29', 1800.75, 'Paid'),
(513, 613, '2024-03-30', 450.99, 'Paid'),
(514, 614, '2024-03-31', 1399.49, 'Cancelled'),
(515, 615, '2024-04-01', 2000, 'Refunded');

INSERT INTO Payments (payment_id, invoice_id, payment_date, payment_method, total_amount) 
VALUES 
(1001, 502, '2024-03-19', 'Debit Card', 2300),
(1002, 503, '2024-03-20', 'UPI', 750.75),
(1003, 507, '2024-03-24', 'Credit Card', 3000),
(1004, 508, '2024-03-25', 'Debit Card', 1299.99),
(1005, 512, '2024-03-29', 'Net Banking', 1800.75),
(1006, 513, '2024-03-30', 'UPI', 450.99);


USE InventoryManagement;
INSERT INTO users (user_id, username, password, role) VALUES
(301, 'Aarav', 'Pass@1234', 'Customer'),
(302, 'Vihaan', 'Pass@1235', 'Customer'),
(303, 'Ishaan', 'Pass@1236', 'Customer'),
(304, 'Rohan', 'Pass@1237', 'Customer'),
(305, 'Kabir', 'Pass@1238', 'Customer'),
(306, 'Ananya', 'Pass@1239', 'Customer'),
(307, 'Siya', 'Pass@1240', 'Customer'),
(308, 'Avni', 'Pass@1241', 'Customer'),
(309, 'Tanvi', 'Pass@1242', 'Customer'),
(310, 'Meera', 'Pass@1243', 'Customer'),
(311, 'Arjun', 'Pass@1244', 'Customer'),
(312, 'Devansh', 'Pass@1245', 'Customer'),
(313, 'Kiran', 'Pass@1246', 'Customer'),
(314, 'Sneha', 'Pass@1247', 'Customer'),
(315, 'Rahul', 'Pass@1248', 'Customer');

INSERT INTO users (user_id, username, password, role) VALUES
(101, 'Uma', '1234', 'Supplier'),
(102, 'Praveen', '1235', 'Supplier'),
(103, 'Kavin', '1236', 'Supplier'),
(104, 'Sandeep', '1237', 'Supplier'),
(105, 'Jayant', '1238', 'Supplier'),
(106, 'Devanesh', '1239', 'Supplier'),
(107, 'Arun', '1240', 'Supplier'),
(108, 'Vishnu', '1241', 'Supplier'),
(109, 'Hari', '1242', 'Supplier'),
(110, 'Lokesh', '1243', 'Supplier'),
(111, 'Mohan', '1244', 'Supplier'),
(112, 'Sanjay', '1245', 'Supplier'),
(113, 'Kesavan', '1246', 'Supplier'),
(114, 'Sakthi', '1247', 'Supplier'),
(115, 'Dhanesh', '1248', 'Supplier');

INSERT INTO users (user_id, username, password, role) VALUES
(242211, 'admin_Tharun', 'Admin@9999', 'Admin'),
(242212, 'admin_Musaraff', 'Admin@10000', 'Admin'),
(242213, 'admin_Arun', 'Admin@10001', 'Admin');


