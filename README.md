# ☁️ NUWE Cloud AWS Challenge - S3SL ➿

Category   ➡️   Cloud AWS

Subcategory   ➡️   AWS Cloud Engineer (IaC Terraform)

Difficulty   ➡️   (Easy)

---

## 🌐 Background

In a world dominated by data, automation has emerged as a critical solution for managing tasks effectively. One of the first steps is to process the immense amount of data that a dataset can contain, and one of the most typical problems is having negative values where you should not.

Your objective? Develop an infrastructure capable of dealing with this data in an automated and orderly way, applying the corresponding steps at each stage. 

All this app must be **serverless**, and developed using **Terraform** as IaC.

## 📂 Repository Structure
```bash
nuwe-cloud-S3SL/
├── test_input.csv
├── Infraestructure
│   ├── lambda
│   │   ├── lambda1
│   │   ├── lambda2
│   │   └── Other files required
│   └── Terraform
│       ├── main.tf
│       └── Other files required
└── README.md
```

## 🎯 Tasks

- **Task 1**: Ensure the main.tf file is correctly set up and ready for application.
- **Task 2**: Deploy all the proposed AWS resources successfully.
- **Task 3**: Verify that the State Machine is operational and executes as intended.
- **Task 4**: Confirm that Lambda functions are performing their tasks correctly.

### ❓ Guides

- Resources to be deployed: 
    - **S3 Buckets** 
    - **Lambda** 
    - **StepFunctions**

- The correction of this challenge will be done in an automated way, so meeting the objectives is crucial. To this end, some naming guidelines will be given so that the correct functioning of the infrastructure can be tested:
    - **S3 Buckets names**: 
        - **input-bucket**
        - **output-bucket**
    - **Lambdas**:
        - **ProcessCSVFunction**: Takes a file called test_input.csv as a starting point from the first s3 bucket and transforms all negative values to 0.
        - **AddColumnFunction**: This second step adds a new column to the csv file about the age group. In this case what we will do is to divide it into two groups:
            - `< 5 years` -> The value will be 0
            - `>= 5 years` -> The value will be 1
        - **SaveToS3Function**: This third step simply saves the resulting file in the output bucket.
    - **StepFunctions**:
        - **CSVProcessingWorkflow**: Contains the workflow and the order in which the functions must be executed to accomplish the required task.

- The test files will always be named **test_input.csv** and the resulting **processed_test_input.csv**. Once the workflow is completed, the buckets should contain:
    - input-bucket: 
        - `test_input.csv` -> Original file provided
        - `processed_test_input.csv` -> File with the first processing
    - output-bucket:
        - `processed_test_input.csv` -> Final file with all the processing

- **Development environment**: Localstack. In order for the correction to be carried out, it will be necessary to develop everything for localstack, since it does not require personal keys of any kind. Some data to take into account:
    - Region: us-east-1
    - access_key: test
    - secret_key: test

- **Extra resources:** In case you have problems in the operation of the lambda functions, it may be due to how the containers interact with each other.
So it will be necessary to declare the resources in this way:
```python
endpoint_url = f"http://{os.environ.get('LOCALSTACK_HOSTNAME')}:{os.environ.get('EDGE_PORT')}"
s3 = boto3.client('s3', endpoint_url=endpoint_url, region_name='us-east-1')
```
This would be an example for lambda to interact with S3, but it works the same way for all other services.

- **Example final output**:
```csv
Id,Name,Age,AgeGroup
75400571,Claudia Horton MD,0,0
10286057,Sandra Wood,47,1
24488493,Taylor Wilson,5,1
```

- The lambda function must be written in python3.

## 📤 Submission

1. Solve the proposed objectives.
2. Continuously push the changes you have made.
3. Wait for the results.
4. Click submit challenge when you have reached your maximum score.


## 📊 Evaluation

The final score will be given on the basis of whether or not the objectives have been met.

In this case, the challenge will be evaluated on 900 points which are distributed as follows:

- **Task 1**: 225 points
- **Task 2**: 225 points
- **Task 3**: 225 points
- **Task 4**: 225 points

## ❓FAQs / Additional Information

- **Is it important to respect the guidelines that have been given?** It is important to respect the guidelines that have been provided, as the automatic correction tests the correct performance of the infrastructure, dividing this functioning into objectives from the simplest to the most complex.

- **What happens if I don't follow these guidelines?** You may not meet the proposed objectives, which will lead to a points penalty.

- **Can I modify the given base structure?** It is possible to modify the way in which the content within these folders is structured. Terraform apply will be executed inside the /Terraform folder, but you cannot move those parent folders as the correction will fail.

- **Can I order the functions within /lamba as I want?** Yes, but remember that your main.tf must be consistent with it.


