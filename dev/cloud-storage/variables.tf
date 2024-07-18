variable "cloud_storage" {
  description = "cloud storage"
  type = list(object({
    project_id = string
    name       = string
    location   = string
    versioning = bool
    labels     = map(string)
    public_access_prevention = string
    
  }))
}
