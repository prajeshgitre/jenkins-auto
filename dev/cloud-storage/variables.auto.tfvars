project = {
  name            = "axisroom-poc-01",
  service_account = "sa-test-vm-01@axisroom-poc-01.iam.gserviceaccount.com"
}
//Cloud Storage
cloud_storage = [

  {
    project_id = "axisroom-poc-01"
    name       = "bucket-dev-jenkin"
    location   = "asia-south1"
    versioning = true
    public_access_prevention = "inherited"
    labels = {
        "owner_email": ""
    },
    
  },
  ]
