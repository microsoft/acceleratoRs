# List of data sets
|  Data Set Name | Link to the Full Data Set   | Full Data Set Size (KB)  | Link to Report |
| ---:| ---: | ---: | ---: |
| transactionSimu.csv | [link](https://github.com/Microsoft/acceleratoRs/tree/master/CreditRiskPrediction/Data/transactionSimu_v3.csv) | 22,565 | N/A|
| demographicSimu.csv | [link](https://github.com/Microsoft/acceleratoRs/tree/master/CreditRiskPrediction/Data/demographicSimu_v3.csv) | 17,445 | N/A|
| processedSimu.csv | [link](https://github.com/Microsoft/acceleratoRs/tree/master/CreditRiskPrediction/Data/processedSimu.csv) | 27,883 | N/A|

# Description of data sets

* TransactionSimu contains 198,576 records and 11 variables. The columns of “transaction_id” and “account_id” are identifiers at transaction level and account level, respectively. Each account has more than one transaction records occuring at different date or time. These transaction records show information about transaction amount, transaction type, location, merchant and so on.
* DemographicSimu contains 184,254 records and 9 variables. It has a common key, “account_id”, with the transaction data. The column of “bad_flag” is the label of customers or accounts (assuming one customer one account), representing their default status. The other variables show information about the characteristic of customers (e.g., age, education, income) and bank account information (e.g., credit limit).