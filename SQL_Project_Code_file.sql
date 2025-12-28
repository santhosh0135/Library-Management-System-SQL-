CREATE DATABASE SQL_PROJECT;

USE SQL_PROJECT;

-- Table: publisher 
CREATE TABLE publisher ( 
    publisher_PublisherName VARCHAR(255) PRIMARY KEY, 
    publisher_PublisherAddress TEXT, 
    publisher_PublisherPhone VARCHAR(15) 
);
SELECT * FROM PUBLISHER;
 -- Table: book 
CREATE TABLE book ( 
    book_BookID INT PRIMARY KEY, 
    book_Title VARCHAR(255), 
    book_PublisherName VARCHAR(255), 
    FOREIGN KEY (book_PublisherName) REFERENCES 
    publisher(publisher_PublisherName) 
);
SELECT * FROM BOOK;
 -- Table: book_authors 
CREATE TABLE book_authors ( 
    book_authors_AuthorID INT PRIMARY KEY AUTO_INCREMENT, 
    book_authors_BookID INT, 
    book_authors_AuthorName VARCHAR(255), 
 
    FOREIGN KEY (book_authors_BookID) REFERENCES book(book_BookID) 
);
SELECT * FROM BOOK_authors;
 -- Table: library_branch 
CREATE TABLE library_branch ( 
    library_branch_BranchID INT PRIMARY KEY AUTO_INCREMENT, 
    library_branch_BranchName VARCHAR(255), 
    library_branch_BranchAddress TEXT 
); 
SELECT * FROM library_branch;
 -- Table: book_copies 
CREATE TABLE book_copies ( 
    book_copies_CopiesID INT PRIMARY KEY AUTO_INCREMENT, 
    book_copies_BookID INT, 
    book_copies_BranchID INT, 
    book_copies_No_Of_Copies INT, 
    FOREIGN KEY (book_copies_BookID) REFERENCES book(book_BookID), 
    FOREIGN KEY (book_copies_BranchID) REFERENCES 
    library_branch(library_branch_BranchID) 
);
SELECT * FROM book_copies;
 -- Table: borrower 
CREATE TABLE borrower ( 
    borrower_CardNo INT PRIMARY KEY, 
    borrower_BorrowerName VARCHAR(255), 
    borrower_BorrowerAddress TEXT, 
    borrower_BorrowerPhone VARCHAR(15) 
);
SELECT * FROM borrower;
 -- Table: book_loans 
CREATE TABLE book_loans ( 
    book_loans_LoansID INT PRIMARY KEY AUTO_INCREMENT, 
    book_loans_BookID INT, 
    book_loans_BranchID INT, 
    book_loans_CardNo INT, 
    book_loans_DateOut DATE, 
    book_loans_DueDate DATE, 
    FOREIGN KEY (book_loans_BookID) REFERENCES book(book_BookID), 
    FOREIGN KEY (book_loans_BranchID) REFERENCES 
    library_branch(library_branch_BranchID), 
    FOREIGN KEY (book_loans_CardNo) REFERENCES borrower(borrower_CardNo) 
);

SELECT * FROM book_loans;

-- 1 How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?
select book_copies_no_of_Copies FROM `book_copies`
where book_copies_CopiesID = (SELECT book_BookID
from book WHERE book_Title = 'The Lost Tribe')
and book_copies_BranchID = (SELECT library_branch_BranchID
from `library_branch` WHERE library_branch_BranchName = 'Sharpstown');

-- 2 How many copies of the book titled "The Lost Tribe" are owned by each library branch?
SELECT library_branch_BranchName, book_copies_No_Of_Copies
FROM `book_copies`
JOIN `book` ON book_copies_copiesID = book_BookID
JOIN `library_branch` ON book_copies_BranchID = library_branch_BranchID
WHERE book_Title = 'The Lost Tribe';

-- 3 Retrieve the names of all borrowers who do not have any books checked out.
select borrower_BorrowerName from borrower
left join `book_loans` on borrower_CardNo = book_loans_CardNo
where book_loans_loansID is null;

-- 4 For each book that is loaned out from the "Sharpstown" branch and whose DueDate is 2/3/18, retrieve the book title, the borrower's name, and the borrower's address.
SELECT book_Title, borrower_borrowername, borrower_borroweraddress
FROM `book_loans`
JOIN book ON book_loans.book_loans_loansID = book.book_bookID
JOIN borrower ON book_loans.book_loans_CardNo = borrower.borrower_CardNo
JOIN `library_branch` ON book_loans.book_loans_BranchID = library_branch.library_branch_BranchID
WHERE library_branch.library_branch_BranchName = 'Sharpstown'
AND book_loans_DueDate = '0002-02-18';

-- 5 For each library branch, retrieve the branch name and the total number of books loaned out from that branch.
SELECT library_branch_BranchName, 
COUNT('book_loans_LoansID')
FROM `library_branch`
JOIN `book_loans` ON library_branch_BranchID = book_loans_BranchID
GROUP BY library_branch_BranchName;

-- 6 Retrieve the names, addresses, and number of books checked out for all borrowers who have more than five books 
-- checked out.
SELECT borrower_BorrowerName, borrower_BorrowerAddress, 
COUNT('book_loans_copiesID')
FROM borrower
JOIN `book_loans` ON borrower_CardNo = book_loans_CardNo
GROUP BY borrower_CardNo, borrower_BorrowerName, borrower_BorrowerAddress
HAVING COUNT(book_loans_loansID) > 5;

-- 7 For each book authored by "Stephen King", retrieve the title and the number of copies owned by the library branch whose name is "Central".
SELECT book_Title, book_copies_No_Of_Copies
FROM book_authors
JOIN book ON book_authors_authorID = book_bookid
JOIN `book_copies` ON book_bookID = book_copies_copiesid
JOIN `library_branch` ON book_copies_copiesID = library_branch_Branchid
WHERE book_authors_AuthorName = 'Stephen King'
AND library_branch_BranchName = 'Central';