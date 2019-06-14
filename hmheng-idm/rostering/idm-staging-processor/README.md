# IDM Rostering - IDM Staging Processor (SP)

Here lies the AWS infrastructure setup of the IDM Staging Processor, a generic import and exporting service for rostering based imports from Districts and Independant school.

Resouces include:

* A sqs queue for the staging processor importer.
* A sqs queue for the staging processor exporter.
* An iam role for the importer to consume messages from and interact with the sqs queue.
* An iam role for the importer to write messages to the exporter queue.
* An iam role for the exporter to consume messages from the exporter queue.