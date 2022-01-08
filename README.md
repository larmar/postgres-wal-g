# postgres-wal-g
Setup postgresql database version 12-14 to run with wal-g archiving.

# Prerequsite

Create a file called docker-env-file fill it with data accoring to your environment.

    AWS_ACCESS_KEY_ID=*required*
    AWS_SECRET_ACCESS_KEY=*required*
    AWS_REGION=*required (avoid adding permissions on aws)*
    WALG_S3_PREFIX=*required (s3://bucket-name/custom-path)*

# Start a new empty database in archiving mode
