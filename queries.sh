#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib

echo "Enter username"
read username

echo "password"
read -s password

sqlplus64 "$username/$password@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF
SELECT Title, Books.Barcode_number
FROM Books
WHERE EXISTS (SELECT Library_branch FROM BookLocation WHERE
BookLocation.Barcode_number = Books.Barcode_number AND Title = 'The Life of Cheese'AND Library_branch = 'Yonge St');

SELECT BookLocation.Library_branch, COUNT(Checkout.Item_num) As CheckedOutBooks
FROM (Checkout
INNER JOIN BookLocation ON Checkout.Barcode_number = BookLocation.Barcode_number)
GROUP BY BookLocation.Library_branch
HAVING COUNT (Checkout.Item_num) > 1;

SELECT Staff_id FROM Staff
WHERE Staff_id NOT IN 
(SELECT Staff_id
FROM Validation WHERE Staff.Staff_id = Validation.Staff_id )ORDER BY Staff_id;

SELECT Genre,Title
FROM Books
WHERE EXISTS (SELECT Barcode_number FROM Checkout WHERE Checkout.Barcode_number = Books.Barcode_number AND Genre <> 'technology');

exit;
EOF
