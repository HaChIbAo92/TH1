--tạo db
create database MarkManagement
go 
use MarkManagement
go


--tạo bảng
create table Students
(
StudentID Nvarchar(12) Primary key,
StudentName Nvarchar(25) Not null,
DateofBirth Datetime Not null,
Email Nvarchar(40),
Phone Nvarchar(12),
Class Nvarchar(10),
)

create table Subjects
(
SubjectID Nvarchar(10) Primary key,
SubjectName Nvarchar(25) not null,
)

create table Mark
(
StudentID Nvarchar(12) FOREIGN KEY REFERENCES Students(StudentID),
SubjectID Nvarchar(10) FOREIGN KEY REFERENCES Subjects(SubjectID),
Datee Datetime,
Theory Tinyint,
Practical Tinyint,
CONSTRAINT PK_Mark PRIMARY KEY (StudentID,SubjectID)
)


--Chèn dl vào bảng
---students
insert into Students
values ('AV0807005', N'Mail Trung Hiếu', '11/10/1989', 'trunghieu@yahoo.com', '0904115116', 'AV1')
insert into Students
values ('AV0807006', N'Nguyễn Quý Hùng', '2/12/1988', 'quyhung@yahoo.com', '0955667787', 'AV2')
insert into Students
values ('AV0807007', N'Đỗ Đắc Huỳnh', '2/1/1990', 'dachuynh@yahoo.com', '0988574747', 'AV2')
insert into Students
values ('AV0807009', N'An Đăng Khuê', '6/3/1986', 'dangkhue@yahoo.com', '0986757463', 'AV1')
insert into Students
values ('AV0807010', N'Nguyễn T. Tuyết Lan', '12/7/1989', 'tuyetlan@yahoo.com', '0986757463', 'AV2')
insert into Students
values ('AV0807011', N'Đinh Phụng Long', '2/12/1990', 'phunglong@yahoo.com', '', 'AV1')
insert into Students
values ('AV0807012', N'Nguyễn Tuấn Nam', '2/3/1990', 'tuannam@yahoo.com', '', 'AV1')

---Subjects
insert into Subjects
values ('S001', 'SQL')
insert into Subjects
values ('S002', 'Java Simplefield')
insert into Subjects
values ('S003', 'Acuve Server Page')

---Mark
insert into Mark
values ('AV0807005', 'S001', '6/5/2008', 8, 25)
insert into Mark
values ('AV0807006', 'S002', '6/5/2008', 16, 30)
insert into Mark
values ('AV0807007', 'S001', '6/5/2008', 10, 25)
insert into Mark
values ('AV0807009', 'S003', '6/5/2008', 7, 13)
insert into Mark
values ('AV0807010', 'S003', '6/5/2008', 9, 16)
insert into Mark
values ('AV0807011', 'S002', '6/5/2008', 8, 30)
insert into Mark
values ('AV0807012', 'S001', '6/5/2008', 7, 31)
insert into Mark
values ('AV0807005', 'S002', '6/5/2008', 12, 11)
insert into Mark
values ('AV0807009', 'S002', '6/5/2008', 11, 20)
insert into Mark
values ('AV0807010', 'S001', '6/5/2008', 7, 6)


--Thực hiện các truy vấn:
--1. Hiển thị nội dung bảng Students
select*from Students

--2. Hiển thị nội dung danh sách sinh viên lớp AV1
SELECT * FROM  Students
WHERE class='AV1'

--3. Sử dụng lệnh UPDATE để chuyển sinh viên có mã AV0807012 sang lớp AV2
Select * from Students
UPDATE Students
Set Class = 'AV2'
Where StudentID = 'AV0807012'

--4. Tính tổng số sinh viên của từng lớp
select Class, count(class) as "tổng số sv"
from Students
group by class

--5. Hiển thị danh sách sinh viên lớp AV2 được sắp xếp tăng dần theo StudentName
SELECT StudentName
from Students
Where Class = 'AV2'
ORDER BY Class ASC;

-- 6. Hiển thị danh sách sinh viên không đạt lý thuyết môn S001 (theory <10) thi ngày 6/5/2008
select * from Students inner join Mark 
ON Students.StudentID = Mark.StudentID
Where SubjectID = 'S001' and theory < 10 and Datee = '6/5/2008'

-- 7. Hiển thị tổng số sinh viên không đạt lý thuyết môn S001. (theory <10)
select count(Class) As 'Tổng số sinh viên' 
From Students inner join Mark 
ON Students.StudentID = Mark.StudentID
Where SubjectID = 'S001' and theory < 10

-- 8.Hiển thị Danh sách sinh viên học lớp AV1 và sinh sau ngày 1/1/1980
select * from Students 
Where Class = 'AV1' and DateofBirth > '1/1/1980'

-- 9. Xoá sinh viên có mã AV0807011
DELETE FROM Students 
Where StudentID = 'AV0807011';

-- 10. Hiển thị danh sách sinh viên dự thi môn có mã S001 ngày 6/5/2008 bao gồm các trường sau: StudentID, StudentName, SubjectName, Theory, Practical, Date
select Students.StudentID,Mark.SubjectID,Theory,Practical,Datee 
from Students inner join Mark 
ON Students.StudentID = Mark.StudentID 
where SubjectID = 'S001' and Datee = '6/5/2008 '