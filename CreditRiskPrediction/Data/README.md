# Introduction

  The datasets provided here are randomly generated to mimic the type
  of data that a bank might actually use. These random datasets allow
  the scripts to be run. A data scientist can replace these random
  datasets with their own data of the same form to initiate their
  machine learning.

  We have had two versions here. The full datasets (listed below) used
  for the blog post were actually quite large and so we have replaced
  them with smaller datasets. Processing time for the originals was
  considerable and not practical for quick interactive replication.
	
# List of data sets

|  Data Set Name | Link to the Full Data Set   | Full Data Set Size (KB)  | Link to Report |
| ---:| ---: | ---: | ---: |
| transactionSimu.csv | [link](https://github.com/Microsoft/acceleratoRs/tree/master/CreditRiskPrediction/Data/transactionSimu_v3.csv) | 22,565 | N/A|
| demographicSimu.csv | [link](https://github.com/Microsoft/acceleratoRs/tree/master/CreditRiskPrediction/Data/demographicSimu_v3.csv) | 17,445 | N/A|
| processedSimu.csv | [link](https://github.com/Microsoft/acceleratoRs/tree/master/CreditRiskPrediction/Data/processedSimu.csv) | 27,883 | N/A|

# Description of data sets

* The simulated transaction dataset contains 198,576 records and 11
  variables. The columns of “transactionID” and
  “accountID” are identifiers at transaction level and account
  level, respectively. Each account may have more than one transaction
  occuring at different times. These transactions record information
  about the transaction amount, transaction type, location, merchant
  and so on.

* The simulated demographic dataset contains 184,254 records with 9
  variables. It has a common key, “accountID”, with the
  transaction data. The column of “badFlag” is the label of
  customers or accounts (assuming one customer one account),
  representing their default status. The other variables show
  information about the characteristic of customers (e.g., age,
  education, income) and bank account information (e.g., credit
  limit).

* The simulated processed dataset contains...