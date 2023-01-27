#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

echo "Enter username"
read username

echo "password"
read -s password

sqlplus64 "$username/$password@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF
CREATE TABLE Readers(
   Libcard_num NUMBER(20) PRIMARY KEY NOT NULL,
   Address VARCHAR2(50) NOT NULL,
   Email VARCHAR2 (30) NOT NULL,
   First_name VARCHAR2(20) NOT NULL,
   Last_name VARCHAR2(20) NOT NULL,
   Total_Checked_Out NUMBER(20) NOT NULL
);

CREATE TABLE Staff(
   Staff_id INTEGER PRIMARY KEY NOT NULL,
   Email VARCHAR2 (30) NOT NULL,
   First_name VARCHAR2(20) NOT NULL,
   Last_name VARCHAR2(20) NOT NULL 
);

CREATE TABLE Validation(
   Staff_id INTEGER NOT NULL CONSTRAINT Validation_id_fk REFERENCES Staff (Staff_id)PRIMARY KEY,
   Password VARCHAR2(30) NOT NULL
);

CREATE TABLE Books (
  Title VARCHAR2(50) NOT NULL,
  AuthorFirstName VARCHAR2(50) NOT NULL,
  AuthorLastName VARCHAR2(50) NOT NULL,
  Genre VARCHAR2(50) NOT NULL,
  ISBN INTEGER NOT NULL,
  NumOfBook INTEGER,
  Price INTEGER,
  Published DATE,
  publishingHouse VARCHAR2(50) NOT NULL,
  Barcode_number NUMBER(30) NOT NULL PRIMARY KEY 
);

CREATE TABLE Checkout (
  Item_num INTEGER NOT NULL PRIMARY KEY,
  Staff_id INTEGER NOT NULL CONSTRAINT Checkout_staff_id_fk REFERENCES Staff (Staff_id),
  Libcard_num NUMBER(20) NOT NULL CONSTRAINT Checkout_cardNum_fk REFERENCES Readers (Libcard_num), 
  CheckOut DATE NOT NULL,
  Due_date DATE NOT NULL, --three weeks from checkout date
  Barcode_number NUMBER(30) NOT NULL CONSTRAINT Checkout_barcode_fk REFERENCES Books(Barcode_number)
);

CREATE TABLE CheckIn (
  Item_num INTEGER NOT NULL PRIMARY KEY,
  Staff_id INTEGER NOT NULL CONSTRAINT Checkin_staff_id_fk REFERENCES Staff (Staff_id),
  Libcard_num NUMBER(20) NOT NULL CONSTRAINT Checkin_cardNum_fk REFERENCES Readers (Libcard_num), 
  CheckInDate DATE NOT NULL,
  Barcode_number NUMBER(30) NOT NULL CONSTRAINT Checkin_barcode_fk REFERENCES Books(Barcode_number)
);

CREATE TABLE BookLocation (
  Library_branch VARCHAR2(30) NOT NULL,
  Room INTEGER NOT NULL,
  Barcode_number NUMBER(30) NOT NULL CONSTRAINT BookLocation_barcode_fk REFERENCES Books(Barcode_number),
  CONSTRAINT pk_BookLocation 
      PRIMARY KEY(Barcode_number)
);

CREATE TABLE Publisher ( 
  Barcode_number NUMBER(30) NOT NULL CONSTRAINT Publisher_callnum_fk REFERENCES Books(Barcode_number),
  yearPublished INTEGER,
  publishingHouse VARCHAR2(50) NOT NULL,
  publisherId INTEGER PRIMARY KEY NOT NULL
);

exit;
EOF