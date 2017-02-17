# Data Science Design Pattern for Education Analytics

##Introduction 
This Data Science Design Pattern provides a starting point for the data scientist exploring a new dataset in the education world by using R. 

Education is a relatively late adopter of predictive analytics or machine learning as a management tool. Nowadays, a desire for stronger operations is leading universities or government to perform student predictive analysis, which helps in better-informed and faster decision making.
Student predictive analytics aims to solve two key problems:

- Identify students more likely to perform better academically, which helps in optimizing support.
- Foresee students at high risk of dropping out thus timely preventing attrition.

Education systems face an enormous diversity across regions and countries. The case studies in Asia show a novel and unique landscape for machine learning in the education world. 

The current version of this Design Pattern covers the above two typical use cases: 
- **Student Drop-out Prediction** In this use case, we leverage a series of ML models, two-class classification, to predict the likelihood of a student dropping out for an India State Government. 
- **Student Score Modeling** In this use case, we build a mixed effects regression model to measure the influence of student characteristics and predict students’ NAPLAN test scores in the presence of variation in students and schools for an Australian Education Department.

By no means is it the endpoint of the data science journey. The pattern is under regular revision and improvement and is provided as is.

##Getting Started
To get the code up and running on your own system, you should make sure:
- Jupyter Notebook along with Rkernel and Notedown are installed.
- R version 3.2 and 3.3 are needed.

##Directory
The following is the directory structure for this design pattern:
- **Data**    This contains the provided sample data. 

  - *studentDropIndia*  This sample dataset is simulated from student data in [UCI repository] (https://archive.ics.uci.edu/ml/datasets/Student+Performance#) and an India State Government. 
  - *studentScoreAUS*  This sample dataset is simulated from student data in [UCI repository] (https://archive.ics.uci.edu/ml/datasets/Student+Performance#) and an Australia Education Organization.

- **Code**	  This contains the R development code. They are displayed in R markdown files as well as Jupyter Notebook files. 

  - *dataStudentDropIndia*  This is the first part of the data science design pattern for student drop-out prediction, beginning with the task of preparing our data for building models using R.
  - *modelStudentDropIndia*  This is the second part of the data science design pattern for student drop-out prediction, introducing how to build multiple binary classification models using R.
  - *dataStudentScoreAUS*  This is the first part of the data science design pattern for student score modeling, beginning with the task of preparing our data for building models using R.
  - *modelStudentScoreAUS*  This is the second part of the data science design pattern for student score modeling, introducing how to build mixed effect regression models using R.
  
- **Doc**    This contains the documents, like blog, installation instructions, etc. 
 
##Build and Test
The code is built by using R Markdown and then converted into Jupyter Notebook by using Notedown. 

##Contribute
Please open and issue if you find something that doesn't work as expected or have questions or suggestions. Note that this project is released with a [Guide to Contributing](CONTRIBUTING.md) and a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.
