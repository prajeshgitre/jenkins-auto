
//Cloud Storage
cloud_storage = [

  {
    project_id = "axisroom-poc-01"
    name       = "bucket-dev-as"
    location   = "asia-south1"
    versioning = true
    public_access_prevention = "inherited"
    labels = {
        "owner_email": "jenkins"
    },
    
  },
  ]
