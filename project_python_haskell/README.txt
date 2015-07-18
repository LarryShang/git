1. Run the Main.py to start the DBMS. This program based on python 3

2. "Create database" option would require the table name, count and the name and type for each column. An index column name should also be assigned in the end. For example, in SalesDB, the index column name is "order".

3. The options from 2 to 7 in the main menu based on the first one "Create database". They may not work properly if no database is created first.

4. In "Display Join" option, there is a little difference from the original requirement. I didn't print the join result to the screen. Because it could be upto 10000 lines in total. So I directly wrote the results to the file. The file named as "SalesDB_join_CustDB.slc" 

5. "Run Query" should be used like this:
Input a Query: SELECT cust,name FROM CustDB WHERE (age,GT,60)

6. The report function would read *.slc files to generate report.

7. The Haskell source code of the report is in "report" folder