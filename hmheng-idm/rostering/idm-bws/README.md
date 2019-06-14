# IDM Rostering - Background Work Service (BWS)

Here lies the AWS infrastructure setup of the BWS, a background service for rostering workloads including:

* A queue for batch end workloads, used for error file generation, created user email sending.
* A queue for large workloads such as batchjob archiving.