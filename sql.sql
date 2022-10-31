Select * from datum

--Converting sale date format

select SaleDate, CONVERT(Date,SaleDate) from datum;

alter table datum
add SaleDateConv Date;

Update datum
set SaleDateConv=CONVERT(Date,SaleDate);
