# IDM Rostering - State Service

Here lies the AWS infrastructure setup of the State Service, consistening of two DynamoDB Tables and the IAM Role Policy required to access them.

The Rostering Meta data is used to hold meta data information for each district in the rostering system.

The Rostering User table is a table which takes account for all successfully created user accounts, what platforms they have been created in and if they have been sent an activation email for their account.