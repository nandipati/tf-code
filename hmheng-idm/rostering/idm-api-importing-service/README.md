# IDM Rostering - API Importing Service (AIS)

Here lies the AWS infrastructure setup of the AIS, a data extractor for 3rd party rostering APIs (Clever / OneRoster). Resources here include:

* A queue which is populated with import requests from EBR and consumed by AIS.
* IAM Roles for this Queue
* IAM Roles for access to the IDM S3 Bucket